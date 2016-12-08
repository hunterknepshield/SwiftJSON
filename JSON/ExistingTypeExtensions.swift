//
//  ExistingTypeExtensions.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/8/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

// MARK: JSONDecodable

extension Bool: JSONDecodable {
	public init?(json: JSON) {
		guard let bool = json.bool else {
			return nil
		}
		self.init(bool)
	}
}

extension String: JSONDecodable {
	public init?(json: JSON) {
		guard let string = json.string else {
			return nil
		}
		self.init(string)
	}
}

// Macros would be really useful here again...

extension Double: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.double else {
			return nil
		}
		self.init(number)
	}
}

extension Float: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.float else {
			return nil
		}
		self.init(number)
	}
}

extension Int64: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.int64 else {
			return nil
		}
		self.init(number)
	}
}

extension UInt64: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.uint64 else {
			return nil
		}
		self.init(number)
	}
}

extension Int32: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.int32 else {
			return nil
		}
		self.init(number)
	}
}

extension UInt32: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.uint32 else {
			return nil
		}
		self.init(number)
	}
}

extension Int: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.int else {
			return nil
		}
		self.init(number)
	}
}

extension UInt: JSONDecodable {
	public init?(json: JSON) {
		guard let number = json.uint else {
			return nil
		}
		self.init(number)
	}
}

// TODO: Conditional conformance when available
// extension Dictionary: JSONDecodable where Key == String, Value: JSONDecodable {
//     public init?(json: JSON) { /* ... */ }
// }

// TODO: Conditional conformance when available
// extension Array: JSONDecodable where Element: JSONDecodable {
extension Array where Element: JSONDecodable {
	/// Attempts to construct an Array from a JSON array. Returns nil if any of
	/// the elements of the JSON array fail to initialize an element object.
	public init?(jsonArray: [JSON]) {
		self.init()
		self.reserveCapacity(jsonArray.count)
		for jsonElement in jsonArray {
			guard let element = Element(json: jsonElement) else {
				return nil
			}
			self.append(element)
		}
	}
	
	/// Attempts to construct an Array from a JSON object. Returns nil if the
	/// JSON is not an array or if `init?(jsonArray:)` fails.
	public init?(json: JSON) {
		guard let array = json.array else {
			return nil
		}
		self.init(jsonArray: array)
	}
	
	/// Attempts to construct an Array from a raw JSON array string. Returns nil
	/// if a JSON object cannot be constructed from the supplied string or if
	/// `init?(json:)` fails.
	public init?(rawJson: String) {
		guard let json = JSON(rawJson: rawJson) else {
			return nil
		}
		self.init(json: json)
	}
}

// The following definition would be redundant, even when considering `null`
// JSON values:
// extension Optional where Wrapped: JSONDecodable { /* ... */ }

// MARK: JSONEncodable

extension Bool: JSONEncodable {
	public var json: JSON {
		get {
			return self ? JSON.true : JSON.false
		}
	}
}

extension String: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .String(self))
		}
	}
}

extension Double: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension Float: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension Int64: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension UInt64: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension Int32: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension UInt32: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension Int: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

extension UInt: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Number(self.description))
		}
	}
}

// TODO: Conditional conformance when available
// extension Dictionary: JSONEncodable where Key == String, Value: JSONEncodable {
//     public var json: JSON? { get { /* ... */ } }
// }

// TODO: Conditional conformance when available
// extension Array: JSONEncodable where Element: JSONEncodable {
extension Array where Element: JSONEncodable {
	public var jsonArray: [JSON] {
		get {
			return self.map({ return $0.json })
		}
	}
	
	public var json: JSON {
		get {
			return JSON(array: self.jsonArray)
		}
	}
}

// TODO: Conditional conformance when available
// extension Optional: JSONEncodable where Wrapped: JSONEncodable {
extension Optional where Wrapped: JSONEncodable {
	/// `Optional<JSONEncodable>`'s `json` property will return a null JSON
	/// instance if the underlying value is `nil`. Otherwise, it returns the
	/// wrapped value's `json` property.
	public var json: JSON {
		get {
			switch self {
			case .none:
				return JSON.null
			case .some(let wrapped):
				return wrapped.json
			}
		}
	}
}
