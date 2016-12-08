//
//  JSON.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

/// The actual backing enum that holds type information. Never exposed outside
/// this module.
enum JSONValue {
	case String(Swift.String)
	case Number(Swift.String)
	case Object(members: [Swift.String: JSONValue])
	case Array(elements: [JSONValue])
	case Boolean(Bool)
	case Null
}

/// A representation of JSON.
public struct JSON {
	var value: JSONValue
	
	/// Used internally by JSONBuilder.
	init(value: JSONValue) {
		self.value = value
	}
}

// MARK: Public initializers

extension JSON {
	/// Initializes a JSON instance from the specified string. The string may be
	/// a JSON fragment (i.e. top-level value or literal), a JSON object, or a
	/// JSON array.
	public init?(string: String) {
		let builder = JSONBuilder(json: string)
		guard let json = builder.build() else {
			return nil
		}
		self = json
	}
	
	/// Initializes a JSON array with the specified elements.
	public init(array: [JSON]) {
		self.init(value: .Array(elements: array.map({ return $0.value })))
	}
	
	/// Internal initializer used by init(objectMembers:) as well as
	/// ExpressibleByDictionaryLiteral's initializer.
	internal init(objectMembers members: [(String, JSON)]) {
		var rawMembers: [String: JSONValue] = [:]
		// TODO: apply decision about duplicate keys here as well.
		for (key, value) in members {
			rawMembers[key] = value.value
		}
		self.init(value: .Object(members: rawMembers))
	}

	/// Initializes a JSON object with the specified members.
	public init(objectMembers members: [String: JSON]) {
		self.init(objectMembers: members.map({ return ($0.key, $0.value) }))
	}
}

// MARK: Integer conversion
// Macros sure would be useful here...

extension JSONValue {
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
				return JSON(value: value)
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
				return arr.map({ return JSON(value: $0) })
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

extension JSONValue: Equatable {
	/// Complexity: O(n).
	static func ==(lhs: JSONValue, rhs: JSONValue) -> Bool {
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

extension JSONValue: CustomStringConvertible {
	/// The string used for indentation levels in JSONValue.description(_).
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
				let memberIndent = objectIndent + JSONValue.indentLevel
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
	
	// TODO public var minifiedDescription: String { get }
}

// MARK: ExpressibleBy*Literal

extension JSON: ExpressibleByNilLiteral {
	/// Initialize a JSON null value using Swift's nil.
	public init(nilLiteral: ()) {
		self.init(value: .Null)
	}
}

extension JSON: ExpressibleByBooleanLiteral {
	public typealias BooleanLiteralType = Bool
	
	public init(booleanLiteral value: JSON.BooleanLiteralType) {
		self.init(value: .Boolean(value))
	}
}

extension JSON: ExpressibleByFloatLiteral {
	public typealias FloatLiteralType = Double
	
	public init(floatLiteral value: JSON.FloatLiteralType) {
		self.init(value: .Number(value.description))
	}
}

extension JSON: ExpressibleByIntegerLiteral {
	public typealias IntegerLiteralType = IntMax
	
	public init(integerLiteral value: JSON.IntegerLiteralType) {
		self.init(value: .Number(value.description))
	}
}

/// Note: This conformance initializes a JSON string. It does not initialize any
/// other JSON type. To initialize a JSON object, array, or other value from a
/// string, see `JSON.init(string:)`.
extension JSON: ExpressibleByStringLiteral {
	public typealias UnicodeScalarLiteralType = StringLiteralType
	public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
	public typealias StringLiteralType = String
	
	public init(unicodeScalarLiteral value: JSON.UnicodeScalarLiteralType) {
		self.init(value: .String(value))
	}

	public init(extendedGraphemeClusterLiteral value: JSON.ExtendedGraphemeClusterLiteralType) {
		self.init(value: .String(value))
	}

	public init(stringLiteral value: JSON.StringLiteralType) {
		self.init(value: .String(value))
	}
}

extension JSON: ExpressibleByArrayLiteral {
	// TODO: make this JSONEncodable once conditional conformances are available
	public typealias Element = JSON

	public init(arrayLiteral elements: JSON.Element...) {
		self.init(array: elements)
	}
}

extension JSON: ExpressibleByDictionaryLiteral {
	public typealias Key = String
	// TODO: make this JSONEncodable once conditional conformances are available
	public typealias Value = JSON
	
	public init(dictionaryLiteral elements: (JSON.Key, JSON.Value)...) {
		self.init(objectMembers: elements)
	}
}

// TODO: investigate possibility of overriding "as?" casts
// Syntax like this would be very useful:
// if let s = json as? String { /* do work */ }
