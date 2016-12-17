//
//  JSONEncodableTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/8/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class EncodableObject: JSONEncodable {
	let string: String
	let int: Int
	let double: Double
	
	public init() {
		self.string = "abc"
		self.int = 42
		self.double = 3.14
	}
	
	public var json: JSON {
		get {
			return ["string": string, "int": int, "double": double]
		}
	}
}

class JSONEncodableTest: XCTestCase {
    func testJsonEncodable() {
		XCTAssertEqual(EncodableObject().json, .Object(members: ["string": .String("abc"), "int": .Number("42"), "double": .Number("3.14")]))
    }
}
