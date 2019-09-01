//
//  NotesViewPresenter.swift
//  Notes
//
//  Created by rasl on 31/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

protocol NotesViewPresenterProtocol {
	var numberOfNotes: Int { get }
	func viewDidLoad()
	func viewDidAppear()
	func configure(cell: NotesCellView, forRow row: Int)
	func loadNotesOperation()
	func didSelect(row: Int)
	func delete(row: Int)
	func addButtonPressed()
}

class NotesViewPresenter {
	private var notes = [Note]()
	private let database: NoteStorageProtocol
	private weak var view: NotesView?
	private let router: NotesViewRouterProtocol
	
	init(view: NotesView, router: NotesViewRouterProtocol, database: NoteStorageProtocol) {
		self.view = view
		self.router = router
		self.database = database
	}
}

// MARK: - NotesPresenterProtocol
extension NotesViewPresenter: NotesViewPresenterProtocol {
	func delete(row: Int) {
		let note = notes[row]
				notes.remove(at: row)
				let removeNoteOperation = RemoveNoteOperation(
					note: note,
					database: database,
					backendQueue: backendQueue,
					dbQueue: dbQueue
				)
		
				commonQueue.addOperation(removeNoteOperation)
				view?.deleteAnimated(row: row)
	}
	
	func didSelect(row: Int) {
		let note = notes[row]
		router.presentDetailsView(note: note, database: database)
	}
	
	func addButtonPressed() {
		router.presentAddBook(database: database)
	}
	
	func viewDidLoad() {
		loadNotesOperation()
	}
	
	func viewDidAppear() {
		notes = database.notes
		view?.refreshNotesView()
	}
	
	var numberOfNotes: Int {
		return notes.count
	}
	
	func loadNotesOperation() {
		let loadNotesOperation = LoadNotesOperation(
			database: database,
			backendQueue: backendQueue,
			dbQueue: dbQueue
		)
		
		loadNotesOperation.completionBlock = {
			DispatchQueue.main.async { [weak self] in
				guard
					let `self` = self,
					let result = loadNotesOperation.result
					else { return }
				self.notes = result
				self.view?.refreshNotesView()
			}
		}
		
		commonQueue.addOperation(loadNotesOperation)
	}
	
	func configure(cell: NotesCellView, forRow row: Int) {
		let note = notes[row]
		cell.displayTitle(title: note.title)
		cell.displayContent(content: note.content)
		cell.displayColorView(color: note.color)
	}
}

