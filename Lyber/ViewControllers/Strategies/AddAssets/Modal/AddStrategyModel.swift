//
//  AddStrategyModel.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import Foundation
import UIKit
/*struct coinsModel{
    var icon : UIImage
    var coinFullName : String
    var coin : String
    var euro : String
    var percentage : String
    var autoPercentage : String
    var chartColor : UIColor
}*/

struct coinsModel{
    var id : String
    var lastPrice : String
    var change : String
}


//// MARK: - TrendingCoinsAPI
//struct TrendingCoinsAPI: Codable {
//    let count: Int?
//    let trending: [Trending]?
//}
//
//// MARK: - Trending
//struct Trending: Codable {
//    let name, currency, price, priceChange: String?
//    let logoURL: String?
//    let status: String?
//    var autoPercentage : String? = "100%"
//
//    enum CodingKeys: String, CodingKey {
//        case name, currency, price
//        case priceChange = "price_change"
//        case logoURL = "logo_url"
//        case status
//    }
//}

// MARK: - TrendingCoinsAPI
struct TrendingCoinsAPI: Codable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: [Trending]?
}

// MARK: - Datum
struct Trending: Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let roi: Roi?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let total_balance: Double?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case total_balance
        case description
    }
}
// MARK: - Roi
struct Roi: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}
