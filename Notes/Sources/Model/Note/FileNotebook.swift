//
//  FileNotebook.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

protocol NoteStorageProtocol: class {
	var notes: [Note] { get }
	func add(_ note: Note)
	func updateData(result: [Note])
	func remove(with uid: String)
	func saveToFile()
	func loadFromFile() -> [Note]
}

class FileNotebook: NoteStorageProtocol {
	private(set) var notes = [Note]()
	
	private let filename = "notes.json"
	private let fm = FileManager.default
	
	// Функция для добавления заметки
	public func add(_ note: Note) {
		guard let index = firstIndex(with: note.uid) else {
			// если не существует, просто добавляем
			notes.append(note)
			DDLogInfo("Added note with uid=\(note.uid)")
			return
		}
		// если заметка с таким uid уже существует, обновляем заметку
		notes[index] = note
		DDLogInfo("updated note with UID=\(note.uid)")
	}
	
	func updateData(result: [Note]) {
		notes = result
		saveToFile()
	}
	
	// Функция для удаления заметки по индексу
	public func remove(with uid: String) {
		guard let index = firstIndex(with: uid) else {
			DDLogError(
				"Failed to delete note: note with uid=\(uid) doesn't exists")
			return
		}
		
		notes.remove(at: index)
		DDLogInfo("delete note with uid=\(uid)")
	}
	
	private func firstIndex(with uid: String) -> Int? {
		return notes.firstIndex(where: {$0.uid == uid})
	}
	
	private func dataJson() -> Data? {
		let json = notes.map{ $0.json }
		
		do {
			let data = try JSONSerialization.data(withJSONObject: json, options: [])
			return data
		} catch {
			DDLogError("Failed to encode notes from \(json)")
		}
		return nil
	}
	
	// Функция для сохранения заметок в FileManager
	public func saveToFile() {
		let isDir: ObjCBool = false
		let directory = FileManager.getCachesDirectory()
		guard let fileURL = try? FileManager.getfileURL(filename: filename) else {
			DDLogError("Failed to get path")
			return
		}
		print(directory)
		guard FileManager.createDirectory(withFolderName: filename) ||
			isDir.boolValue == false else { return }
		
		try? fm.createDirectory(at: directory,
														withIntermediateDirectories: true,
														attributes: nil)
		
		do {
			let data = dataJson()
			try data?.write(to: fileURL)
			DDLogInfo("Saved \(notes.count) notes")
		} catch {
			DDLogError("Failed to create file \(error.localizedDescription)")
		}
	}
	
	// Функция для загрузки заметок из FileManager
	public func loadFromFile() -> [Note]  {
		guard let fileURL = try? FileManager.getfileURL(filename: filename) else {
			DDLogError("Failed to get path")
			return []
		}
		
		do {
			let data = try Data(contentsOf: fileURL, options: [])
			guard let json = try JSONSerialization.jsonObject(with:
				data, options: []) as? [[String:Any]] else {
					DDLogError("Failed to decode notes from \(fileURL)")
					return []
			}
			
			notes = json.compactMap {
				return Note.parse(json: $0)
			}
			
			DDLogInfo("Loaded \(notes.count) notes")
			
		} catch {
			DDLogError("Failed to load data from file \(fileURL)")
		}
		
		return notes
	}
}
