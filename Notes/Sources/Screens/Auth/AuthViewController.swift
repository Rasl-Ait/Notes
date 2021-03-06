//
//  AuthViewController.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit
import WebKit

protocol AuthViewControllerDelegate: class {
	func handleTokenChanged(token: String)
}

class AuthViewController: UIViewController {
	
	private let webView = WKWebView()
	
	weak var delegate: AuthViewControllerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		guard let request = tokenGetRequest else { return }
		webView.load(request)
		webView.navigationDelegate = self
	}
	
	// MARK: Private
	private func setupViews() {
		view.backgroundColor = .white
		webView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(webView)
		NSLayoutConstraint.activate([
			webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			webView.topAnchor.constraint(equalTo: view.topAnchor),
			webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
			])
	}
	
	private var tokenGetRequest: URLRequest? {
		guard var urlComponents = URLComponents(string: AuthAPI.authorize) else { return nil }
		
		urlComponents.queryItems = [
			URLQueryItem(name: "client_id", value: "\(AuthAPI.clientId)"),
			URLQueryItem(name: "scope", value: AuthAPI.gist)
		]
		
		guard let url = urlComponents.url else { return nil }
		return URLRequest(url: url)
	}
}

extension AuthViewController: WKNavigationDelegate {
	
	func codeResponse(_ url: URL) -> String? {
		return url.query?.components(separatedBy: "code=").last
	}
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		if let url = navigationAction.request.url, url.scheme == AuthAPI.callback {
			let tokenPath: String = AuthAPI.tokenPath
			let code = codeResponse(url)
			
			guard var components = URLComponents(string: tokenPath) else { return }
			components.queryItems = [URLQueryItem(name: "client_id", value: AuthAPI.clientId),
															 URLQueryItem(name: "client_secret", value: AuthAPI.clientSecret),
															 URLQueryItem(name: "code", value: code)]
			
			guard let url = components.url else { return }
			var request = URLRequest(url: url)
			request.httpMethod = HTTPMethods.post.rawValue
			let headers = [HTTPHeader.accept("application/json")]
			headers.forEach { request.addValue($0.header.value, forHTTPHeaderField: $0.header.field) }
			
			URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let response = response as? HTTPURLResponse {
					switch response.statusCode {
					case 200..<300:
						if let data = data {
							do {
								if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
									if let token = json["access_token"] as? String {
										self.delegate?.handleTokenChanged(token: token)
									}
								}
							} catch {
								print(error)
							}
						}
					default:
						print("Status: \(response.statusCode)")
					}
				}
				}.resume()
			
			dismiss(animated: true, completion: nil)
		}
		do {
			decisionHandler(.allow)
		}
	}
}
