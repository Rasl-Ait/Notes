//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

enum LoadNotesBackendResult {
	case success([Note])
	case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
	private(set) var result: LoadNotesBackendResult?
	private var notes = [Note]()
	
	override func main() {
		let stringUrl = "https://api.github.com/gists"
		guard let url = URL(string: stringUrl) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		request.setValue("token \(UserDefaults.token)", forHTTPHeaderField: "Authorization")
		let task = session.dataTask(with: request) { data, response, error in
			guard let response = response as? HTTPURLResponse else {
				self.result = .failure(.unreachable)
				return
			}
			switch response.statusCode {
			case 200..<300:
				guard let data = data else { return }
				let decoder = JSONDecoder()
				guard let gists = try? decoder.decode([Gist].self, from: data) else { return }
				guard let gist = gists.first(where: {$0.files.keys.contains(GithubAPI.filename)}) else {
					UserDefaults.removeGistID()
					self.result = .failure(.unknownError)
					self.state = .finished
					return
				}
				
				self.loadGists(gist: gist)
				
			default:
				print("Status: \(response.statusCode)")
				self.result = .failure(.unreachable)
				self.state = .finished
			}
		}
		task.resume()
	}
	
	private func loadGists(gist: Gist) {
		let rawURL = gist.files[GithubAPI.filename]?.rawUrl ?? ""
		
		guard let url = URL(string: rawURL) else { fatalError("invalid url") }
		let task = session.dataTask(with: url) { (data, response, error) in
			if let response = response as? HTTPURLResponse {
				switch response.statusCode {
				case 200..<300:
					guard let data = data else { return }
					guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
						return
					}
					
					self.notes = json.compactMap {
						return Note.parse(json: $0)
					}
					
					self.result = .success(self.notes)
					self.state = .finished
					
				default:
					print("Status: \(response.statusCode)")
					self.result = .failure(.unreachable)
					self.state = .finished
				}
			}
		}
		task.resume()
	}
}

