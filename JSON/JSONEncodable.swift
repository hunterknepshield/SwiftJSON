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
	/// The representation of this value as a JSON object.
	var json: JSON { get }
}
