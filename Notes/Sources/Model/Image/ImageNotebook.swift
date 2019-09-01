//
//  ImageNotebook.swift
//  Notes
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation
import CocoaLumberjack

class ImageNotebook: FileImageNotebookProtocol {
	private(set) var images = [Image]()
	
	private let filename = "images.json"
	private let fm = FileManager.default
	
	// Функция для добавления image
	public func add(_ image: Image) {
		guard let index = firstIndex(with: image.uid) else {
			// если не существует, просто добавляем
			images.append(image)
			DDLogInfo("Added note with uid=\(image.uid)")
			return
		}
		// если image с таким uid уже существует, обновляем image
		images[index] = image
		DDLogInfo("updated note with UID=\(image.uid)")
	}
	
	// Функция для удаления image по индексу
	public func remove(with uid: String) {
		guard let index = firstIndex(with: uid) else {
			DDLogError(
				"Failed to delete note: note with uid=\(uid) doesn't exists")
			return
		}
		
		images.remove(at: index)
		DDLogInfo("delete note with uid=\(uid)")
	}
	
	private func firstIndex(with uid: String) -> Int? {
		return images.firstIndex(where: {$0.uid == uid})
	}
	

	
	// функция для сериализации data из json
	private func dataJson() -> Data? {
		let json = images.map{ $0.json }
		
		do {
			let data = try JSONSerialization.data(withJSONObject: json, options: [])
			return data
		} catch {
			DDLogError("Failed to encode notes from \(json)")
		}
		return nil
	}
	
	// Функция для созднания уменьшеной версии image
	func resize(image: UIImage, to width: CGFloat) -> UIImage? {
		let scale = width / image.size.width
		let height = image.size.height * scale
		
		UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
		image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
	// Функция для сохранения image в FileManager
	func saveNewMemory(image: UIImage) -> Image {
		let memoryName = "image-\(Date().timeIntervalSince1970)"
		let imageName = memoryName + ".jpg"
		let thumbnailName = memoryName + ".thumb"
		
		do {
			let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent(imageName)
			if let jpegData = image.jpegData(compressionQuality: 0.8) {
				try jpegData.write(to: imagePath, options: [.atomicWrite])
			}
			
			if let thumbnail = resize(image: image, to: 200) {
				let imagePath = FileManager.getDocumentsDirectory().appendingPathComponent(thumbnailName)
				if let jpegData = thumbnail.jpegData(compressionQuality: 0.8) {
					try jpegData.write(to: imagePath, options: [.atomicWrite])
				}
			}
		} catch {
			DDLogError("Failed to save to disk.")
		}
		
		return Image(originalImage: imageName, thumbImage: thumbnailName)
	}
	
	// Функция для сохранения json данных в FileManager
	public func saveToFile() {
		let isDir: ObjCBool = false
		let directory = FileManager.getCachesDirectory()
		guard let fileURL = try? FileManager.getfileURL(filename: filename) else {
			DDLogError("Failed to get path")
			return
		}
		
		guard FileManager.createDirectory(withFolderName: filename) ||
			isDir.boolValue == false else { return }
		
		
		try? fm.createDirectory(at: directory,
														withIntermediateDirectories: true,
														attributes: nil)
		
		do {
			let data = dataJson()
			try data?.write(to: fileURL)
			DDLogInfo("Saved \(images.count) images")
		} catch {
			DDLogError("Failed to create file \(error.localizedDescription)")
		}
	}
	
	func load(filename: String) -> URL {
		return FileManager.getDocumentsDirectory().appendingPathComponent(filename)
	}
	
	// Функция для загрузки данных из FileManager
	public func loadFromFile() {
		guard let fileURL = try? FileManager.getfileURL(filename: filename) else {
			DDLogError("Failed to get path")
			return
		}
		
		do {
			let data = try Data(contentsOf: fileURL, options: [])
			guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
				DDLogError("Failed to decode notes from \(fileURL)")
				return
			}
			
			images = json.compactMap { return Image.parse(json: $0) }
			DDLogInfo("Loaded \(images.count) images")
		} catch {
			DDLogError("Failed to load data from file \(fileURL)")
		}
	}
}

