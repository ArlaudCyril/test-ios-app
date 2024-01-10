//
//  AddCryptoAddressModel.swift
//  Lyber
//
//  Created by sonam's Mac on 06/08/22.
//

import Foundation

// MARK: - NetworkAssetAPI
struct NetworkAssetAPI: Codable {
    let networks: [NetworkAsset]
}

// MARK: - NetworkAsset
struct NetworkAsset: Codable {
    let id: String
    let fullName: String?
    let addressRegex: String?
    let imageUrl: String?
    let isUIActive: Bool?
	let withdrawMin: Double?
	let withdrawFee: Double?
	let isDepositActive: Bool?
	let isWithdrawalActive: Bool?
    let decimals: Int?  
}


// MARK: - NetworkDataAPI
struct NetworkDataAPI: Codable {
    let data: [NetworkData]
}

// MARK: - NetworkDataAPI
struct NetworkDataByIdAPI: Codable {
    let data: NetworkData
}

// MARK: - NetworkAsset
struct NetworkData: Codable {
    let id: String
	let fullName: String?
	let imageUrl: String?
    let addressRegex: String?
	let depositStatus: Bool?
	let withdrawalStatus: Bool?
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
