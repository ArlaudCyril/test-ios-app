//
//  RecurringDetailModel.swift
//  Lyber
//
//  Created by sonam's Mac on 29/08/22.
//

import Foundation
// MARK: - RecurringInvestmentDetailAPi
struct RecurringInvestmentDetailAPi: Codable {
    let id, userInvestmentStrategyID, userID: String?
    let assetID, strategyName: String?
    let isOwnStrategy: Int?
    let strategyAssets: [InvestmentStrategyAsset]?
    let frequency: String?
    let amount: Double?
    let isChosen: Bool?
    let assetAmount: Double?
    let type, createdAt: String?
    let isCancelled: Bool?
    let history: [History]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userInvestmentStrategyID = "user_investment_strategy_id"
        case userID = "user_id"
        case assetID = "asset_id"
        case strategyName = "strategy_name"
        case isOwnStrategy = "is_own_strategy"
        case strategyAssets = "strategy_assets"
        case frequency, amount
        case isChosen = "is_chosen"
        case assetAmount = "asset_amount"
        case type
        case createdAt = "created_at"
        case isCancelled = "is_cancelled"
        case history
    }
}

// MARK: - History
struct History: Codable {
    let assetID: String?
    let exchangeFrom, exchangeTo: String?
    let exchangeToAmount, exchangeFromAmount: Double?
    let withdrawalWalletAddress, whitelistedAddressID: String?
    let status, type, amount, assetAmount: Double?
    let createdAt, userInvestmentID, id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case exchangeFrom = "exchange_from"
        case exchangeTo = "exchange_to"
        case exchangeToAmount = "exchange_to_amount"
        case exchangeFromAmount = "exchange_from_amount"
        case withdrawalWalletAddress = "withdrawal_wallet_address"
        case whitelistedAddressID = "whitelisted_address_id"
        case status, type, amount
        case assetAmount = "asset_amount"
        case createdAt = "created_at"
        case userInvestmentID = "user_investment_id"
        case id = "_id"
        case v = "__v"
    }
}


//// MARK: - StrategyAsset
//struct StrategyAsset: Codable {
//    let id, assetID: String?
//    let assetName: String?
//    let allocation: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case assetID = "asset_id"
//        case assetName = "asset_name"
//        case allocation
//    }
//}
