//
//  NetworkDataFetcher.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol DataFetcher {
	func fetchGenericJSONData<T: Decodable>(
		path: String,
		allParams: [String : String],
		httpMethod: String,
		headers: [HTTPHeader],
		httpBody: Data?,
		completion: @escaping ApiCompletionBlock<T>
	)
	
func fetchJsonObject(
	urlString: String,
	httpMethod: String,
	completion: @escaping CompletionBlock<[[String : Any]]?>
	)
	
	func fetchGenericEncodeData<T: Codable>(parameters: T) -> Data? 
}

class NetworkDataFetcher: DataFetcher {
	let networking: Networking
	
	init(networking: Networking = NetworkService()) {
		self.networking = networking
	}
	
	func fetchGenericJSONData<T: Decodable>(
		path: String,
		allParams: [String : String],
		httpMethod: String, headers: [HTTPHeader],
		httpBody: Data?,
		completion: @escaping ApiCompletionBlock<T>) {
		networking.request(path: path,
											 allParams: allParams,
											 httpMethod: httpMethod,
											 headers: headers, httpBody: httpBody) { result in
	
			switch result {
			case .success(let data):
				guard let response = self.decodeJSON(type: T.self, data: data) else { return }
				completion(.success(response))
			case .failure(let error):
				completion(.failure(APIError.jsonConversionFailure(description: "\(error.localizedDescription)")))
			}
		}
	}
	
	func fetchGenericEncodeData<T: Codable>(parameters: T) -> Data? {
		guard let data = self.encodeJSON(type: parameters) else { return nil }
		return data
	}
	
	func fetchJsonObject(urlString: String, httpMethod: String, completion:
		@escaping CompletionBlock<[[String : Any]]?>) {
		
		networking.url(urlString: urlString, httpMethod: httpMethod) { result in
			switch result {
			case .success(let data):
				guard let response = self.jsonObject(data: data) else { return }
				completion(.success(response))
			case .failure(let error):
				completion(.failure(APIError.jsonConversionFailure(description: "\(error.localizedDescription)")))
			}
		}
	}
	
	func jsonObject(data: Data) -> [[String: Any]]? {
		
		do {
			let result = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
			return result
		} catch let jsonError {
			DDLogError("Failed to JSONSerialization JSON \(jsonError)")
			return nil
		}
	}
	
	func decodeJSON<T: Decodable>(type: T.Type, data: Data) -> T? {
		
		do {
			let decoder = JSONDecoder()
			let result = try decoder.decode(type.self, from: data)
			return result
		} catch let jsonError {
			DDLogError("Failed to decode JSON \(jsonError)")
			return nil
		}
	}
	
	func encodeJSON<T: Codable>(type: T) -> Data? {
		
		do {
			let encode = JSONEncoder()
			let result = try encode.encode(type)
			return result
		} catch let jsonError {
			DDLogError("Failed to encode JSON \(jsonError)")
			return nil
		}
	}
}

