//
//  NoteExtensionTests.swift
//  NotesTests
//
//  Created by rasl on 19/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import XCTest
@testable import Notes

class NoteExtensionTests: XCTestCase {
	
	let sut = Note(title: "title", content: "content", importance: .normal)
	let otherSut = Note(uid: "123", title: "title", content: "content", color: .red,
											importance: .important, destructionDate: Date(timeIntervalSince1970: 100))
	
	override func setUp() {
		
	}
	
	func testCreateNoteFromJson() {
		let note = Note.parse(json: sut.json)
		
		XCTAssertNotNil(note)
	}
	
	func testNotCreateNoteFromIncorrectJson() {
		let note = Note.parse(json: ["SomeString": UIColor.white])
		XCTAssertNil(note)
	}
	
	func testNoteWithCorrectValidDateFromJson() {
		
		guard let note = Note.parse(json: otherSut.json) else {
			XCTFail("Note is nil")
			return
		}
		
		XCTAssertEqual(note.destructionDate, Date(timeIntervalSince1970: 100))
	}
	
	func testCreateNoteFromJsonWithCorrectParam() {
		
		guard let note = Note.parse(json: otherSut.json) else {
			XCTFail("Note is nil")
			return
		}
		
		XCTAssertEqual(note.title, "title")
		XCTAssertEqual(note.content, "content")
		XCTAssertEqual(note.color, .red)
		XCTAssertEqual(note.importance, .normal)
	}
}
