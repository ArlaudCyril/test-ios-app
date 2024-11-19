//
//  InvestInMyStrategyModel.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import Foundation
import UIKit
enum InvestStrategyModel{
    case singleCoin
    case singleCoinWithFrequence
    case activateStrategy
    case oneTimeInvestment
    case deposit
    case Exchange
    case Send
    case withdraw
    case withdrawEuro
    case anotherWallet
    case sell
    case editActiveStrategy
}

struct exchangeFromModel{
    var exchangeFromCoinId : String
    var exchangeFromCoinImg : String
	var exchangeFromCoinPrice : Double
    var exchangeFromCoinBalance : Balance
    var exchangeToCoinId : String
    var exchangeToCoinPrice : Double
    var exchangeToCoinImg : String
}

struct QuoteAPI: Codable{
	var data: Quote
}

struct Quote: Codable{
	var toAmount: String
	var fromAmount: String
	var fromAmountDeductedFees: String
	var validTimestamp: Int
	var fromAsset: String
	var toAsset: String
	var ratio: String
	var orderId: String
	var fees: String
    var clientSecret: String?
	var paymentIntentId: String?
}

struct LastPriceAPI: Codable{
    var data: LastPrice
}

struct LastPrice: Codable{
    var price: String
}
