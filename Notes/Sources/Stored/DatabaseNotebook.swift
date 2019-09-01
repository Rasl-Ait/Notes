//
//  DatabaseNotebook.swift
//  Notes
//
//  Created by rasl on 29/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CoreData

class DatabaseNotebook: NoteStorageProtocol {
	var notes = [Note]()
	

	
	private let backgroundContext: NSManagedObjectContext!
	//private let note: Note
	
	init(backgroundContext: NSManagedObjectContext) {
		self.backgroundContext = backgroundContext
	}
	
	func add(_ note: Note) {
		
	}
	
	func updateData(result: [Note]) {
		
	}
	
	func remove(with uid: String) {
		
	}
	
	func saveToFile() {
		
	}
	
	func loadFromFile() {
		
	}
	
//	func save() {
//		backgroundContext.perform { [weak self] in
//			guard let `self` = self else { return }
//			let noteEntity = NoteEntity.find(byUid: self.note.uid, context: self.backgroundContext)
//			self.note.createNoteEntity(noteEntity)
//			self.backgroundSave()
//			self.state = .finished
//		}
//	}
	
	private func backgroundSave() {
		do {
			try self.backgroundContext.save()
		} catch {
			print("не удалось сохранить данные \(error)")
		}
	}
}
