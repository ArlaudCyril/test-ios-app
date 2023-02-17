//
//  KYCVerificationModel.swift
//  Lyber
//
//  Created by sonam's Mac on 04/07/22.
//

import Foundation
// MARK: - KycStatusModel
struct KycStatusModel: Codable {
    let ubbleLink: String?
    let score: Int?
    let kycStatus, comment: String?
    let isLivenessInitiated: Bool?
    let kycLevel, kycReview: Int?
    let isPayinDone: Bool?
    let userStatus, walletStatus, iban, bic: String?

    enum CodingKeys: String, CodingKey {
        case ubbleLink = "ubble_link"
        case score
        case kycStatus = "kyc_status"
        case comment
        case isLivenessInitiated = "is_liveness_initiated"
        case kycLevel = "kyc_level"
        case kycReview = "kyc_review"
        case isPayinDone = "is_payin_done"
        case userStatus = "user_status"
        case walletStatus = "wallet_status"
        case iban, bic
    }
}


// MARK: - KycStatusModel
struct KycLivenessModel: Codable {
    let identification: Identification?
    let statusCode: Int?
}

// MARK: - Identification
struct Identification: Codable {
    let identificationID: String?
    let identificationURL: String?

    enum CodingKeys: String, CodingKey {
        case identificationID = "identification_id"
        case identificationURL = "identification_url"
    }
}
