//
//  GoogleAuthenticatorModel.swift
//  Lyber
//
//  Created by Lyber on 08/03/2023.
//

import Foundation

// MARK: - UrlAPI
struct UrlAPI: Codable {
    let data: Url?
}

// MARK: - Url
struct Url: Codable {
    let url: String?
}

// MARK: - KycAPI
struct KycAPI: Codable {
	let data: Kyc?
}

// MARK: - Kyc
struct Kyc: Codable {
	let url: String?
	let didSign: Bool?
}
