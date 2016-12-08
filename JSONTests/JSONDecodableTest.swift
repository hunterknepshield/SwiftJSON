//
//  JSONDecodableTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/7/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class DecodableObject: JSONDecodable {
	let string: String
	let int: Int
	let double: Double
	
	required init?(json: JSON) {
		guard let string = json["string"]?.string else {
			return nil
		}
		self.string = string
		guard let int = json["int"]?.int else {
			return nil
		}
		self.int = int
		guard let double = json["double"]?.double else {
			return nil
		}
		self.double = double
	}
}

class JSONDecodableTest: XCTestCase {
    func testJSONDecodable() {
		// Tests the user-defined init?(json:) initializer.
		let json = JSON(value: .Object(members: ["string": .String("abc"), "int": .Number("1"), "double": .Number("3.14")]))
		let object = DecodableObject(json: json)
		JSONDecodableTest.objectHelper(object)
		
		let badJson = JSON(value: .Object(members: ["bad": .String("value")]))
		let nilObject = DecodableObject(json: badJson)
		XCTAssertNil(nilObject)
    }
	
	func testRawJSONDecodable() {
		// Tests the default init?(rawJson:) initializer.
		let object = DecodableObject(rawJson: "{\"string\":\"abc\",\"int\":1,\"double\":3.14}")
		JSONDecodableTest.objectHelper(object)
		
		let nilObject = DecodableObject(rawJson: "{\"bad\": \"value\"}")
		XCTAssertNil(nilObject)
	}
	
	func testArrayJSONDecodable() {
		func testInitWithJsonArray() {
			// Array.init?(jsonArray:)
			let jsonArray = [JSON](repeating: JSON(value: .Object(members: ["string": .String("abc"), "int": .Number("1"), "double": .Number("3.14")])), count: 3)
			let array = [DecodableObject](jsonArray: jsonArray)
			JSONDecodableTest.arrayHelper(array)
			
			let badJsonArray = [JSON](repeating: JSON(value: .Object(members: ["bad": .String("value")])), count: 3)
			let nilArray = [DecodableObject](jsonArray: badJsonArray)
			XCTAssertNil(nilArray)
		}
		func testInitWithJson() {
			// Array.init?(json:)
			let json = JSON(value: .Array(elements:
				[.Object(members: ["string": .String("abc"), "int": .Number("1"), "double": .Number("3.14")]),
				 .Object(members: ["string": .String("abc"), "int": .Number("1"), "double": .Number("3.14")]),
				 .Object(members: ["string": .String("abc"), "int": .Number("1"), "double": .Number("3.14")])]))
			let array = [DecodableObject](json: json)
			JSONDecodableTest.arrayHelper(array)
			
			let badJson = JSON(value: .Array(elements: [.Object(members: ["bad": .String("value")])]))
			let nilArray = [DecodableObject](json: badJson)
			XCTAssertNil(nilArray)
		}
		func testInitWithRawJson() {
			// Array.init?(rawJson:)
			let array = [DecodableObject](rawJson: "[{\"string\":\"abc\",\"int\":1,\"double\":3.14},{\"string\":\"abc\",\"int\":1,\"double\":3.14},{\"string\":\"abc\",\"int\":1,\"double\":3.14}]")
			JSONDecodableTest.arrayHelper(array)
			
			let nilArray = [DecodableObject](rawJson: "[{\"bad\": \"value\"}]")
			XCTAssertNil(nilArray)
		}
		
		testInitWithJsonArray()
		testInitWithJson()
		testInitWithRawJson()
	}

	static func objectHelper(_ object: DecodableObject?) {
		XCTAssertNotNil(object)
		let object = object!
		XCTAssertEqual(object.string, "abc")
		XCTAssertEqual(object.int, 1)
		XCTAssertEqual(object.double, 3.14)
	}
	
	static func arrayHelper(_ array: [DecodableObject]?) {
		XCTAssertNotNil(array)
		let array = array!
		XCTAssertEqual(array.count, 3)
		for object in array {
			objectHelper(object)
		}
	}
}
