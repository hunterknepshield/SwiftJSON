//
//  CustomStringConvertibleTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class CustomStringConvertibleTest: XCTestCase {
    func testExample() {
		let array = JSON(string: "[1, 2, 3]")!
		print(array)
		// The string should indeed look like this
		let object = JSON(string:
			"{" +
				"\"one\": 1," +
				"\"two\": 2," +
				"\"three\": {" +
					"\"one\": 1," +
					"\"two\": [1, 2, 3]," +
					"\"three\": {" +
						"\"array\": [{" +
							"\"1\": 1" +
						"}, 2, {" +
							"\"3\": 3" +
						"}]" +
					"}" +
				"}" +
			"}")!
		print(object)
    }
}
