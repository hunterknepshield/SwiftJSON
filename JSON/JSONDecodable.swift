//
//  JSONDecodable.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/7/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

/// Conform to this protocol to get an initializer that constructs a conforming
/// type from a JSON object. A convenience initializer allows a conforming type
/// to be constructed directly from a raw JSON string.
public protocol JSONDecodable {
	/// Initialize an instance from a JSON object. Returns nil if the object
	/// could not be initialized from the specified JSON.
	///
	/// Types that conform to JSONDecodable are not necessarily required to make
	/// this initializer failable.
	init?(json: JSON)
	
	/// Attempts to construct a JSON object from the supplied string and uses
	/// `init?(json:)` from there. Returns nil if a JSON object cannot be
	/// constructed from the supplied string or if the user-defined initializer
	/// returns nil.
	init?(rawJson: String)
}

extension JSONDecodable {
	public init?(rawJson: String) {
		guard let json = JSON(string: rawJson) else {
			return nil
		}
		self.init(json: json)
	}
}

// MARK: Existing type extensions

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
		guard let json = JSON(string: rawJson) else {
			return nil
		}
		self.init(json: json)
	}
}
