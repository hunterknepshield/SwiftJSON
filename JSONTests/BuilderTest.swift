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
	func assertBuilds(json: String) {
		let builder = Builder(json: json)
		guard builder.build() != nil else {
			XCTFail("Failed to parse JSON: \(json)")
			return
		}
	}
	
	func testLiteralValues() {
		for literal in ["null", "true", "false"] {
			assertBuilds(json: literal)
		}
	}
	
	func testStringValue() {
		assertBuilds(json: "\"This is a string\"")
	}
	
	func testNumberValue() {
		assertBuilds(json: "12345")
	}
	
	func testArrayValues() {
		assertBuilds(json: "[]")
		assertBuilds(json: "[1]")
		assertBuilds(json: "[1, 2, 3, 4, 5]")
	}
}
