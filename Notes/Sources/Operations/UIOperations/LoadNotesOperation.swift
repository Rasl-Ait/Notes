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
	
	private(set) var result: [Note]?
	
	init(notebook: FileNotebook,
			 backendQueue: OperationQueue,
			 dbQueue: OperationQueue) {
		
		loadToDb = LoadNotesDBOperation(notebook: notebook)
		self.dbQueue = dbQueue
		
		super.init()
		
		loadToDb.completionBlock = {
			let loadToBackend = LoadNotesBackendOperation()
			loadToBackend.completionBlock = {
				switch loadToBackend.result! {
				case .success(let notes):
					notebook.updateData(result: notes)
					self.result = notes
				case .failure:
					self.result = self.loadToDb.result
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
