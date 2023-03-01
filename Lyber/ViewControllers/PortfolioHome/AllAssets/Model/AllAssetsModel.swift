//
//  AllAssetsModel.swift
//  Lyber
//
//  Created by sonam's Mac on 21/06/22.
//

import Foundation
enum screenEnum{
    case portfolio
    case exchange
    case singleAssets
}


enum coinType : String{
    case Trending = "volume_desc"
    case TopGainers = "hour_24_desc"
    case TopLoosers = "hour_24_asc"
    case Stable = "stable_coins"
}

// MARK: - PriceServiceResumeAPI
struct priceServiceResumeAPI: Codable {
    let data: [priceServiceResume]
}

// MARK: - PriceServiceResume
struct priceServiceResume: Codable {
    let id : String
    let lastPrice, change, squiggleURL : String?
    var isAuto : Bool?
}


// MARK: - AssetDetailAPI
struct AssetBaseAPI: Codable {
    let data: [AssetBaseData]?
}

// MARK: - AssetDetailData
struct AssetBaseData: Codable {
    let id, fullName: String?
    let image: String?
    let isUIActive, isTradeActive, isDepositActive, isWithdrawalActive: Bool?
}
