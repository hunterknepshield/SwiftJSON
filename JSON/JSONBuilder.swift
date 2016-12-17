//
//  JSONBuilder.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

class JSONBuilder {
	let tokenizer: JSONTokenizer
	
	init(json: String) {
		tokenizer = JSONTokenizer(json: json)
	}
	
	func build() -> JSON? {
		return buildValue()
	}
	
	func buildValue(startingWith initial: JSONToken? = nil) -> JSON? {
		guard let token = initial ?? tokenizer.next() else {
			// We don't have any tokens to consume. This is an error.
			return nil
		}
		switch token {
		case .OpenObject:
			return buildObject()
		case .OpenArray:
			return buildArray()
		case .Null:
			return .Null
		case .Boolean(let bool):
			return .Boolean(bool)
		case .String(let str):
			return .String(str)
		case .Number(let str):
			return .Number(str)
		case .CloseObject, .CloseArray, .Colon, .Comma, .EndOfString:  // Can't have these here.
			return nil
		}
	}
	
	/// Assumes the initial .OpenObject JSONToken has been consumed.
	func buildObject() -> JSON? {
		enum State {
			/// We need a key or a CloseObject token.
			case NeedKeyOrClose
			/// We need a string that acts as the key of the member pair.
			case NeedKey
			/// We need a colon that acts as the key-value separator for the pair.
			case NeedColon(key: String)
			/// We need a value that acts as the value of the member pair.
			case NeedValue(key: String)
			/// We need a comma to continue the member list or a CloseObject token.
			case NeedCommaOrClose
		}
		
		var state = State.NeedKeyOrClose
		// TODO: Should this be an array? That would allow values to be stored
		// in the same order they're encountered, but would require another
		// data structure to allow fast (non-O(n)) string lookups.
		// var members: [(String, JSON)] = []
		var members: [String : JSON] = [:]
		while let token = tokenizer.next(), token != .EndOfString {
			switch state {
			case .NeedKeyOrClose:
				switch token {
				case .CloseObject:
					return .Object(members: members)
				default:
					break
				}
				fallthrough
			case .NeedKey:
				switch token {
				case .String(let str):
					state = .NeedColon(key: str)
				default:
					return nil
				}
			case .NeedColon(let key):
				switch token {
				case .Colon:
					state = .NeedValue(key: key)
				default:
					return nil
				}
			case .NeedValue(let key):
				guard let value = buildValue(startingWith: token) else {
					return nil
				}
				// TODO: decide on key collisions - overwrite or return nil?
				guard members[key] == nil else {
					// This JSON library does not allow duplicate keys.
					return nil
				}
				members[key] = value
				state = .NeedCommaOrClose
			case .NeedCommaOrClose:
				switch token {
				case .Comma:
					state = .NeedKey
				case .CloseObject:
					return .Object(members: members)
				default:
					return nil
				}
			}
		}
		// Unclosed object.
		return nil
	}
	
	/// Assumes the initial .OpenArray JSONToken has been consumed.
	func buildArray() -> JSON? {
		enum State {
			/// We need a value or a CloseArray token.
			case NeedValueOrClose
			/// We need a value to add to the array.
			case NeedValue
			/// We need a comma to continue the element list or a CloseArray token.
			case NeedCommaOrClose
		}
		
		var state = State.NeedValueOrClose
		var elements: [JSON] = []
		while let token = tokenizer.next(), token != .EndOfString {
			switch state {
			case .NeedValueOrClose:
				switch token {
				case .CloseArray:
					return .Array(elements: elements)
				default:
					break
				}
				fallthrough
			case .NeedValue:
				guard let value = buildValue(startingWith: token) else {
					return nil
				}
				elements.append(value)
				state = .NeedCommaOrClose
			case .NeedCommaOrClose:
				switch token {
				case .Comma:
					state = .NeedValue
				case .CloseArray:
					return .Array(elements: elements)
				default:
					return nil
				}
			}
		}
		// Unclosed array.
		return nil
	}
}
