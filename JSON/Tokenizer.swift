//
//  Tokenizer.swift
//  JSON
//
//  Created by Hunter Knepshield on 11/28/16.
//  Copyright © 2016 Hunter Knepshield. All rights reserved.
//

class Tokenizer {
	private let json: String
	private var iterator: String.CharacterView.Iterator
	
	init(json: String) {
		self.json = json
		self.iterator = self.json.characters.makeIterator()
	}
	
	func next() throws -> Token? {
		return nil
	}
}
