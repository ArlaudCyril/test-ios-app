//
//  PortfolioDetailModel.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import Foundation

struct graphStruct{
    var index : Int
    var date: String
    var euro : Double
}
enum chartType : String{
    case oneHour = "1h"
    case fourHour = "4h"
    case oneDay = "1d"
    case oneWeek = "1w"
    case oneMonth = "1m"
    case All = "max"
    case oneYear = "1y"
}


struct InfoModel{
    var name : String
    var value : String
}

// MARK: - GetAssetsAPiElement
struct GetAssetsAPIElement: Codable {
    let assetID, assetName, symbol, id, image: String?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case assetName = "asset_name"
        case symbol
        case id = "_id"
        case image = "image"
    }
}

//// MARK: - ChartDataAPi
//struct ChartDataAPi: Codable {
//    let stats: [[Double]]?
//    let totalVolumes: [[Double]]?
//
//    enum CodingKeys: String, CodingKey {
//        case stats
//        case totalVolumes = "total_volumes"
//    }
//}
// MARK: - ChartAPI
struct ChartAPI: Codable {
    let data: chartData?
}

// MARK: - DataClass
struct chartData: Codable {
    let lastUpdate: String?
    let prices: [String]?
}



// MARK: - NewsDATAAPI
struct NewsDataAPI: Codable {
    let data: [newsData]?
}

// MARK: - Datum
struct newsData: Codable {
    let title: String?
    let url: String?
    let image_url: String?
    let date: String?
}

// MARK: - PortfolioDetailAPI
struct PortfolioDetailAPI: Codable {
    let data: PortfolioDetailData?
}

// MARK: - DataClass
struct PortfolioDetailData: Codable {
    let circulatingSupply: String
    let isUIActive, isDepositActive, isWithdrawalActive: Bool?
    let volume24H: String?
    let isTradeActive: Bool?
    let fullName: String?
    let marketRank: Int?
    let about: About?
    let image: String?
    let marketCap: String?

    enum CodingKeys: String, CodingKey {
        case circulatingSupply, isUIActive, isDepositActive, isWithdrawalActive
        case volume24H = "volume24h"
        case isTradeActive, fullName, marketRank, about, image, marketCap
    }
}

// MARK: - About
struct About: Codable {
    let fr, en: String
}
