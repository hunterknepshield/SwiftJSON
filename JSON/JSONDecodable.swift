//
//  JSONDecodable.swift
//  JSON
//
//  Created by Hunter Knepshield on 12/7/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

/// Conform to this protocol to define an initializer that initializes a
/// conforming type from a JSON object. A default convenience initializer allows
/// an instance to be initialized directly from a raw JSON string as well.
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
