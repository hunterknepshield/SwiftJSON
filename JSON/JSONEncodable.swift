//
//  JSONEncodable.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/7/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

public protocol JSONEncodable {
	var json: JSON? { get }
}

// TODO: Conditional conformance when available
// extension Dictionary: JSONEncodable where Key == String, Value: JSONEncodable {
//     public var json: JSON? { get { /* ... */ } }
// }

// TODO: Conditional conformance when available
// extension Array: JSONEncodable where Element: JSONEncodable {
extension Array where Element: JSONEncodable {
	public var jsonArray: [JSON]? {
		get {
			var array = [JSON]()
			array.reserveCapacity(self.count)
			for element in self {
				guard let json = element.json else {
					return nil
				}
				array.append(json)
			}
			return array
		}
	}
	
	public var json: JSON? {
		get {
			guard let array = self.jsonArray else {
				return nil
			}
			return JSON(value: .Array(elements: array.map({ return $0.value })))
		}
	}
}
