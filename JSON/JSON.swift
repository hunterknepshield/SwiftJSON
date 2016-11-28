//
//  JSON.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

struct JSON {
	enum JSONType {
		case String(Swift.String)
		case Number(Swift.String)
		case Object(members: [Swift.String: JSON])
		case Array(elements: [JSON])
		case Boolean(Bool)
		case Null
	}
	
	private var type: JSONType
	
	internal init(_ type: JSONType) {
		self.type = type
	}
}
