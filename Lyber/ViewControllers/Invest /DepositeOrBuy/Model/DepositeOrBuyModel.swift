//
//  DepositeOrBuyModel.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import Foundation
import UIKit

struct buyDepositeModel {
    var icon : UIImage
    var svgUrl : String?
    var iconBackgroundColor : UIColor
    var name : String
    var subName : String
    var rightBtnName : String
    var ribData : RibData?
}

enum bottomPopUp{
    case DepositeBuy
    case PayWith
    case withdrawExchange
    case withdrawTo
    case withdrawToEuro
    case withdrawAll
    case InvestInStrategiesOrAsset
    case investWithStrategiesActive
    case investWithStrategiesInactive
//    case withdrawDepositBuySellExchange
    case AssetDetailPagePopUp
}

enum confirmationPopUp{
    case Buy
    case Sell
    case Withdraw
    case WithdrawEuro
    case Tailoring
    case LinkSent
    case exportSuccess
	case exportFailure
    case buyFailure
	case Congratulations
}
