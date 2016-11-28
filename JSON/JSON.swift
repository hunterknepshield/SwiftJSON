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
		
		// TODO: CustomStringConvertible conformance
	}
	
	var value: Value
	
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
	
	/// Used internally by Builder.
	init(_ value: Value) {
		self.value = value
	}
	
	public init?(string: String) {
		let builder = Builder(json: string)
		if let json = builder.build() {
			self = json
		} else {
			return nil
		}
	}
}

extension JSON.Value: Equatable {
	static func ==(lhs: JSON.Value, rhs: JSON.Value) -> Bool {
		return false
	}
}

extension JSON: Equatable {
	public static func ==(lhs: JSON, rhs: JSON) -> Bool {
		switch (lhs.value, rhs.value) {
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
				guard let rvalue = rm[lkey] else {
					return false
				}
				if lvalue != rvalue {
					return false
				}
			}
			return true
		default:
			return false
		}
	}
}

// TODO: investigate possibility of overriding "as?" casts
// Syntax like this would be very useful:
// if let s = json as? String { /* do work */ }
