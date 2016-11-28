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
		let object = JSON(string: "{\"one\": 1, \"two\": 2, \"three\": {\"one\": 1}}")!
		print(object)
		print(array)
    }
}
