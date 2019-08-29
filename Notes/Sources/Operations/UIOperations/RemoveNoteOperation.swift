//
//  RemoveNoteOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
	private let removeToDb: RemoveNoteDBOperation
	private let dbQueue: OperationQueue
	
	private(set) var result: SaveNotesBackendResult? = nil
	
	init(note: Note,
			 notebook: FileNotebook,
			 backendQueue: OperationQueue,
			 dbQueue: OperationQueue) {
		
		removeToDb = RemoveNoteDBOperation(note: note, notebook: notebook)
		self.dbQueue = dbQueue
		
		super.init()
		
		removeToDb.completionBlock = {
			let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
			saveToBackend.completionBlock = {
				self.result = saveToBackend.result
				self.state = .finished
			}
			backendQueue.addOperation(saveToBackend)
		}
	}
	
	override func main() {
		dbQueue.addOperation(removeToDb)
	}
}

