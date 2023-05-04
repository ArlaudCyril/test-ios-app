//
//  CryptoDepositeModel.swift
//  Lyber
//
//  Created by Lyber on 19/04/2023.
//

import Foundation

// MARK: - AddressAPI
struct WalletAddressAPI: Codable{
	let data: WalletAddress?
}

// MARK: - Address
struct WalletAddress : Codable{
	let address: String?
}
