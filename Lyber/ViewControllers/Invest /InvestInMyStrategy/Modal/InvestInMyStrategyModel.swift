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
    case ownStrategy
    case deposit
    case Exchange
    case withdraw
    case withdrawEuro
    case anotherWallet
    case sell
}

struct exchangeFromModel{
    var exchangeFromCoin : String
    var exchangeFromCoinImg : UIImage
    var exchangeToCoin : String
    var exchangeToCoinImg : UIImage
}
