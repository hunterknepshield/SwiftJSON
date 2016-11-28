//
//  Token.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

enum Token {
	case OpenObject  // "{"
	case CloseObject  // "}"
	case OpenArray  // "["
	case CloseArray  // "]"
	
	case Colon  // ":"
	case Comma  // ","
	
	case Null  // The "null" literal
	case String(Swift.String)  // A string literal
	case Boolean(Bool)  // A "true" or "false" literal
	case Number(Swift.String)  // A number literal
}

extension Token: Equatable {
	static func ==(lhs: Token, rhs: Token) -> Bool {
		switch (lhs, rhs) {
		case (.OpenObject, .OpenObject), (.CloseObject, .CloseObject), (.OpenArray, .OpenArray), (.CloseArray, .CloseArray), (.Colon, .Colon), (.Comma, .Comma), (.Null, .Null):
			return true
		case (.Boolean(let lb), .Boolean(let rb)):
			return lb == rb
		case (.String(let ls), .String(let rs)), (.Number(let ls), .Number(let rs)):
			return ls == rs
		default:
			return false
		}
	}
}
