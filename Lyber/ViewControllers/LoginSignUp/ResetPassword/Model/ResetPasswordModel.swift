//
//  ResetPasswordModel.swift
//  Lyber
//
//  Created by Lyber on 04/08/2023.
//


import Foundation

//MARK: - IdentifiersAPI
struct IdentifiersAPI : Codable{
	var data : Identifiers
}

//MARK: - Identifiers
struct Identifiers : Codable{
	var email, phoneNo : String?
}
