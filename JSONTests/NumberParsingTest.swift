//
//  NumberParsingTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class NumberParsingTest: XCTestCase {
	func testNumberValidation() {
		func expectTrue(_ s: String) {
			XCTAssertTrue(Tokenizer.validateNumber(s), "Failed on \(s)")
		}
		func expectFalse(_ s: String) {
			XCTAssertFalse(Tokenizer.validateNumber(s), "Incorrectly passed on \(s)")
		}
		for i in -100...100 {
			expectTrue("\(i)")
		}
		// Technically allowed.
		expectTrue("-0")
		
		// Can't be empty string.
		expectFalse("")
		// Can't end with leading sign.
		expectFalse("-")
		// Can't have a leading zero with digits following.
		expectFalse("01")
		// Has to have a digit before fraction or exponent.
		expectFalse(".1")
		expectFalse("E0")
		// Has to have a digit in-between leading sign and fraction or exponent.
		expectFalse("-.")
		expectFalse("-E")
		// Has to have a digit in-between the fraction and exponent.
		expectFalse("0.E")
		// Has to have at least one digit in the fraction.
		expectFalse("0.")
		// Has to have at least one digit in the exponent.
		expectFalse("0E")
		expectFalse("0E+")
		
	}
}
