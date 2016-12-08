//
//  SequenceTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/8/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class SequenceTest: XCTestCase {
    func testObjectForLoop() {
		let json = ["a":[] as JSON, "b": nil as JSON, "c": 123]
		for (key, value) in json {
			print("\(key) = \(value)")
		}
    }

    func testArrayForLoop() {
		let json = [1, "2", 3.14, [4] as JSON, nil as JSON] as JSON
		for (index, value) in json {
			print("\(index) = \(value)")
		}
    }
}
