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
			for expected in tokens {
				guard let actual = try tokenizer.next() else {
					XCTFail("Failed to produce more tokens while attempting to tokenize \(json)")
					return
				}
				XCTAssertEqual(expected, actual)
			}
		} catch {
			XCTFail("Error thrown while attempting to tokenize \(json)")
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
	
	func testMultipleTokenization() {
		tokenizerHelper("false null", [.Boolean(false), .Null])
		tokenizerHelper("{123", [.OpenObject, .Number("123")])
		tokenizerHelper("123}", [.Number("123"), .CloseObject])
		tokenizerHelper("{123}", [.OpenObject, .Number("123"), .CloseObject])
		tokenizerHelper("null[", [.Null, .OpenArray])
		tokenizerHelper("null:true,false:\"false\"", [.Null, .Colon, .Boolean(true), .Comma, .Boolean(false), .Colon, .String("false")])
	}
	
	/// Tokenizes the string up to the expected amount of tokens, then asserts
	/// that attempting to call next() again will throw an error.
	func badTokenizerHelper(_ json: String, _ tokens: [Token]) {
		let tokenizer = Tokenizer(json: json)
		do {
			for expected in tokens {
				guard let actual = try tokenizer.next() else {
					XCTFail("Failed to produce more tokens while attempting to tokenize \(json)")
					return
				}
				XCTAssertEqual(expected, actual)
			}
		} catch {
			XCTFail("Threw too early while attempting to tokenize \(json)")
		}
		do {
			_ = try tokenizer.next()
			XCTFail("Did not throw at expected time while attempting to tokenize \(json)")
		} catch {
			// This is what we want.
		}
	}
	
	func testInvalidTokenization() {
		badTokenizerHelper("nullfalse", [.Null])
		badTokenizerHelper("false123", [.Boolean(false)])
		badTokenizerHelper("fals", [])
		badTokenizerHelper("{null\"123\"", [.OpenObject, .Null])
	}
}
