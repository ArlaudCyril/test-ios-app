//
//  InvestmentStrategyModel.swift
//  Lyber
//
//  Created by sonam's Mac on 08/06/22.
//

import Foundation
import UIKit
struct DifferentCoinsModel{
    var coinColor : UIColor
    var coinName : String
    var percentage : String
    
}

struct strategyTypeModel{
    var name : String
    var isSelected : Bool
    var index : Int
}

// MARK: - InvestmentStrategiesAPI
struct InvestmentStrategiesAPI: Codable {
    let data: [Strategy]?
}

// MARK: - StrategyAPI
struct StrategyAPI: Codable {
    let data: Strategy?
}

// MARK: - Strategy
struct Strategy: Codable {
    
    let name, ownerUuid: String? //name, ID of the owner of the strategy
    let bundle: [InvestmentStrategyAsset]
    var isSelected : Bool? = false
    let isOwnStrategy : Int? // to define logically with ownerUuid
    var activeStrategy : StrategyActive?
    let risk : String?
    let expectedYield : String?
    let publicType : String?
              
    init() {
        self.name = ""
        self.expectedYield = ""
        self.bundle = []
        self.risk = ""
        self.activeStrategy = nil
        self.isOwnStrategy = nil
        self.ownerUuid = ""
        self.publicType = nil
    }
    init(name: String, bundle: [InvestmentStrategyAsset])
    {
        self.name = name
        self.expectedYield = ""
        self.bundle = bundle
        self.risk = ""
        self.activeStrategy = nil
        self.isOwnStrategy = nil
        self.ownerUuid = ""
        self.publicType = nil
    }
    
    init(name: String, bundle: [InvestmentStrategyAsset], strategy: Strategy) {
        self.name = name
        self.expectedYield = ""
        self.bundle = bundle
        self.risk = ""
        self.activeStrategy = strategy.activeStrategy
        self.isOwnStrategy = strategy.isOwnStrategy
        self.ownerUuid = strategy.ownerUuid
        self.publicType = nil
    }
  
}

// MARK: - InvestmentStrategyAsset
struct InvestmentStrategyAsset: Codable {
    let asset: String //asset : id : name
    let assetID: String? //assetID : to define,
    let share: Int
    
    init(asset: String, share: Int) {
        self.asset = asset
        self.share = share
        self.assetID = ""
    }
}

struct StrategyActive: Codable{
    var amount : Int?
    var frequency : String?
}
