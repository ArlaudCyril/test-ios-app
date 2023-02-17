//
//  PersonalDataModel.swift
//  Lyber
//
//  Created by sonam's Mac on 30/06/22.
//

import Foundation
struct personalDataStruct : Codable{
    var fisrtName,lastName,birthPlace ,birthDate,birthCountry,nationality,isUsPerson,email,streetNumber ,buildingFloor,CityName,stateName,zipCode,CountryName ,investmentExp,sourceOfIncome ,workIndustry,annualIncome,personalAssets : String?
}

// MARK: - UserPersonalData
struct UserPersonalData : Codable {
    let _id : String?
    let phone_no : Int?
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
    }
}


// MARK: - ProfileAPI
//struct ProfileAPI: Codable {
//    let profilePic,profilePicType: String?
//    let profileAPIID, firstName, lastName, email: String?
//    let password: String?
//    let registrationDate, lastLogin: String?
//    let emailVerificationToken: String?
//    let emailVerified, documentVerification: Bool?
//    let isoCode: String?
//    let countryCode: String?
//    let phoneNo: Int?
//    let phoneVerificationCode: Int?
//    let phoneVerificationCodeGeneratedAt: String?
//    let pinVerificationCode: Int?
//    let pinVerificationCodeGeneratedAt: String?
//    let wrongAttempt: Int?
//    let twoAuthPinVerified, phoneNoVerified: Bool?
//    let forgotPasswordToken: String?
//    let bankAccountAdded: Bool?
//    let promoCode: String?
//    let balance: Double?
//    let profileVerificationStatus: String?
//    let loginPinSet: Bool?
//    let notificationCount, loginPin: Int?
//    let loginPinVerified: Bool?
//    let createdOn, modifiedOn: String?
//    let isBlocked, isDeleted, isLogOut,isStrongAuthEnabled,isStrongAuthVerified,isAddressWhitelistingEnabled: Bool?
//    let vaultAccountID, vaultAccountName: String?
//    let payoutPin, payoutSet: Int?
//    let bic, iban, nexoUserID, nexoUserSecret,extraSecurity: String?
//    let isPushEnabled, isSMSEnabled, isFaceIDEnabled: Int?
//    let faceID: String?
//    let investmentExperience, incomeSource: String?
//    let step, personalInfoStep: Int?
//    let specifiedUSPerson: Bool?
//    let personalAssets: String?
//    let citizenship: String?
//    let city, state, address1: String?
//    let address2, title: String?
//    let nationality, country: String?
//    let countryName: String?
//    let zipCode: Int?
//    let dob, birthCountry, birthPlace: String?
//    let totalWealth: String?
//    let occupation, incomeRange: String?
//    let fundsOrigin: String?
//    let id: String?
//    let v: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case profilePic = "profile_pic"
//        case profilePicType = "profile_pic_type"
//        case profileAPIID = "id"
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email, password
//        case registrationDate = "registration_date"
//        case lastLogin = "last_login"
//        case emailVerificationToken = "email_verification_token"
//        case emailVerified = "email_verified"
//        case documentVerification = "document_verification"
//        case isoCode = "iso_code"
//        case countryCode = "country_code"
//        case phoneNo = "phone_no"
//        case phoneVerificationCode = "phone_verification_code"
//        case phoneVerificationCodeGeneratedAt = "phone_verification_code_generated_at"
//        case pinVerificationCode = "pin_verification_code"
//        case pinVerificationCodeGeneratedAt = "pin_verification_code_generated_at"
//        case wrongAttempt = "wrong_attempt"
//        case twoAuthPinVerified = "two_auth_pin_verified"
//        case phoneNoVerified = "phone_no_verified"
//        case forgotPasswordToken = "forgot_password_token"
//        case bankAccountAdded = "bank_account_added"
//        case promoCode = "promo_code"
//        case balance
//        case profileVerificationStatus = "profile_verification_status"
//        case loginPinSet = "login_pin_set"
//        case notificationCount = "notification_count"
//        case loginPin = "login_pin"
//        case loginPinVerified = "login_pin_verified"
//        case createdOn = "created_on"
//        case modifiedOn = "modified_on"
//        case isBlocked = "is_blocked"
//        case isDeleted = "is_deleted"
//        case isLogOut = "is_logOut"
//        case vaultAccountID = "vault_account_id"
//        case vaultAccountName = "vault_account_name"
//        case payoutPin = "payout_pin"
//        case payoutSet = "payout_set"
//        case bic, iban
//        case nexoUserID = "nexo_user_id"
//        case nexoUserSecret = "nexo_user_secret"
//        case isPushEnabled = "is_push_enabled"
//        case isSMSEnabled = "is_sms_enabled"
//        case isFaceIDEnabled = "is_face_id_enabled"
//        case faceID = "face_id"
//        case investmentExperience = "investment_experience"
//        case incomeSource = "income_source"
//        case step
//        case personalInfoStep = "personal_info_step"
//        case specifiedUSPerson, personalAssets, citizenship, city, state, address1, address2, title, nationality, country, countryName
//        case zipCode = "zip_code"
//        case dob
//        case birthCountry = "birth_country"
//        case birthPlace = "birth_place"
//        case totalWealth = "total_wealth"
//        case occupation, incomeRange
//        case fundsOrigin = "funds_origin"
//        case id = "_id"
//        case v = "__v"
//        case extraSecurity = "extra_security"
//        case isStrongAuthEnabled = "is_strong_auth_enabled"
//        case isStrongAuthVerified = "is_strong_auth_verified"
//        case isAddressWhitelistingEnabled = "is_address_whitelisting_enabled"
//    }
//}


//MARK: - NEW PROFILE API

// MARK: - ProfileaAPI
struct ProfileAPI: Codable {
    let data: ProfileData?
}

// MARK: - DataClass
struct ProfileData: Codable {
    let uuid, email, firstName, lastName: String?
    let nationality: String?
    let profilePic: String?
    let profilePicType: String?
    let strongAuthentification: Bool?
    let phoneNo: String?
}
