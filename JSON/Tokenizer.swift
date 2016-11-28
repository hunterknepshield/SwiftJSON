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
			case "\"":  // Literal string.
				guard hasPriorSeparator, let string = parseString() else {
					throw JSONError.Malformed
				}
				hasPriorSeparator = false
				return .String(string)
			// TODO: numbers
			default:  // Unexpected character.
				throw JSONError.Malformed
			}
		}
		done = true
		return nil
	}

	/// Consumes and returns a properly escaped string, or returns nil if the
	/// string was malformed in some way.
	private func parseString() -> String? {
		var result = ""
		while let c = iterator.next() {
			switch c {
			case "\"":
				return result
			case "\\":  // Escape sequence.
				guard let escaped = iterator.next() else {
					// Our string can't end in a raw backslash.
					return nil
				}
				switch escaped {
				case "\"":	result.append(escaped)
				case "\\":	result.append(escaped)
				case "/":	result.append(escaped)
				case "b":	result.append(Character("\u{0008}"))
				case "f":	result.append(Character("\u{000c}"))
				case "n":	result.append(Character("\u{000a}"))
				case "r":	result.append(Character("\u{000d}"))
				case "t":	result.append(Character("\u{0009}"))
				case "u":  // Unicode escape sequence - expect 4 hex digits
					guard let u1 = Tokenizer.intFromHexDigit(iterator.next()),
						let u2 = Tokenizer.intFromHexDigit(iterator.next()),
						let u3 = Tokenizer.intFromHexDigit(iterator.next()),
						let u4 = Tokenizer.intFromHexDigit(iterator.next()) else {
							// Invalid Unicode sequence.
							return nil
					}
					let numericScalar = ((u1*16 + u2)*16 + u3)*16 + u4
					guard let scalar = UnicodeScalar(numericScalar) else {
						return nil
					}
					result.append(String(scalar))
				default:  // Invalid escape sequence.
					return nil
				}
			default:  // Normal character.
				result.append(c)
			}
		}
		// Unterminated string.
		return nil
	}
	
	private static func intFromHexDigit(_ digit: Character?) -> UInt32? {
		guard let digit = digit else {
			return nil
		}
		switch digit {
		case "0":		return 0
		case "1":		return 1
		case "2":		return 2
		case "3":		return 3
		case "4":		return 4
		case "5":		return 5
		case "6":		return 6
		case "7":		return 7
		case "8":		return 8
		case "9":		return 9
		case "A", "a":	return 10
		case "B", "b":	return 11
		case "C", "c":	return 12
		case "D", "d":	return 13
		case "E", "e":	return 14
		case "F", "f":	return 15
		default:			return nil
		}
	}
}
