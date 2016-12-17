//
//  JSON.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

/// A representation of JSON.
public enum JSON {
	case String(Swift.String)
	case Number(Swift.String)
	case Object(members: [Swift.String: JSON])
	case Array(elements: [JSON])
	case Boolean(Bool)
	case Null
}

// MARK: Public initializers

extension JSON {
	/// Initializes a JSON instance from the specified String. The string may be
	/// a JSON fragment (i.e. top-level value or literal), a JSON object, or a
	/// JSON array. Returns nil if the string produces malformed JSON.
	public init?(rawJson: String) {
		let builder = JSONBuilder(json: rawJson)
		guard let json = builder.build() else {
			return nil
		}
		self = json
	}
	
	/// Initializes a JSON instance from the specified Data instance. Returns
	/// nil if the data cannot be represented as a String or if the data
	/// produces malformed JSON.
	public init?(data: Data, encoding: Swift.String.Encoding = .utf8) {
		guard let string = Swift.String(data: data, encoding: encoding) else {
			return nil
		}
		self.init(rawJson: string)
	}
	
	/// Initializes a JSON array with the specified elements.
	public init(array: [JSON]) {
		self = .Array(elements: array)
	}
	
	/// Internal initializer used by init(objectMembers:) as well as
	/// ExpressibleByDictionaryLiteral's initializer.
	internal init(objectMembers members: [(String, JSON)]) {
		var rawMembers: [String: JSON] = [:]
		// TODO: apply decision about duplicate keys here as well.
		for (key, value) in members {
			rawMembers[key] = value
		}
		self = .Object(members: rawMembers)
	}

	/// Initializes a JSON object with the specified members.
	public init(objectMembers members: [String: JSON]) {
		self.init(objectMembers: members.map({ return ($0.key, $0.value) }))
	}
}

// MARK: Static instances

extension JSON {
	/// A convenience accessor for a null JSON instance, as if it were
	/// initialized from the `null` literal.
	///
	/// Alternatively, Swift's `nil` literal can be used to initialize a JSON
	/// instance like so:
	/// ```
	/// let nullJson: JSON = nil
	/// ```
	public static let null: JSON = .Null
	/// A convenience accessor for a true JSON instance, as if it were
	/// initialized from the `true` literal.
	///
	/// Alternatively, Swift's `true` literal can be used to initialize a JSON
	/// instance like so:
	/// ```
	/// let trueJson: JSON = true
	/// ```
	public static let `true`: JSON = .Boolean(true)
	/// A convenience accessor for a false JSON instance, as if it were
	/// initialized from the `false` literal.
	///
	/// Alternatively, Swift's `false` literal can be used to initialize a JSON
	/// instance like so:
	/// ```
	/// let falseJson: JSON = false
	/// ```
	public static let `false`: JSON = .Boolean(false)
}

// MARK: Properties

extension JSON {
	// TODO: should these subscripts be mutable?
	/// Fetches a value from a JSON object with the supplied key. Returns nil if
	/// the JSON isn't an object or if no such key exists in the object.
	public subscript(_ key: String) -> JSON? {
		get {
			switch self {
			case .Object(let members):
				return members[key]
			default:
				return nil
			}
		}
	}
	/// Fetches a value from a JSON array with the specified index. Returns nil
	/// if the JSON isn't an array. May cause a runtime error if the index is
	/// out of bounds.
	public subscript(_ index: Int) -> JSON? {
		get {
			switch self {
			case .Array(let elements):
				return elements[index]
			default:
				return nil
			}
		}
	}
	
	/// Returns the underlying JSON array. Returns nil if the JSON isn't an
	/// array.
	public var array: [JSON]? {
		get {
			switch self {
			case .Array(let arr):
				return arr
			default:
				return nil
			}
		}
	}
	/// Returns the underlying JSON string. Returns nil if the JSON isn't a
	/// string.
	public var string: String? {
		get {
			switch self {
			case .String(let str):
				return str
			default:
				return nil
			}
		}
	}
	/// Returns the underlying bool. Returns nil if the JSON isn't a boolean
	/// literal.
	public var bool: Bool? {
		get {
			switch self {
			case .Boolean(let bool):
				return bool
			default:
				return nil
			}
		}
	}
	/// The actual root conversion. Everything else is implemented as a type
	/// cast from a Double.
	var double: Double? {
		get {
			guard case .Number(let string) = self else {
				return nil
			}
			return Double(string)
		}
	}
	var float: Float? {
		get {
			guard let double = self.double else {
				return nil
			}
			return Float(double)
		}
	}
	var int64: Int64? {
		get {
			guard let double = self.double else {
				return nil
			}
			return Int64(double)
		}
	}
	var uint64: UInt64? {
		get {
			guard let double = self.double else {
				return nil
			}
			return UInt64(double)
		}
	}
	var int32: Int32? {
		get {
			guard let double = self.double else {
				return nil
			}
			return Int32(double)
		}
	}
	var uint32: UInt32? {
		get {
			guard let double = self.double else {
				return nil
			}
			return UInt32(double)
		}
	}
	var int: Int? {
		get {
			guard let double = self.double else {
				return nil
			}
			return Int(double)
		}
	}
	var uint: UInt? {
		get {
			guard let double = self.double else {
				return nil
			}
			return UInt(double)
		}
	}

	// TODO: Decide whether -1 is ok or if nil should be returned.
	/// Returns the count of the number of members if this is a JSON object, the
	/// count of the number of elements if this is a JSON array, or -1,
	/// indicating this type doesn't have a count.
	public var count: Int {
		get {
			switch self {
			case .Object(let members):
				return members.count
			case .Array(let elements):
				return elements.count
			default:
				return -1
			}
		}
	}
}

// MARK: Type inspection

extension JSON {
	/// Returns whether or not this JSON is a string.
	public var isString: Bool {
		get {
			switch self {
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
			switch self {
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
			switch self {
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
			switch self {
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
			switch self {
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
			switch self {
			case .Null:
				return true
			default:
				return false
			}
		}
	}
}

// MARK: Equatable

extension JSON: Equatable {
	/// Complexity: O(n).
	public static func ==(lhs: JSON, rhs: JSON) -> Bool {
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

// MARK: CustomStringConvertible

extension JSON: CustomStringConvertible {
	/// The string used for indentation levels in JSON.description(_).
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
				let memberIndent = objectIndent + JSON.indentLevel
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
	
	public var description: String {
		get {
			return self.description()
		}
	}

	// TODO public var minifiedDescription: String { get }
}

// MARK: Sequence

extension JSON: Sequence {
	public struct Iterator: IteratorProtocol {
		enum IteratorType {
			case Array(elements: [JSON])
			case Object(members: [(String, JSON)])
			case NotIterable
		}
		
		public typealias Element = (String, JSON)
		
		private let type: IteratorType
		private var index: Int = 0
		
		init(json: JSON) {
			switch json {
			case .Array(let elements):
				self.type = .Array(elements: elements)
			case .Object(let members):
				self.type = .Object(members: members.map({ return ($0.0, $0.1) }))
			default:
				self.type = .NotIterable
			}
		}
		
		public mutating func next() -> Element? {
			switch self.type {
			case .Array(let elements):
				guard index < elements.count else {
					return nil
				}
				defer {
					index += 1
				}
				return (index.description, elements[index])
			case .Object(let members):
				guard index < members.count else {
					return nil
				}
				defer {
					index += 1
				}
				return members[index]
			default:
				return nil
			}
		}
	}
	
	public func makeIterator() -> Iterator {
		return Iterator(json: self)
	}
}

// MARK: ExpressibleBy*Literal

extension JSON: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {
		self = .null
	}
}

extension JSON: ExpressibleByBooleanLiteral {
	public init(booleanLiteral value: BooleanLiteralType) {
		self = value ? JSON.true : JSON.false
	}
}

extension JSON: ExpressibleByFloatLiteral {
	public init(floatLiteral value: FloatLiteralType) {
		self = .Number(value.description)
	}
}

extension JSON: ExpressibleByIntegerLiteral {
	public init(integerLiteral value: IntegerLiteralType) {
		self = .Number(value.description)
	}
}

/// Note: This conformance initializes a JSON string. It does not initialize any
/// other JSON type. To initialize a JSON object, array, or other value from a
/// string, see `JSON.init(string:)`.
extension JSON: ExpressibleByStringLiteral {
	public init(unicodeScalarLiteral value: StringLiteralType) {
		self = .String(value)
	}

	public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
		self = .String(value)
	}

	public init(stringLiteral value: StringLiteralType) {
		self = .String(value)
	}
}

extension JSON: ExpressibleByArrayLiteral {
	public init(arrayLiteral elements: JSONEncodable...) {
		self.init(array: elements.map({ return $0.json }))
	}
}

extension JSON: ExpressibleByDictionaryLiteral {
	public init(dictionaryLiteral elements: (String, JSONEncodable)...) {
		self.init(objectMembers: elements.map({ return ($0.0, $0.1.json) }))
	}
}

// MARK: JSONEncodable

// TODO: investigate removal once Array<JSONEncodable> can itself be constrained
// to JSONEncodable.
extension JSON: JSONEncodable {
	/// **Only use this member for constructing JSON from literals. This will be
	/// removed in a future version of Swift where conditional protocol
	/// conformances are available.**
	///
	/// Currently, it is impossible for a generic type to be conditionally
	/// extended to conform to a protocol, i.e. Array<JSONEncodable> cannot
	/// itself be JSONEncodable. This requires a bit of awkwardness when using
	/// JSON literals, like so:
	/// ```
	/// class Decodable: JSONDecodable {
	///     let array: [Int]
	///
	///     public init?(json: JSON) { /* truncated */ }
	/// }
	///
	/// let json: JSON = ["array": [1, 2, 3].json]
	/// ```
	/// When constructing the JSON from the literal, the array's `json` property
	/// must be explicitly specified because Array\<Int\> cannot be
	/// JSONEncodable, even though Int (its Element type) is JSONEncodable. This
	/// is intended to be rectified in a future Swift version, but for now, this
	/// must be.
	public var json: JSON {
		get {
			return self
		}
	}
}

// TODO: investigate possibility of overriding "as?" casts
// Syntax like this would be very useful:
// if let s = json as? String { /* do work */ }
