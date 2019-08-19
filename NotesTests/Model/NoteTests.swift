//
//  NoteTests.swift
//  NotesTests
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import XCTest
@testable import Notes

class NoteTests: XCTestCase {

	func testCreatingNoteWithoutUIDAndDate() {
		let note = Note(title: "title",
										content: "content",
										importance: .normal)
		XCTAssertNotNil(note)
	}
	
	func testNoteDestructionDateNil() {
		let sut = Note(title: "title",
									 content: "content",
									 importance: .normal)
		XCTAssertNil(sut.destructionDate)
	}
	
	func testNoteDestructionDateNotNil() {
		let sut = Note(uid: "DFDFEREFEFF", title: "title",
									 content: "content", color: .white,
									 importance: .normal, destructionDate: Date())
		XCTAssertNotNil(sut.destructionDate)
	}
	
	func testNoteWithColor() {
		let sut = Note(title: "title",
									 content: "content",
									 importance: .normal)
		XCTAssertNotNil(sut.color)
	}
	
	func testWhenSetNote() {
		let note = Note(uid: "DFDFEREFEFF", title: "title",
										content: "content", color: .white,
										importance: .normal, destructionDate: Date())
		XCTAssertTrue(note.title == "title")
		XCTAssertTrue(note.content == "content")
		XCTAssertTrue(note.importance == .normal)
		XCTAssertTrue(note.color == .white)
		XCTAssertNotNil(note.destructionDate)
	}
	
}
