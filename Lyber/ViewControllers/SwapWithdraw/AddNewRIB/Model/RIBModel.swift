//
//  RIBModel.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 15/03/2024.
//

import Foundation

//MARK: RibAPI
struct RibAPI : Codable{
    var data : [RibData]
}

//MARK: RibAPI
struct RibData : Codable{
    var ribId : String
    var name : String
    var userName : String
    var iban : String
    var bic : String
    var bankCountry : String
    var ribStatus : String
}
