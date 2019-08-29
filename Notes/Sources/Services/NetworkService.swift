//
//  NetworkService.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension HTTPURLResponse {
	var hasSuccessStatusCode: Bool {
		return 200...299 ~= statusCode
	}
}

protocol Networking {
	var session: URLSession { get }
	func request(path: String, allParams: [String: String], httpMethod: String, headers:
		[HTTPHeader], httpBody: Data?, completion: @escaping CompletionBlock<Data>) 
	
	func url(urlString: String, httpMethod: String, completion: @escaping CompletionBlock<Data>)
}

class NetworkService: Networking {
	var session: URLSession
	
	
	init() {
		//создание URLSession без кеша
		let config = URLSessionConfiguration.default
		config.requestCachePolicy = .reloadIgnoringLocalCacheData
		config.urlCache = nil
		session = URLSession.init(configuration: config)
	}
	
	func request(path: String, allParams: [String: String], httpMethod: String, headers:
		[HTTPHeader], httpBody: Data?, completion: @escaping CompletionBlock<Data>) {
	  let url = self.url(from: path, params: allParams)
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod
		request.httpBody = httpBody
		headers.forEach { request.setValue($0.header.value, forHTTPHeaderField: $0.header.field)}
		let task = createDataTask(from: request, completion: completion)
		task.resume()
	}
	
	func url(urlString: String, httpMethod: String, completion: @escaping CompletionBlock<Data>) {
		guard let url = URL(string: urlString) else {
			completion(.failure(APIError.invalidURL))
			return
			
		}
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod
		let task = createDataTask(from: request, completion: completion)
		task.resume()
	}
	
	private func createDataTask(from request: URLRequest, completion:
		@escaping CompletionBlock<Data>) -> URLSessionDataTask {
		
		return session.dataTask(with: request) { data, response, error in
			guard let httpResponse = response as? HTTPURLResponse else {
				completion(.failure(APIError.requestFailed(description: error?.localizedDescription ?? "NO")))
				return
			}
			
			switch httpResponse.statusCode {
			case 200..<300:
				guard let data = data else {
					completion(.failure(APIError.invalidData))
					return
				}
				
				DispatchQueue.main.async {
					completion(.success(data))
				}
				
			default:
				DDLogError("Status: \(httpResponse.statusCode)")
				completion(.failure(APIError.responseUnsuccessful(description: "\(httpResponse.statusCode)")))
			}
		}
	}
	
	private func url(from path: String, params: [String: String]) -> URL {
		var components = URLComponents()
		components.scheme = GithubAPI.scheme
		components.host = GithubAPI.host
		components.path = path
		components.queryItems = params.map {  URLQueryItem(name: $0, value: $1) }
		return components.url!
	}
}
