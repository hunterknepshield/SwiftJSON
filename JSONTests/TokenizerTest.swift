//
//  TokenizerTest.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

import XCTest
@testable import JSON

class TokenizerTest: XCTestCase {
	func tokenizerHelper(_ json: String, _ tokens: [Token]) {
		let tokenizer = Tokenizer(json: json)
		do {
			for token in tokens {
				guard let gotten = try tokenizer.next() else {
					XCTFail("Failed to tokenize \(json)")
					return
				}
				XCTAssertEqual(token, gotten)
			}
		} catch {
			XCTFail("Failed to tokenize \(json)"	)
		}
	}
	
	func testEmptyTokenization() {
		tokenizerHelper("", [])
	}
	
	func testSingleCharacterTokenization() {
		tokenizerHelper("{", [.OpenObject])
		tokenizerHelper("}", [.CloseObject])
		tokenizerHelper("[", [.OpenArray])
		tokenizerHelper("]", [.CloseArray])
		tokenizerHelper(":", [.Colon])
		tokenizerHelper(",", [.Comma])
	}
	
	func testLiteralTokenization() {
		tokenizerHelper("null", [.Null])
		tokenizerHelper("true", [.Boolean(true)])
		tokenizerHelper("false", [.Boolean(false)])
	}
	
	func testStringTokenization() {
		tokenizerHelper("\"\"", [.String("")])
		tokenizerHelper("\"This is a string\"", [.String("This is a string")])
		tokenizerHelper("\"Escapes \\\"totally\\\" work\"", [.String("Escapes \"totally\" work")])
	}
	
	func testNumberTokenization() {
		func numberHelper(_ number: String) {
			tokenizerHelper(number, [.Number(number)])
		}
		
		numberHelper("0")
		numberHelper("123.456")
		numberHelper("123E456")
		numberHelper("123.456E789")
		numberHelper("-1")
	}
}
