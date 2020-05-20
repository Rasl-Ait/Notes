//
//  DatabaseNotebook.swift
//  Notes
//
//  Created by rasl on 29/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CoreData

class DatabaseNotebook {
	var notes = [Note]()
	
	private let backgroundContext: NSManagedObjectContext!
	private let context: NSManagedObjectContext!
	
	init(context: NSManagedObjectContext, backgroundContext: NSManagedObjectContext) {
		self.context = context
		self.backgroundContext = backgroundContext
		
		NotificationCenter.default.addObserver(self, selector: #selector(managedObjectContextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func managedObjectContextDidSave(notification: Notification) {
		context.perform {
			self.context.mergeChanges(fromContextDidSave: notification)
		}
	}
}

extension DatabaseNotebook: NoteStorageProtocol {
	func add(_ note: Note) {
		let noteEntity = NoteEntity.find(byUid: note.uid, context: backgroundContext)
		note.createNoteEntity(noteEntity)
		saveToFile()
	}
	
	func updateData(result: [Note]) {
		
	}
	
	func remove(with uid: String) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteEntity")
		fetchRequest.includesPropertyValues = false
		fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
		let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
		
		do {
			try self.backgroundContext.execute(delete)
			try self.backgroundContext.save()
		} catch {
			print ("There was an error with cleaning data...")
		}
	}
	
	func saveToFile() {
		do {
			try self.backgroundContext.save()
		} catch {
			print("не удалось сохранить данные \(error)")
		}
	}
	
	func loadFromFile() -> [Note] {
		let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
		request.sortDescriptors = [sortDescriptor]
		var notes = [Note]()
		
		do {
			let fetchResult = try self.backgroundContext.fetch(request)
			fetchResult.forEach {
				
				guard let note = Note.getNotes(model: $0) else { return }
				notes.append(note)
			}
		} catch {
			print(error)
		}
		return notes
	}
}
