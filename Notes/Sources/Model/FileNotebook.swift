//
//  FileNotebook.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {
	private(set) var notes = [Note]()
	
	private let filename = "notes.json"
	private let fm = FileManager.default
	private let directory = FileManager.default.urls(
		for: .cachesDirectory,
		in: .userDomainMask).first
	
	private var fileURL: URL? {
		guard let directory = directory else {
			DDLogError("directory didn't return any directories")
			return nil
			
		}
		return directory.appendingPathComponent(filename)
	}
	
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
	
	// Функция для сохранения заметок в FileManager
	public func saveToFile() {
		var isDir: ObjCBool = false
		guard let fileURL = fileURL,
			let directory = directory else {
				DDLogError("Failed to get path")
				return
		}
		guard fm.fileExists(
			atPath: directory.path, isDirectory: &isDir) ||
			isDir.boolValue == false else { return }
		
		try? fm.createDirectory(at: directory,
														withIntermediateDirectories: true,
														attributes: nil)
		
		let json = notes.map{ $0.json}
		
		do {
			let data = try JSONSerialization.data(withJSONObject: json, options: [])
			fm.createFile(atPath: fileURL.path, contents: data, attributes: nil)
			DDLogInfo("Saved \(notes.count) notes")
		} catch {
			DDLogError("Failed to create file \(error.localizedDescription)")
		}
	}
	
	// Функция для загрузки заметок из FileManager
	public func loadFromFile() {
		guard let fileURL = fileURL else {
			DDLogError("Failed to get path")
			return
		}
		
		do {
			let data = try Data(contentsOf: fileURL, options: [])
			guard let json = try JSONSerialization.jsonObject(with: data,
																												options: []) as? [[String:Any]] else {
				DDLogError("Failed to decode notes from \(fileURL)")
				return
			}
			
			notes = json.compactMap {
				return Note.parse(json: $0)
			}
			
			DDLogInfo("Loaded \(notes.count) notes")
			
		} catch {
			DDLogError("Failed to load data from file \(fileURL)")
		}
	}
}
