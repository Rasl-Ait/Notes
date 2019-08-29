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

	let dataFetcherService = DataFetcherService()
	
	init(notes: [Note]) {
		self.notes = notes
		super.init()
	}
	
	override func main() {
		
		dataFetcherService.postGist(notes: notes) { (results) in
			switch results {
			case .success(let gist):
				guard let id = gist?.id else {return }
				// сохраняем gist id
				UserDefaults.setGistID(id)
				self.result = .success
				self.state = .finished
			case .failure(let error):
				DDLogError("Failed received requesting data: \(error)")
				self.result = .failure(.unknownError)
				self.state = .finished
			}
		}
	}
}
