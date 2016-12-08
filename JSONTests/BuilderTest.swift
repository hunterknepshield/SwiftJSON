//
//  BuilderTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class BuilderTest: XCTestCase {
	func assertBuilds(_ json: String) {
		let builder = JSONBuilder(json: json)
		guard builder.build() != nil else {
			XCTFail("Failed to parse JSON: \(json)")
			return
		}
	}
	
	func testLiteralValues() {
		for literal in ["null", "true", "false"] {
			assertBuilds(literal)
		}
	}
	
	func testStringValue() {
		assertBuilds("\"This is a string\"")
	}
	
	func testNumberValue() {
		assertBuilds("12345")
	}
	
	func testArrayValues() {
		assertBuilds("[]")
		assertBuilds("[1]")
		assertBuilds("[1, 2, 3, 4, 5]")
	}
	
	func testObjectValues() {
		assertBuilds("{}")
		assertBuilds("{\"one\": 1}")
		
	}
}
