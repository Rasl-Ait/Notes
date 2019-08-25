//
//  FileNotebookTests.swift
//  NotesTests
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import XCTest
@testable import Notes

class FileNotebookTests: XCTestCase {
	var sut: FileNotebook!
	
	override func setUp() {
		super.setUp()
		sut = FileNotebook()
	}
	
	override func tearDown() {
		super.tearDown()
		sut = nil
	}
	
	func testInitFileNotebookWithZeroNote() {
		XCTAssertEqual(sut.notes.count, 0)
	}
	
	func testAddNoteIncrementNotesCount() {
		let note = Note(uid: "123", title: "title",
										content: "contetn",
										importance: .normal)
		let note2 = Note(uid: "123", title: "title",
										content: "contetn",
										importance: .normal)
		sut.add(note)
		sut.add(note2)
		XCTAssertTrue(sut.notes.count == 1)
	}
	
	func testCoorectSaveAndLoadFiles() {
		let note = Note(title: "title",
										content: "contetn",
										importance: .important)
		let note2 = Note(title: "title2",
										 content: "contetn2",
										 importance: .important)
		sut.add(note)
		sut.add(note2)
		
		sut.saveToFile()
		sut.loadFromFile()
		
		XCTAssertEqual(sut.notes.count, 2)
	}
	
	func testRemoveNoteFromNotes() {
		let note = Note(title: "title",
										content: "contetn",
										importance: .important)
		let note2 = Note(title: "title2",
										 content: "contetn2",
										 importance: .important)
		
		sut.add(note)
		sut.add(note2)
		sut.remove(with: note.uid)
		
		XCTAssertTrue(sut.notes.count == 1)
	}
}
