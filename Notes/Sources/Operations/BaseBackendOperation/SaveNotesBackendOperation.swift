//
//  SaveNotesBackendOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum SaveNotesBackendResult {
	case success
	case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
	var result: SaveNotesBackendResult?
	
	private(set) var notes: [Note]
	private let descriptionNotes = "Notes Examples"
	private var components: URLComponents?
	private var httpMethod = HTTPMethod.post.rawValue
	
	init(notes: [Note]) {
		self.notes = notes
		super.init()
	}
	
	override func main() {
		guard let baseURL = URL(string: "https://api.github.com/gists") else {
			result = .failure(.clientError)
			return
		}
		
		components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		
		// тут проверяем существует ли gist, если да то обновляем, если нет то создаем новый
		if !UserDefaults.gistID.isEmpty {
			httpMethod = HTTPMethod.patch.rawValue
			components = URLComponents(url: baseURL.appendingPathComponent(UserDefaults.gistID), resolvingAgainstBaseURL: false)!
		}
		
		let gist = createGist(notes: notes)
		
		guard let url = components?.url else { return }
		var request = URLRequest(url: url)
		request.httpMethod = httpMethod
		
		do {
			request.httpBody = try JSONEncoder().encode(gist)
		}
		catch let error {
			print(error.localizedDescription)
		}
		
		request.setValue("token \(UserDefaults.token)", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: request) { [weak self]  data, response, error in
			guard let `self` = self else { return }
			guard let response = response as? HTTPURLResponse else {
				self.result = .failure(.unreachable)
				return
			}
			switch response.statusCode {
			case 200..<300:
				guard let data = data else { return }
				let decoder = JSONDecoder()
				guard let gist = try? decoder.decode(Gist.self, from: data) else { return }
				
				// сохраняем gist id
				UserDefaults.setGistID(gist.id)
				
				self.result = .success
				self.state = .finished
			case 300..<400:
				UserDefaults.removeToken()
				self.result = .failure(.unauthorized)
				self.state = .finished
			case 400..<500:
				self.result = .failure(.clientError)
				self.state = .finished
			default:
				print("Status: \(response.statusCode)")
				self.result = .failure(.unknownError)
				self.state = .finished
			}
		}
		task.resume()
	}
	
	func createGist(notes: [Note])-> PostGist? {
		//создаем данные для нового файла
		guard let jsonData = try? JSONSerialization.data(withJSONObject:
			notes.map{ $0.json}, options: []) else {
				DDLogError("Failed to serialize note")
				return nil
		}
		
		guard let content = String(data:
			jsonData, encoding: String.Encoding.utf8) else { return nil }
		
		let files = [GithubAPI.filename: GistFileContent(content: content)]
		let newGist = PostGist(public: false, description: descriptionNotes, files: files)
		return newGist
	}
}

