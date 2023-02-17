//
//  CryptoAddressBookModel.swift
//  Lyber
//
//  Created by sonam's Mac on 08/08/22.
//

import Foundation
// MARK: - WhitelistingaddresesAPi
struct WhitelistingAddressesAPI: Codable {
    let count: Int?
    let addresses: [Address]?
}

// MARK: - Address
struct Address: Codable {
    let id: String?
    let asset: String?
    let logo: String?
    let name: String
    let tag: String?
    let address: String?
    let network: String?
    let origin: String?
    let exchange: String?
    let createdAt: String?
    let updatedAt: String?
    let isDeleted: Bool?
    let userID: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case asset, logo, name, tag, address, network, origin,exchange
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isDeleted = "is_deleted"
        case userID = "user_id"
        case v = "__v"
    }
}

