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

struct StrategyActive: Codable{
    var amount : Int?
    var frequency : String?
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
              
    init() {
        self.name = ""
        self.expectedYield = ""
        self.bundle = []
        self.risk = ""
        self.activeStrategy = nil
        self.isOwnStrategy = nil
        self.ownerUuid = ""
    }
    /*let id, status, risk: String?
    let yield: Int?
    let createdAt: String?
    let updatedAt: String?
    let v: Int?
    let investmentStrategyAssets: [InvestmentStrategyAsset]?
    let investmentStrategyID: String?
    let isOwnStrategy, isChosen: Int?
    let userID: String?
    

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status, risk, yield
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
        case investmentStrategyAssets = "investment_strategy_assets"
        case investmentStrategyID = "investment_strategy_id"
        case isOwnStrategy = "is_own_strategy"
        case isChosen = "is_chosen"
        case userID = "user_id"
        case isSelected = "isSelected"
    }*/
}

// MARK: - InvestmentStrategyAsset
struct InvestmentStrategyAsset: Codable {
    
    let asset: String
    let assetID: String? //assetID : to define, asset : id : name
    let share: Int
   
    /*let id, assetID: String?
    let allocation: Int?
    let createdAt: String?
    let updatedAt: String?
    let investmentStrategyID: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case assetID = "asset_id"
        case allocation
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case investmentStrategyID = "investment_strategy_id"
        case v = "__v"
    }*/
}
