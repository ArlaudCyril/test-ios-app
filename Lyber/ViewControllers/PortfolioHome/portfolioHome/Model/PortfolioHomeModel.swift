//
//  PortfolioHomeModel.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import Foundation
import UIKit

struct assetsModel{
    var coinImg : UIImage
    var coinName : String
    var euro : String
    var totalCoin : String
    var currency : String?
    var percentage : String?
}


// MARK: - MyAssetsAPI
struct MyAssetsAPI: Codable {
    let count: Int?
    let total_euros_available: Double?
    let assets: [Asset]?
}

// MARK: - Asset
struct Asset: Codable {
    let assetID, assetName,name: String?
    let tag: Int?
    var totalBalance: Double?
    let createdAt, updatedAt, id, userID: String?
    let v: Int?
    let euroAmount: Double?
    let coinDetail: Trending?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case assetName = "asset_name"
        case name = "name"
        case tag
        case totalBalance = "total_balance"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id = "_id"
        case userID = "user_id"
        case v = "__v"
        case euroAmount = "euro_amount"
        case coinDetail = "coin_detail"
    }
}


// MARK: - RecurringInvestmentAPI
struct RecurrentInvestmentStrategyAPI: Codable {
    let data: [RecurrentInvestmentStrategy]?
}

// MARK: - Investment
struct RecurrentInvestmentStrategy: Codable {
	let strategyName: String
	let amount: Int
	let frequency: String
	let nextExecution: String
	let strategyType: String
	let ownerUuid: String

}

// MARK: - UserInvestmentStrategyID
struct UserInvestmentStrategyID: Codable {
    let id: String?
    let isOwnStrategy: Int?
    let strategyName: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case isOwnStrategy = "is_own_strategy"
        case strategyName = "strategy_name"
    }
}

enum Frequency: String, Codable {
    case daily = "DAILY"
    case once = "ONCE"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
}

enum TypeEnum: String, Codable {
    case singular = "SINGULAR"
    case stratBased = "STRAT_BASED"
}

struct PerformanceAPI: Codable {
	let data: Performance
}

struct Performance: Codable {
    let totalGain: String?
    let roi: String?
}


enum VerificationIndicator: String {
    case notPerformed = "NOT_PERFORMED"
    case rejected = "REJECTED"
    case pending = "STRAT_BASED"
    case validated = "VALIDATED"
}

