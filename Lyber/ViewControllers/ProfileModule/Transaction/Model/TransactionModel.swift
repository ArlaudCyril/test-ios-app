//
//  TransactionModel.swift
//  Lyber
//
//  Created by sonam's Mac on 21/07/22.
//

import Foundation

// MARK: - TransactionsAPI
struct TransactionsAPI: Codable {
    let transactions: [Transaction]?
}

// MARK: - Transaction
struct Transaction: Codable {
    let assetID, exchangeFrom, exchangeTo: String?
    let exchangeToAmount,exchangeFromAmount: Double?
    let status: Int?
    let withdrawalWalletAddress: String?
    let type, amount,assetAmoount: Double?
    let createdAt, id: String?
    let userID: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case exchangeFrom = "exchange_from"
        case exchangeTo = "exchange_to"
        case exchangeToAmount = "exchange_to_amount"
        case exchangeFromAmount = "exchange_from_amount"
        case status
        case withdrawalWalletAddress = "withdrawal_wallet_address"
        case type, amount
        case assetAmoount = "asset_amount"
        case createdAt = "created_at"
        case id = "_id"
        case userID = "user_id"
        case v = "__v"
    }
}
