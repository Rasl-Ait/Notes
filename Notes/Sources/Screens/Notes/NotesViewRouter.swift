//
//  NotesViewRouter.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol NotesViewRouterProtocol  {
	func presentDetailsView(note: Note, database: NoteStorageProtocol)
	func presentAddBook(database: NoteStorageProtocol)
}

class NotesViewRouter: NotesViewRouterProtocol {
	private weak var notesViewController: NotesViewController?
	
	init(notesViewController: NotesViewController) {
		self.notesViewController = notesViewController
	}
	
	func presentDetailsView(note: Note, database: NoteStorageProtocol) {
		let editController = EditViewController(configurator: EditConfigurator())
		editController.note = note
		editController.database = database
		notesViewController?.navigationController?.pushViewController(editController, animated: true)
	}
	
	func presentAddBook(database: NoteStorageProtocol) {
		let editController = EditViewController(configurator: EditConfigurator())
		editController.database = database
		notesViewController?.navigationController?.pushViewController(editController, animated: true)
		
		
	}
}

