//
//  PersonalDataModel.swift
//  Lyber
//
//  Created by sonam's Mac on 30/06/22.
//

import Foundation
struct personalDataStruct : Codable{
    var fisrtName,lastName,birthPlace ,birthDate,birthCountry,nationality,isUsPerson,email,streetNumber ,buildingFloor,CityName,stateName,zipCode,CountryName ,investmentExp,sourceOfIncome ,workIndustry,annualIncome,personalAssets,language : String?
}

// MARK: - UserPersonalData
struct UserPersonalData : Codable {
    let _id : String?
    let phone_no : String?
    let country_code : String?
    let first_name,email : String?
    let last_name : String?
    let treezor_user_id : Int?
    let city : String?
    let country : String?
    let state : String?
    let nationality : String?
    let countryName : String?
    let incomeRange : String?
    let occupation : String?
    let personalAssets : String?
	let specifiedUSPerson : Bool?
    let birth_place : String?
    let birth_country : String?
    let address1 : String?
    let zip_code : Int?
    let dob : String?
    let wallet_id : Int?
    let kyc_review : Int?
    let kyc_status : String?
    let kyc_level : Int?
    let investment_experience : String?
    let income_source : String?
    let comment : String?
    let score : Int?
    let user_status : String?
    let wallet_status : String?
    let iban : String?
    let bic : String?
    let citizenship : String?
    let doc_status : String?
	let language : String?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case phone_no = "phone_no"
        case country_code = "country_code"
        case first_name = "first_name"
        case last_name = "last_name"
        case treezor_user_id = "treezor_user_id"
        case city = "city"
        case country = "country"
        case state = "state"
        case nationality = "nationality"
        case countryName = "countryName"
        case incomeRange = "incomeRange"
        case occupation = "occupation"
        case personalAssets = "personalAssets"
		case specifiedUSPerson = "specifiedUSPerson"
        case birth_place = "birth_place"
        case birth_country = "birth_country"
        case address1 = "address1"
        case zip_code = "zip_code"
        case dob = "dob"
        case wallet_id = "wallet_id"
        case kyc_review = "kyc_review"
        case kyc_status = "kyc_status"
        case kyc_level = "kyc_level"
        case investment_experience = "investment_experience"
        case income_source = "income_source"
        case comment = "comment"
        case score = "score"
        case user_status = "user_status"
        case wallet_status = "wallet_status"
        case iban = "iban"
        case bic = "bic"
        case citizenship = "citizenship"
        case doc_status = "doc_status"
        case email = "email"
		case language = "language"
    }
}



//MARK: - NEW PROFILE API

// MARK: - ProfileaAPI
struct ProfileAPI: Codable {
    let data: ProfileData?
}

// MARK: - ProfileData
struct ProfileData: Codable {
    var uuid, email, phoneNo, firstName, lastName, language: String?
    var nationality: String?
    var avatar: String?
    var has2FA: Bool?
    var type2FA: String?
	var scope2FA: [String?]
    var profilePic: String?
    
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
    }

}

