//
//  EnterPhoneModel.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation
// MARK: - LoginAPI
struct LoginAPI: Codable {
    let message, token: String?
    let user: User?
}

// MARK: - User
struct User: Codable {
    let profilePic,profilePicType: String?
    let userID: String?
    let firstName, lastName, email, password: String?
    let registrationDate, lastLogin: String?
    let emailVerificationToken: String?
    let emailVerified, documentVerification: Bool?
    let isoCode: String?
    let countryCode: String?
    let phoneNo: String?
    let phoneVerificationCode: Int?
    let phoneVerificationCodeGeneratedAt: String?
    let pinVerificationCode: Int?
    let pinVerificationCodeGeneratedAt: String?
    let wrongAttempt: Int?
    let twoAuthPinVerified, phoneNoVerified: Bool?
    let forgotPasswordToken: String?
    let bankAccountAdded: Bool?
    let promoCode: String?
    let balance: Double?
    let profileVerificationStatus: String?
    let loginPinSet: Bool?
    let notificationCount, loginPin: Int?
    let loginPinVerified,isStrongAuthEnabled,isStrongAuthVerified,isAddressWhitelistingEnabled: Bool?
    let createdOn, modifiedOn: String?
    let isBlocked, isDeleted, isLogOut: Bool?
    let vaultAccountID, vaultAccountName: String?
    let payoutPin, payoutSet: Int?
    let bic, iban, nexoUserID, nexoUserSecret,faceID,extraSecurity: String?
    let isPushEnabled, isSMSEnabled, isFaceIDEnabled: Int?
    let step,personal_info_step: Int?
    let id: String?
    let devices: [Device]?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case profilePic = "profile_pic"
        case profilePicType = "profile_pic_type"
        case userID = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, password
        case registrationDate = "registration_date"
        case lastLogin = "last_login"
        case emailVerificationToken = "email_verification_token"
        case emailVerified = "email_verified"
        case documentVerification = "document_verification"
        case isoCode = "iso_code"
        case countryCode = "country_code"
        case phoneNo = "phone_no"
        case phoneVerificationCode = "phone_verification_code"
        case phoneVerificationCodeGeneratedAt = "phone_verification_code_generated_at"
        case pinVerificationCode = "pin_verification_code"
        case pinVerificationCodeGeneratedAt = "pin_verification_code_generated_at"
        case wrongAttempt = "wrong_attempt"
        case twoAuthPinVerified = "two_auth_pin_verified"
        case phoneNoVerified = "phone_no_verified"
        case forgotPasswordToken = "forgot_password_token"
        case bankAccountAdded = "bank_account_added"
        case promoCode = "promo_code"
        case balance
        case profileVerificationStatus = "profile_verification_status"
        case loginPinSet = "login_pin_set"
        case notificationCount = "notification_count"
        case loginPin = "login_pin"
        case loginPinVerified = "login_pin_verified"
        case createdOn = "created_on"
        case modifiedOn = "modified_on"
        case isBlocked = "is_blocked"
        case isDeleted = "is_deleted"
        case isLogOut = "is_logOut"
        case vaultAccountID = "vault_account_id"
        case vaultAccountName = "vault_account_name"
        case payoutPin = "payout_pin"
        case payoutSet = "payout_set"
        case bic, iban
        case nexoUserID = "nexo_user_id"
        case nexoUserSecret = "nexo_user_secret"
        case isPushEnabled = "is_push_enabled"
        case isSMSEnabled = "is_sms_enabled"
        case isFaceIDEnabled = "is_face_id_enabled"
        case faceID = "face_id"
        case step = "step"
        case personal_info_step = "personal_info_step"
        case id = "_id"
        case devices
        case v = "__v"
        case extraSecurity = "extra_security"
        case isStrongAuthEnabled = "is_strong_auth_enabled"
        case isStrongAuthVerified = "is_strong_auth_verified"
        case isAddressWhitelistingEnabled = "is_address_whitelisting_enabled"
    }
}


// MARK: - Device
struct Device: Codable {
    let deviceID, deviceType, accessToken: String?
    let id: String?

    enum CodingKeys: String, CodingKey {
        case deviceID = "device_id"
        case deviceType = "device_type"
        case accessToken = "access_token"
        case id = "_id"
    }
}
// MARK: - OTPAPI
struct OTPAPI: Codable {
    let message,msg: String?
    
}
// MARK: - ResendOtpAPI
struct ResendOtpAPI: Codable {
    let statusCode: Int?
    let message: String?
    let data: dataResendOtp?
}

// MARK: - DataClass
struct dataResendOtp: Codable {
    let message, token: String?
}

// MARK: - signUpApiClass
struct signUpApi: Codable {
    let data: signUpData?
}
struct signUpData: Codable {
    let token: String?
}










//mark :- new apis
// MARK: - LoginChallengeAPI
struct LoginChallengeAPI: Codable {
    let data: challengeClass?
}

// MARK: - DataClass
struct challengeClass: Codable {
    let token, b, salt, phoneNo: String?

    enum CodingKeys: String, CodingKey {
        case token
        case b = "B"
        case salt, phoneNo
    }
}


// MARK: - LoginAPI
struct LogInAPI: Codable {
    let data: LoginData?
}

// MARK: - DataClass
//{ has2FA: true, type2FA: "email" | "phone" | "otp" }
//access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2Nzg3ODg1NDcsImV4cCI6MTY3ODg3NDk0NywiYXVkIjoidXNlciIsInN1YiI6ImM3MzFmYzFiLTQyNmEtNDFlYi04YWE2LWJhN2YzODRhYTU4YyJ9.WEcrYoYLllGuRJ7Cz7aL89Q1jpEVomYw3uSIB6SVrSQ",
//refresh_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2Nzg3ODg1NDcsImV4cCI6MTY4MTM4MDU0NywiYXVkIjoicmVmcmVzaF90b2tlbiIsInN1YiI6ImM3MzFmYzFiLTQyNmEtNDFlYi04YWE2LWJhN2YzODRhYTU4YyJ9.dODpehqr5JXsCriInd8XsyxKuTAsoCXPr7rB0lqYwJA"
struct LoginData: Codable {
    let accessToken, refreshToken, m2, type2FA: String?
    let has2FA: Bool?
   

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case m2 = "M2"
        case type2FA = "type2FA"
        case has2FA = "has2FA"
    }
}
