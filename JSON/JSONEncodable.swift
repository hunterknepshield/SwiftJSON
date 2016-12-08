//
//  JSONEncodable.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/7/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

/// Conform to this protocol to define a `json` property on your type. This may
/// be used to initialize JSON instances from user-defined types.
public protocol JSONEncodable {
	var json: JSON { get }
}

// MARK: Existing type extensions

extension Bool: JSONEncodable {
	public var json: JSON {
		get {
			return JSON(value: .Boolean(self))
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
