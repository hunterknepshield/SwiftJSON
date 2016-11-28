//
//  Tokenizer.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

class Tokenizer {
	private let json: String
	private var iterator: String.CharacterView.Iterator
	/// Whether we've reached the end of the string or not.
	private(set) var done = false
	/// Used to find malformed JSON missing delimiters between tokens.
	private var hasPriorSeparator = true

	init(json: String) {
		self.json = json
		self.iterator = self.json.characters.makeIterator()
	}
	
	func next() throws -> Token? {
		if done {
			return nil
		}
		while let c = iterator.next() {
			switch c {
			case " ", "\t", "\r", "\n":
				// Just eat whitespace.
				hasPriorSeparator = true
			case ":":
				hasPriorSeparator = true
				return .Colon
			case ",":
				hasPriorSeparator = true
				return .Comma
			case "{":
				hasPriorSeparator = true
				return .OpenObject
			case "}":
				hasPriorSeparator = true
				return .CloseObject
			case "[":
				hasPriorSeparator = true
				return .OpenArray
			case "]":
				hasPriorSeparator = true
				return .CloseArray
			case "n":  // Literal null.
				guard hasPriorSeparator,
					let u = iterator.next(), u == "u",
					let l1 = iterator.next(), l1 == "l",
					let l2 = iterator.next(), l2 == "l" else {
						throw JSONError.Malformed
				}
				hasPriorSeparator = false
				return .Null
			case "t":  // Literal true.
				guard hasPriorSeparator,
					let r = iterator.next(), r == "r",
					let u = iterator.next(), u == "u",
					let e = iterator.next(), e == "e" else {
						throw JSONError.Malformed
				}
				hasPriorSeparator = false
				return .Boolean(true)
			case "f":  // Literal false.
				guard hasPriorSeparator,
					let a = iterator.next(), a == "a",
					let l = iterator.next(), l == "l",
					let s = iterator.next(), s == "s",
					let e = iterator.next(), e == "e" else {
						throw JSONError.Malformed
				}
				hasPriorSeparator = false
				return .Boolean(false)
			// TODO: strings, numbers
			default:  // Unexpected character.
				throw JSONError.Malformed
			}
		}
		done = true
		return nil
	}
}
