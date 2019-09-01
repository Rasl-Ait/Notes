//
//  FileImageNotebookProtocol.swift
//  Notes
//
//  Created by rasl on 29/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import UIKit

protocol FileImageNotebookProtocol: class{
	var images: [Image] { get }
	func add(_ note: Image)
	func remove(with uid: String)
	func saveToFile()
	func saveNewMemory(image: UIImage) -> Image 
	func loadFromFile()
	func load(filename: String) -> URL
}
