//
//  PersonalDataModel.swift
//  Lyber
//
//  Created by sonam's Mac on 30/06/22.
//

import Foundation
struct personalDataStruct : Codable{
    var fisrtName,lastName,birthPlace ,birthDate,birthCountry,nationality,isUsPerson,email, address,CityName,stateName,zipCode,CountryName ,investmentExp,sourceOfIncome ,workIndustry,annualIncome,activity,language : String?
}

//MARK: - NEW PROFILE API

// MARK: - ProfileaAPI
struct ProfileAPI: Codable {
    let data: ProfileData?
}

// MARK: - ProfileData
struct ProfileData: Codable {
    var uuid, email, phoneNo, firstName, lastName, language: String?
    var nationality, registeredAt: String?
    var avatar: String?
    var has2FA: Bool?
    var type2FA: String?
	var scope2FA: [String?]
    var profilePic: String?
    var yousignStatus: String?
    var kycStatus: String?
    
    init() {
        uuid = ""
        email = ""
        phoneNo = ""
        firstName = ""
        lastName = ""
        nationality = ""
		language = "french"
        has2FA = false
        type2FA = ""
        scope2FA = []
        profilePic = ""
        yousignStatus = ""
        kycStatus = ""
    }

}

