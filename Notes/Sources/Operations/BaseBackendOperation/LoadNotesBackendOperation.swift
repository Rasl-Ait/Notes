//
//  LoadNotesBackendOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
	case success([Note])
	case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
	private(set) var result: LoadNotesBackendResult?
	private var notes = [Note]()

	let dataFetcherService = DataFetcherService()

	override func main() {
		dataFetcherService.fetchGist() { results in
			switch results {
			case .success(let gists):
				guard let gist = gists?.first(where: {$0.files.keys.contains(GithubAPI.filename)}) else {
					UserDefaults.removeGistID()
					self.result = .failure(.unknownError)
					self.state = .finished
					return
				}
				
				DDLogInfo("The requested gists data was successfully received.")

				let rawURL = gist.files[GithubAPI.filename]?.rawUrl ?? ""

				self.dataFetcherService.fetchGists(urlString: rawURL) { results in
					switch results {
					case .success(let json):
						self.notes = (json?.compactMap { return Note.parse(json: $0) } ?? nil)!
						self.result = .success(self.notes)
						self.state = .finished
						DDLogInfo("The requested json data was successfully received.")
					case .failure(let error):
						DDLogError("Failed received requesting data: \(error)")
						self.result = .failure(.unreachable)
						self.state = .finished
					}
				}

			case .failure(let error):
				DDLogError("Failed received requesting data: \(error)")
				self.result = .failure(.unreachable)
				self.state = .finished
			}
		}
	}
}
