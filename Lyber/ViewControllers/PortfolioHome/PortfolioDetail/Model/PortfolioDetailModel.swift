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
struct AssetDetailApi: Codable {
    let data: AssetDetailData?
}

// MARK: - DataClass
struct AssetDetailData: Codable {
	let id: String
	let volume24h: String?
	let fullName: String?
	let imageUrl: String?
	let about: About?
	let marketCap: String?
    let circulatingSupply: String?
	let marketRank: Int?
	let defaultDepositNetwork: String?
	let defaultWithdrawalNetwork: String?
    let isUIActive, isDepositActive, isTradeActive, isWithdrawalActive: Bool?
    let isStablecoin: Bool?
	let networks: [NetworkAsset]?
    
    //TODO: delete this parameters
	let depositChains: [String]?
	let withdrawalChains : [String:WithdrawalChain]?

}



// MARK: - WithdrawalChain
struct WithdrawalChain : Codable{
	let withdrawFee: Double
	let withdrawMin: Double
	let lyberEnabled: Bool
	
	init() {
		self.withdrawFee = 0
		self.withdrawMin = 0
		self.lyberEnabled = false
		
	}
	init(withdrawalChain : WithdrawalChain) {
		self.withdrawFee = withdrawalChain.withdrawFee
		self.withdrawMin = withdrawalChain.withdrawMin
		self.lyberEnabled = withdrawalChain.lyberEnabled
	}
}

// MARK: - About
struct About: Codable {
    let fr, en: String
}

// MARK: - OrderAPI
struct OrderAPI: Codable {
	let data: Order
}

// MARK: - Order
struct Order: Codable {
	let orderId: String
	let quoteId: String?
	let fromAsset: String
	let fromAmount: String
	let toAsset: String
	let toAmount: String
	let orderStatus: String?
}

