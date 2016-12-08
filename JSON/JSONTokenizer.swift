//
//  JSONTokenizer.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

enum JSONToken {
	case OpenObject  // "{"
	case CloseObject  // "}"
	case OpenArray  // "["
	case CloseArray  // "]"
	
	case Colon  // ":"
	case Comma  // ","
	
	case Null  // The "null" literal.
	case String(Swift.String)  // A string literal.
	case Boolean(Bool)  // A "true" or "false" literal.
	case Number(Swift.String)  // A number literal.
	
	case EndOfString  // We've reached the end of the string.
}

extension JSONToken: Equatable {
	static func ==(lhs: JSONToken, rhs: JSONToken) -> Bool {
		switch (lhs, rhs) {
		case (.OpenObject, .OpenObject), (.CloseObject, .CloseObject), (.OpenArray, .OpenArray), (.CloseArray, .CloseArray), (.Colon, .Colon), (.Comma, .Comma), (.Null, .Null), (.EndOfString, .EndOfString):
			return true
		case (.Boolean(let lb), .Boolean(let rb)):
			return lb == rb
		case (.String(let ls), .String(let rs)), (.Number(let ls), .Number(let rs)):
			return ls == rs
		default:
			return false
		}
	}
}

class JSONTokenizer {
	private let json: String
	private var iterator: String.CharacterView.Iterator
	/// Whether we've reached the end of the string or not.
	private var done = false
	/// Used to find malformed JSON missing delimiters between tokens.
	private var hasPriorSeparator = true
	/// Used to store state when a character was consumed eagerly and ended up unsed.
	private var previouslyUnconsumed: Character? = nil

	init(json: String) {
		self.json = json
		self.iterator = self.json.characters.makeIterator()
	}
	
	/// Decodes the next available construct as a JSONToken, if possible.
	/// Returns .EndOfString if the end of the string has been reached, and
	/// returns nil if something is malformed.
	func next() -> JSONToken? {
		if done {
			return .EndOfString
		}
		while let c = previouslyUnconsumed ?? iterator.next() {
			previouslyUnconsumed = nil
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
						return nil
				}
				hasPriorSeparator = false
				return .Null
			case "t":  // Literal true.
				guard hasPriorSeparator,
					let r = iterator.next(), r == "r",
					let u = iterator.next(), u == "u",
					let e = iterator.next(), e == "e" else {
						return nil
				}
				hasPriorSeparator = false
				return .Boolean(true)
			case "f":  // Literal false.
				guard hasPriorSeparator,
					let a = iterator.next(), a == "a",
					let l = iterator.next(), l == "l",
					let s = iterator.next(), s == "s",
					let e = iterator.next(), e == "e" else {
						return nil
				}
				hasPriorSeparator = false
				return .Boolean(false)
			case "\"":  // Literal string.
				guard hasPriorSeparator, let string = parseString() else {
					return nil
				}
				hasPriorSeparator = false
				return .String(string)
			case "-", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":  // Literal number.
				guard hasPriorSeparator, let result = parseNumber(startsWith: c) else {
					return nil
				}
				previouslyUnconsumed = result.nextCharacter
				hasPriorSeparator = false
				return .Number(result.number)
			default:  // Unexpected character.
				return nil
			}
		}
		done = true
		return .EndOfString
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
					guard let u1 = JSONTokenizer.intFromHexDigit(iterator.next()),
						let u2 = JSONTokenizer.intFromHexDigit(iterator.next()),
						let u3 = JSONTokenizer.intFromHexDigit(iterator.next()),
						let u4 = JSONTokenizer.intFromHexDigit(iterator.next()) else {
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
	
	/// Consumes and returns a well-formed string representation of a JSON
	/// number or nil if it was an invalid number. This function consumes one
	/// too many characters, so it returns one if appropriate.
	private func parseNumber(startsWith beginning: Character) -> (number: String, nextCharacter: Character?)? {
		var result = String(beginning)
		while let c = iterator.next() {
			switch c {
			case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "E", "e", "+", "-":
				result.append(c)
			default:
				// Non-numeric character, validate now.
				return JSONTokenizer.validateNumber(result) ? (result, c) : nil
			}
		}
		// We've consumed the entire string, check that it's a number.
		return JSONTokenizer.validateNumber(result) ? (result, nil) : nil
	}

	/// This function returns whether or not the supplied string represents a
	/// valid JSON number.
	static func validateNumber(_ number: String) -> Bool {
		/// This enum tracks the last character we consumed.
		enum State {
			/// We haven't consumed anything yet.
			case IntegerBegin
			/// We've consumed the leading sign.
			case IntegerSign
			/// We've consumed a zero in the integer part.
			case IntegerZero
			/// We're consuming any digits in the integer part.
			case IntegerDigits
			/// We've consumed the decimal point.
			case FractionBegin
			/// We're consuming any digits in the fraction part.
			case FractionDigits
			/// We've consumed the exponent delimiter.
			case ExponentBegin
			/// We've consumed the exponent's sign.
			case ExponentSign
			/// We're consuming any digits in the exponent part.
			case ExponentDigits
		}

		var state = State.IntegerBegin
		var iter = number.characters.makeIterator()
		while let c = iter.next() {
			switch state {
			case .IntegerBegin:
				// We can have a negative sign, a 0, or a digit 1-9.
				switch c {
				case "-":
					state = .IntegerSign
				case "0":
					state = .IntegerZero
				case "1", "2", "3", "4", "5", "6", "7", "8", "9":
					state = .IntegerDigits
				default:
					return false
				}
			case .IntegerSign:
				// We can have a 0 or a digit 1-9.
				switch c {
				case "0":
					state = .IntegerZero
				case "1", "2", "3", "4", "5", "6", "7", "8", "9":
					state = .IntegerDigits
				default:
					return false
				}
			case .IntegerZero:
				// We can only have a decimal point or exponent now.
				switch c {
				case ".":
					state = .FractionBegin
				case "E", "e":
					state = .ExponentBegin
				default:
					return false
				}
			case .IntegerDigits:
				// We can have any digit 0-9, a decimal point, or exponent.
				switch c {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					break
				case ".":
					state = .FractionBegin
				case "E", "e":
					state = .ExponentBegin
				default:
					return false
				}
			case .FractionBegin:
				// We need at least one digit.
				switch c {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					state = .FractionDigits
				default:
					return false
				}
			case .FractionDigits:
				// We can have more digits or an exponent.
				switch c {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					break
				case "E", "e":
					state = .ExponentBegin
				default:
					return false
				}
			case .ExponentBegin:
				// We can have a sign or digits.
				switch c {
				case "+", "-":
					state = .ExponentSign
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					state = .ExponentDigits
				default:
					return false
				}
			case .ExponentSign:
				// We need at least one digit.
				switch c {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					state = .ExponentDigits
				default:
					return false
				}
			case .ExponentDigits:
				switch c {
				case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
					break
				default:
					return false
				}
			}
		}
		// These are the valid termination states.
		return [State.IntegerZero, .IntegerDigits, .FractionDigits, .ExponentDigits].contains(state)
	}

}
