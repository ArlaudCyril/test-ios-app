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
    case activateStrategy
    case deposit
    case Exchange
    case withdraw
    case withdrawEuro
    case anotherWallet
    case sell
    case editActiveStrategy
}

struct exchangeFromModel{
    var exchangeFromCoin : String
    var exchangeFromCoinImg : UIImage
    var exchangeToCoin : String
    var exchangeToCoinImg : UIImage
}
