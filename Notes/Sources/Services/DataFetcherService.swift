//
//  DataFetcherService.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

class DataFetcherService {
	let dataFetcher: DataFetcher
	
	private var httpMethod = HTTPMethods.get.rawValue
	private let descriptionNotes = "Notes Examples"
	
	init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
		self.dataFetcher = dataFetcher
	}
	
	// Функция для сохранения gist
	func postGist(notes: [Note], completion: @escaping ApiCompletionBlock<Gist?>) {
		var path = GithubAPI.gists
		
		// тут проверяем существует ли gist, если да то обновляем, если нет то создаем новый
		if !UserDefaults.gistID.isEmpty {
			httpMethod = HTTPMethods.patch.rawValue
			path += "/\(UserDefaults.gistID)"
		}

		httpMethod = HTTPMethods.post.rawValue
	  let gist = createGist(notes: notes)
    let data = dataFetcher.fetchGenericEncodeData(parameters: gist)
    let headers = [HTTPHeader.authorization("token \(UserDefaults.token)")]
		dataFetcher.fetchGenericJSONData(path: path, allParams: [:], httpMethod: httpMethod, headers: headers, httpBody: data, completion: completion)
	}
	
	// Функция для загрузки gist
	func fetchGist(completion: @escaping ApiCompletionBlock<[Gist]?>) {
		let headers = [HTTPHeader.authorization("token \(UserDefaults.token)")]
	  dataFetcher.fetchGenericJSONData(path: GithubAPI.gists, allParams: [:], httpMethod: httpMethod, headers: headers, httpBody: nil, completion: completion)
	}
	
	// Функция для загрузки gists
	func fetchGists(urlString: String, completion: @escaping CompletionBlock<[[String: Any]]?>) {
		dataFetcher.fetchJsonObject(urlString: urlString, httpMethod: httpMethod, completion: completion)
	}
	
	private func createGist(notes: [Note])-> PostGist? {
		//создаем данные для нового файла
		guard let jsonData = try? JSONSerialization.data(withJSONObject:
			notes.map{ $0.json}, options: []) else {
				DDLogError("Failed to serialize note")
				return nil
		}
		
		guard let content = String(data:
			jsonData, encoding: String.Encoding.utf8) else { return nil }
		
		let files = [GithubAPI.filename: GistFileContent(content: content)]
		let newGist = PostGist(public: true, description: descriptionNotes, files: files)
		return newGist
	}
}
