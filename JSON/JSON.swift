//
//  JSON.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

public struct JSON {
	enum Value {
		case String(Swift.String)
		case Number(Swift.String)
		case Object(members: [Swift.String: Value])
		case Array(elements: [Value])
		case Boolean(Bool)
		case Null
	}
	
	var value: Value
	
	/// Used internally by Builder.
	init(_ value: Value) {
		self.value = value
	}
}

// MARK: Public constructor

extension JSON {
	public init?(string: String) {
		let builder = Builder(json: string)
		guard let json = builder.build() else {
			return nil
		}
		self = json
	}
}

// MARK: Integer conversion
// Macros sure would be useful here...

extension JSON.Value {
	/// The actual root conversion. Everything else is implemented as a type
	/// cast from a Double.
	var double: Double? {
		get {
			switch self {
			case .Number(let string):
				return Double(string)
			default:
				return nil
			}
		}
	}
	var float: Float? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return Float(double)
			default:
				return nil
			}
		}
	}
	var int64: Int64? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return Int64(double)
			default:
				return nil
			}
		}
	}
	var uint64: UInt64? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return UInt64(double)
			default:
				return nil
			}
		}
	}
	var int32: Int32? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return Int32(double)
			default:
				return nil
			}
		}
	}
	var uint32: UInt32? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return UInt32(double)
			default:
				return nil
			}
		}
	}
	var int: Int? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return Int(double)
			default:
				return nil
			}
		}
	}
	var uint: UInt? {
		get {
			switch self {
			case .Number(_):
				guard let double = self.double else {
					return nil
				}
				return UInt(double)
			default:
				return nil
			}
		}
	}
}

// MARK: Properties

extension JSON {
	// TODO: should this be mutable? i.e. define a setter?
	/// Fetches a value from a JSON object with the supplied key. Returns nil if
	/// the JSON isn't an object or if no such key exists in the object.
	public subscript(_ key: String) -> JSON? {
		get {
			switch self.value {
			case .Object(let members):
				guard let value = members[key] else {
					return nil
				}
				return JSON(value)
			default:
				return nil
			}
		}
	}
	/// Returns the underlying JSON array. Returns nil if the JSON isn't an
	/// array.
	public var array: [JSON]? {
		get {
			switch self.value {
			case .Array(let arr):
				return arr.map({ return JSON($0) })
			default:
				return nil
			}
		}
	}
	/// Returns the underlying JSON string. Returns nil if the JSON isn't a
	/// string.
	public var string: String? {
		get {
			switch self.value {
			case .String(let str):
				return str
			default:
				return nil
			}
		}
	}
	/// Returns the underlying numeric value as a Double. Returns nil if the
	/// JSON isn't a number or the number can't be represented using a Double.
	public var double: Double? {
		get {
			return self.value.double
		}
	}
	/// Returns the underlying numeric value as a Float. Returns nil if the JSON
	/// isn't a number or the number can't be represented using a Float. May
	/// cause a runtime error if the value cannot be converted to a Float from a
	/// Double.
	public var float: Float? {
		get {
			return self.value.float
		}
	}
	/// Returns the underlying numeric value as an Int64. Returns nil if the
	/// JSON isn't a number or the number can't be represented using an Int64.
	/// May cause a runtime error if the value cannot be converted to an Int64
	/// from a Double.
	public var int64: Int64? {
		get {
			return self.value.int64
		}
	}
	/// Returns the underlying numeric value as a UInt64. Returns nil if the
	/// JSON isn't a number or the number can't be represented using a UInt64.
	/// May cause a runtime error if the value cannot be converted to a UInt64
	/// from a Double.
	public var uint64: UInt64? {
		get {
			return self.value.uint64
		}
	}
	/// Returns the underlying numeric value as an Int32. Returns nil if the
	/// JSON isn't a number or the number can't be represented using an Int32.
	/// May cause a runtime error if the value cannot be converted to an Int32
	/// from a Double.
	public var int32: Int32? {
		get {
			return self.value.int32
		}
	}
	/// Returns the underlying numeric value as a UInt32. Returns nil if the
	/// JSON isn't a number or the number can't be represented using a UInt32.
	/// May cause a runtime error if the value cannot be converted to a UInt32
	/// from a Double.
	public var uint32: UInt32? {
		get {
			return self.value.uint32
		}
	}
	/// Returns the underlying numeric value as an Int. Returns nil if the JSON
	/// isn't a number or the number can't be represented using an Int. May
	/// cause a runtime error if the value cannot be converted to an Int from a
	/// Double.
	public var int: Int? {
		get {
			return self.value.int
		}
	}
	/// Returns the underlying numeric value as a UInt. Returns nil if the JSON
	/// isn't a number or the number can't be represented using a UInt. May
	/// cause a runtime error if the value cannot be converted to a UInt from a
	/// Double.
	public var uint: UInt? {
		get {
			return self.value.uint
		}
	}
	/// Returns the underlying bool. Returns nil if the JSON isn't a boolean
	/// literal.
	public var bool: Bool? {
		get {
			switch self.value {
			case .Boolean(let bool):
				return bool
			default:
				return nil
			}
		}
	}
}

// MARK: Type inspection

extension JSON {
	/// Returns whether or not this JSON is a string.
	public var isString: Bool {
		get {
			switch self.value {
			case .String(_):
				return true
			default:
				return false
			}
		}
	}
	/// Returns whether or not this JSON is a number.
	public var isNumber: Bool {
		get {
			switch self.value {
			case .Number(_):
				return true
			default:
				return false
			}
		}
	}
	/// Returns whether or not this JSON is an object.
	public var isObject: Bool {
		get {
			switch self.value {
			case .Object(_):
				return true
			default:
				return false
			}
		}
	}
	/// Returns whether or not this JSON is an array.
	public var isArray: Bool {
		get {
			switch self.value {
			case .Array(_):
				return true
			default:
				return false
			}
		}
	}
	/// Returns whether or not this JSON is a boolean (using the `true` or
	/// `false` literals).
	public var isBool: Bool {
		get {
			switch self.value {
			case .Boolean(_):
				return true
			default:
				return false
			}
		}
	}
	/// Returns whether or not this JSON is a null value (using the `null`
	/// literal). This concept is orthogonal to Swift's `nil`; each has a
	/// different meaning.
	public var isNull: Bool {
		get {
			switch self.value {
			case .Null:
				return true
			default:
				return false
			}
		}
	}
}

// MARK: Equatable

extension JSON.Value: Equatable {
	/// Complexity: O(n).
	static func ==(lhs: JSON.Value, rhs: JSON.Value) -> Bool {
		switch (lhs, rhs) {
		case (.Null, .Null):
			return true
		case (.Boolean(let lb), .Boolean(let rb)):
			return lb == rb
		case (.String(let ls), .String(let rs)), (.Number(let ls), .Number(let rs)):
			return ls == rs
		case (.Array(let le), .Array(let re)):
			if le.count != re.count {
				return false
			}
			for i in 0..<le.count {
				if le[i] != re[i] {
					return false
				}
			}
			return true
		case (.Object(let lm), .Object(let rm)):
			if lm.count != rm.count {
				return false
			}
			for (lkey, lvalue) in lm {
				if lvalue != rm[lkey] {
					return false
				}
			}
			return true
		default:  // Non-matching pair.
			return false
		}
	}
}

extension JSON: Equatable {
	/// Complexity: O(n).
	public static func ==(lhs: JSON, rhs: JSON) -> Bool {
		return lhs.value == rhs.value
	}
}

// MARK: CustomStringConvertible

extension JSON.Value: CustomStringConvertible {
	/// The string used for indentation levels in JSON.Value.description(_).
	private static let indentLevel = "    "
	
	/// Returns a pretty-printed version of this value.
	func description(_ objectIndent: String = "") -> String {
		let result: String
		switch self {
		case .String(let str):
			result = "\"\(str)\""
		case .Number(let str):
			result = str
		case .Object(let members):
			var str = "{"
			if members.count > 0 {
				// All pairs are indented another level beyond the brackets.
				let memberIndent = objectIndent + JSON.Value.indentLevel
				// Every member pair except the last needs to be separated by a
				// comma and newline. The last one just needs the newline.
				let strings = members.map({ "\n\(memberIndent)\"\($0.key)\": \($0.value.description(memberIndent))," })
				for string in strings.dropLast() {
					str.append(string)
				}
				// Need don't want a comma after the final pair.
				str.append(Swift.String(strings.last!.characters.dropLast()))
				// Put the closing bracket on its own line when we have at least
				// one member. Also include proper indentation.
				str.append("\n\(objectIndent)")
			}
			// If it's an empty object, we want it all on one line with no
			// whitespace between the opening and closing brackets.
			str.append("}")
			result = str
		case .Array(let elements):
			var str = "["
			let strings = elements.map({ return $0.description(objectIndent) })
			var first = true
			for string in strings {
				if first {
					first = false
				} else {
					str.append(", ")
				}
				str.append(string)
			}
			str.append("]")
			result = str
		case .Boolean(let b):
			result = b ? "true" : "false"
		case .Null:
			result = "null"
		}
		return result
	}
	
	var description: String {
		get {
			return self.description()
		}
	}
}

extension JSON: CustomStringConvertible {
	public var description: String {
		get {
			return self.value.description
		}
	}
}

// TODO: investigate possibility of overriding "as?" casts
// Syntax like this would be very useful:
// if let s = json as? String { /* do work */ }
