//
//  FileManager.swift
//  Notes
//
//  Created by rasl on 29/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import Foundation

extension FileManager {
	 static func getCachesDirectory() -> URL {
		let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
		return paths[0]
	}
	
	static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
	}
	
	 static func getfileURL(filename: String) throws -> URL {
		return getCachesDirectory().appendingPathComponent(filename)
	}
	
	 static func directoryExists(atPath filePath: String)-> Bool {
		var isDir = ObjCBool(true)
		return FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir )
	}
	
	 static func createDirectory(withFolderName name: String)-> Bool {
		let finalPath = getCachesDirectory().appendingPathComponent(name)
		return directoryExists(atPath: finalPath.path)
	}
}
