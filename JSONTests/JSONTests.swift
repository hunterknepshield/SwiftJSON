//
//  JSONTests.swift
//  JSONTests
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class JSONTests: XCTestCase {
    func testNumberValidation() {
		for i in 0...1000 {
			XCTAssert(Tokenizer.validateNumber("\(i)"))
		}
    }
}
