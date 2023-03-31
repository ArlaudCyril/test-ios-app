//
//  LanguageModel.swift
//  Lyber
//
//  Created by Lyber on 28/03/2023.
//

import Foundation

struct Language{
	let id: String
	let name: String
	let image: Assets
	
	init(id: String, name: String, image: Assets) {
		self.id = id
		self.name = name
		self.image = image
	}
}
