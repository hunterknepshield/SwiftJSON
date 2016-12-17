//
//  ExpressibleByLiteralTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/8/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class ExpressibleByLiteralTest: XCTestCase {
    func testExpressibleByNilLiteral() {
		let nilJson: JSON = nil
		XCTAssertEqual(nilJson, .Null)
    }
	
	func testExpressibleByBooleanLiteral() {
		let trueJson: JSON = true
		XCTAssertEqual(trueJson, .Boolean(true))
		let falseJson: JSON = false
		XCTAssertEqual(falseJson, .Boolean(false))
	}
	
	func testExpressibleByFloatLiteral() {
		let floatJson: JSON = 3.14
		XCTAssertEqual(floatJson, .Number("3.14"))
	}
	
	func testExpressibleByIntegerLiteral() {
		let intJson: JSON = 42
		XCTAssertEqual(intJson, .Number("42"))
	}
	
	func testExpressibleByStringLiteral() {
		// UnicodeScalarLiteral
		// ExtendedGraphemeClusterLiteral
		// StringLiteral
		let stringJson: JSON = "This is a string"
		XCTAssertEqual(stringJson, .String("This is a string"))
	}
	
	func testExpressibleByArrayLiteral() {
		// Types within the array can be heterogeneous
		let arrayJson: JSON = [1, "2", 3.14, [4] as JSON, nil as JSON]
		XCTAssertEqual(arrayJson, .Array(elements: [.Number("1"), .String("2"), .Number("3.14"), .Array(elements: [.Number("4")]), .Null]))
	}
	
	func testExpressibleByDictionaryLiteral() {
		// Types within the dictionary can be heterogeneous
		let objectJson: JSON = ["test": 1, "emptyArray": [] as JSON, "string": "12345", "nestedObject": ["key": "value"] as JSON]
		XCTAssertEqual(objectJson, .Object(members: ["test": .Number("1"), "emptyArray": .Array(elements: []), "string": .String("12345"), "nestedObject": .Object(members: ["key": .String("value")])]))
	}
}
