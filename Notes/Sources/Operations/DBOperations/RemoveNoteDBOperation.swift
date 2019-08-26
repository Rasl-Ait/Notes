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
	
	init(note: Note, notebook: FileNotebook) {
		self.note = note
		super.init(notebook: notebook)
	}
	
	override func main() {
		notebook.remove(with: note.uid)
		notebook.saveToFile()
		self.state = .finished
	}
}
