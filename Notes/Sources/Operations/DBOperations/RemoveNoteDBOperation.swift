//
//  RemoveNoteDBOperation.swift
//  Notes
//
//  Created by rasl on 26/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
	private let note: Note
	
	init(note: Note, database: NoteStorageProtocol) {
		self.note = note
		super.init(database: database)
	}
	
	override func main() {
		database.remove(with: note.uid)
		database.saveToFile()
		self.state = .finished
	}
}
