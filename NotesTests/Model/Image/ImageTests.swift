//
//  ImageTests.swift
//  NotesTests
//
//  Created by rasl on 25/08/2019.
//  Copyright © 2019 com.rasl. All rights reserved.
//

import XCTest
@testable import Notes

class ImageTests: XCTestCase {
	
	func testCreatingImageWithoutUID() {
		let model = Image(originalImage: "originalImage", thumbImage: "thumbImage")
		XCTAssertNotNil(model)
	}
	
	func testWhenSetNote() {
		let model = Image(uid: "ERERERE", originalImage: "originalImage", thumbImage: "thumbImage")
		XCTAssertTrue(model.uid == "ERERERE")
		XCTAssertTrue(model.originalImage == "originalImage")
		XCTAssertTrue(model.thumbImage == "thumbImage")
	}
}


