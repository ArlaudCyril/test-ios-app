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
struct PriceServiceResumeAPI: Codable {
	let data: [String:PriceServiceResumeData]
}

// MARK: - PriceServiceResumeData
struct PriceServiceResumeData: Codable {
	let lastPrice, change, squiggleURL : String?
	var isAuto : Bool?
	let rank: Int
	
	init(lastPrice: String?, change: String?, squiggleURL: String?, isAuto: Bool? = nil, rank: Int) {
		self.lastPrice = lastPrice
		self.change = change
		self.squiggleURL = squiggleURL
		self.isAuto = isAuto
		self.rank = rank
	}
	init() {
		self.lastPrice = ""
		self.change = ""
		self.squiggleURL = ""
		self.isAuto = false
		self.rank = 0
	}
}

// MARK: - PriceServiceResume
struct PriceServiceResume{
    var id : String
	var priceServiceResumeData : PriceServiceResumeData
	
	init(id: String, priceServiceResumeData: PriceServiceResumeData) {
		self.id = id
		self.priceServiceResumeData = priceServiceResumeData
	}
	init() {
		self.id = ""
		self.priceServiceResumeData = PriceServiceResumeData()
	}
}


// MARK: - AssetBaseAPI
struct AssetBaseAPI: Codable {
    let data: [AssetBaseData]?
}

// MARK: - AssetBaseData
struct AssetBaseData: Codable {
    let id, fullName: String?
    let image: String?
	let nativeNetwork : String?
    let isStablecoin: Bool?
    let isUIActive, isTradeActive, isDepositActive, isWithdrawalActive: Bool?
	
	init() {
		self.id = ""
		self.fullName = ""
		self.image = ""
		self.isStablecoin = false
		self.isUIActive = false
		self.isTradeActive = false
		self.isDepositActive = false
		self.isWithdrawalActive = false
		self.nativeNetwork = ""
	}
}


// MARK: - BalanceAPI
struct BalanceAPI: Codable {
	let data : [String:BalanceData]
}

// MARK: - BalanceData
struct BalanceData: Codable{
	let balance: String
	let euroBalance: String
	
	init(balance: String, euroBalance: String) {
		self.balance = balance
		self.euroBalance = euroBalance
	}
	
	init(){
		self.balance = "0"
		self.euroBalance = "0"
	}
}

// MARK: - Balance
struct Balance{
	var id: String
	var balanceData: BalanceData
	
	init(id: String, balanceData: BalanceData) {
		self.id = id
		self.balanceData = balanceData
	}
	
	init(){
		self.id = ""
		self.balanceData = BalanceData()
	}
}

// MARK: - BalanceHistoryAPI
struct BalanceHistoryAPI: Codable {
	let data : [BalanceHistory]
}

// MARK: - BalanceHistory
struct BalanceHistory: Codable{
	var total: String
	var date: String
	
	init(){
		self.total = ""
		self.date = ""
	}
}
