//
//  CryptoAddressBookModel.swift
//  Lyber
//
//  Created by sonam's Mac on 08/08/22.
//

import Foundation
// MARK: - CryptoAddressesAPI
struct CryptoAddressesAPI: Codable {
    let data: [Address]?
}

// MARK: - Address
struct Address: Codable {
    let asset: String?
	let address: String?
	let network: String? //TODO: -Delete network and remplace by asset
    let name: String
    let origin: String?
    let exchange: String?
    let creationDate: String?
}

