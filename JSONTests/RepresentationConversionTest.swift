//
//  RepresentationConversionTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/17/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class RepresentationConversionTest: XCTestCase {
	let string: JSON = "abc"
	let array = [1, 2, 3].json
	let object = ["A": 1, "B": 2] as JSON
	
    func testAsMinifiedString() {
		XCTAssertEqual("\"abc\"", string.asMinifiedString)
		XCTAssertEqual("[1,2,3]", array.asMinifiedString)
		// With objects, we can't rely on ordering of members, so just test that
		// the string contains no whitespace.
		XCTAssertFalse(object.asMinifiedString.unicodeScalars.contains(where: { char in
			return CharacterSet.whitespacesAndNewlines.contains(char)
		}))
    }
	
	func testAsPrettyString() {
		XCTAssertEqual("\"abc\"", string.asPrettyString)
		XCTAssertEqual("[1, 2, 3]", array.asPrettyString)
		// TODO: figure out how to test the object
	}
	
	func testAsData() {
		let stringData = "\"abc\"".data(using: .utf8)!
		XCTAssertEqual(stringData, string.asData)
		let arrayData = "[1,2,3]".data(using: .utf8)!
		XCTAssertEqual(arrayData, array.asData)
		// TODO: figure out how to test the object
	}
}
