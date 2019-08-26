//
//  LoadNotesOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
	private let loadToDb: LoadNotesDBOperation
	private let dbQueue: OperationQueue
	
	private(set) var result: Bool? = false
	
	init(notebook: FileNotebook,
			 backendQueue: OperationQueue,
			 dbQueue: OperationQueue) {
		
		loadToDb = LoadNotesDBOperation(notebook: notebook)
		self.dbQueue = dbQueue
		
		super.init()
		
		loadToDb.completionBlock = {
			let loadToBackend = LoadNotesBackendOperation(notes: notebook.notes)
			loadToBackend.completionBlock = {
				switch loadToBackend.result! {
				case .success:
					self.result = true
				case .failure:
					self.result = false
				}
				self.state = .finished
			}
			backendQueue.addOperation(loadToBackend)
		}
	}
	
	override func main() {
		dbQueue.addOperation(loadToDb)
	}
}
