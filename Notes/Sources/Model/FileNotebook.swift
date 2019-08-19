//
//  FileNotebook.swift
//  Notes
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

class FileNotebook {
	private(set) var notes = [Note]()
	
	private let filename = "notes.json"
	private let fm = FileManager.default
	private let directory = FileManager.default.urls(
		for: .cachesDirectory,
		in: .userDomainMask).first
	
	private var fileURL: URL? {
		guard let directory = directory else { return nil}
		return directory.appendingPathComponent(filename)
	}
	// Функция для добавления заметки
	public func add(_ note: Note) {
		guard let index = firstIndex(with: note.uid) else {
			// если не существует, просто добавляем
			notes.append(note)
			return
		}
		// если заметка с таким uid уже существует, обновляем заметку
		notes[index] = note
	}
	
	// Функция для удаления заметки по индексу
	public func remove(with uid: String) {
		guard let index = firstIndex(with: uid) else { return }
		notes.remove(at: index)
	}
	
	private func firstIndex(with uid: String) -> Int? {
		return notes.firstIndex(where: {$0.uid == uid})
	}
	
	// Функция для сохранения заметок в FileManager
	public func saveToFile() {
		var isDir: ObjCBool = false
		guard let fileURL = fileURL,
			let directory = directory else { return }
		guard fm.fileExists(atPath: directory.path, isDirectory: &isDir) || isDir.boolValue == false else { return }
		try? fm.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
		
		let json = notes.map{ $0.json}
		
		do {
			let data = try JSONSerialization.data(withJSONObject: json, options: [])
			fm.createFile(atPath: fileURL.path, contents: data, attributes: nil)
		} catch {
			print(error)
		}
	}
	
	// Функция для загрузки заметок из FileManager
	public func loadFromFile() {
		guard let fileURL = fileURL else { return }
		do {
			
			let data = try Data(contentsOf: fileURL, options: [])
			guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
			
			notes = json.compactMap {
				return Note.parse(json: $0)
			}
		} catch {
			print(error.localizedDescription)
		}
	}
}
