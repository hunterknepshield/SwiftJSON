//
//  Builder.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

class Builder {
	var tokenizer: Tokenizer
	
	init(json: String) {
		tokenizer = Tokenizer(json: json)
	}
	
	func build() -> JSON? {
		guard let value = buildValue() else {
			return nil
		}
		return JSON(value)
	}
	
	func buildValue() -> JSON.Value? {
		// We can have a top-level number/string/literal, an object, or an array.
		do {
			let maybeToken = try tokenizer.next()
			guard let actualToken = maybeToken else {
				return nil
			}
			return buildValue(startingWith: actualToken)
		} catch {
			return nil
		}
	}
	
	func buildValue(startingWith initial: Token) -> JSON.Value? {
		switch initial {
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
		case .CloseObject, .CloseArray, .Colon, .Comma:  // Can't have these here.
			return nil
		}
	}
	
	/// Assumes the initial .OpenObject Token has been consumed.
	func buildObject() -> JSON.Value? {
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
		var members: [String : JSON.Value] = [:]
		do {
			while let token = try tokenizer.next() {
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
		} catch {
			return nil
		}
	}
	
	/// Assumes the initial .OpenArray Token has been consumed.
	func buildArray() -> JSON.Value? {
		enum State {
			/// We need a value or a CloseArray token.
			case NeedValueOrClose
			/// We need a value to add to the array.
			case NeedValue
			/// We need a comma to continue the element list or a CloseArray token.
			case NeedCommaOrClose
		}
		
		var state = State.NeedValueOrClose
		var elements: [JSON.Value] = []
		do {
			while let token = try tokenizer.next() {
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
		} catch {
			return nil
		}
	}
}
