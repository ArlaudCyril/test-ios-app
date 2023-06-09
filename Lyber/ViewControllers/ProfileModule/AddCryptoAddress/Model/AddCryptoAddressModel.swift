//
//  AddCryptoAddressModel.swift
//  Lyber
//
//  Created by sonam's Mac on 06/08/22.
//

import Foundation

// MARK: - NetworkAPI
struct NetworkAPI: Codable {
    let networks: [Networks]
}

// MARK: - Network
struct Networks: Codable {
    let assetID, name: String?
    let logo: String?
    let isDeleted: Bool?
    let createdAt: Int?
    let id: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case name, logo
        case isDeleted = "is_deleted"
        case createdAt
        case id = "_id"
        case v = "__v"
    }
}


// MARK: - ExchangeAPI
struct ExchangeAPI: Codable {
    let assets: [exchangeAsset]
}

// MARK: - Asset
struct exchangeAsset: Codable {
    let vid: Int?
    let date, name, code: String?
}


enum network{
    case FIAT
    case ETH
    case BTC
    case ETC
    case ADA
    case XLM
    case TRX
    case NEO
    case EOS
    case DASH
    case LTC
    case XRP
    case BCH
    case XTZ
    case DOT
    case HNT
    case LUNA
    case NEM
    case FIL
    case ALGO
    case AVAX
    case KSM
    case DOGE
    case BSC
    case WAVES
    case SOL
    case ATOM
    case NEAR
    case SEN
    
}
