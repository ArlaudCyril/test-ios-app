//
//  TransactionModel.swift
//  Lyber
//
//  Created by sonam's Mac on 21/07/22.
//

import Foundation

// MARK: - TransactionsAPI
struct TransactionsAPI: Codable {
    let data: [Transaction]?
}
// MARK: - Transaction
struct Transaction: Codable {
    let id: String?
    let type: String?
    let date: String?
	//withdraw and deposit
    let amount: String?
	//order
	let fromAsset: String?
	let fromAmount: String?
	let toAsset: String?
	let toAmount: String?
	let fees: String?
	//order and deposit and strategy
	let status: String?
	//deposit
	let asset: String?
	let fromAddress: String?
	let network: String?
	let txId: String?
	
	//withdraw
	let toAddress: String?
	
    //withdrawEuro
    let iban: String?
    let eurAmount: Double?
    let eurAmountDeductedLyberFees: Double?
    
	//strategy
	let nextExecution: String?
	let totalStableAmountSpent: String?
    let totalEurAmountSpent: String?
	let strategyName: String?
    let strategyType: String?
    let totalFeeSpent: String?
    let totalRecreditedAmount: String?
    
	
}

/* it remains the type strategy
 {
 "type": "withdraw",
 "date": "2023-06-09T13:11:35.671Z",
 "amount": 0.02
 },
 {"type": "order",
 "status": "VALIDATED",
 "date": "2023-05-09T10:49:38.337Z",
 "fromAsset": "sol",
 "fromAmount": "0.14354764",
 "toAsset": "eth",
 "toAmount": "0.00160047"
 },
 {
 "type": "deposit",
 "asset": "sol",
 "date": "2023-05-05T15:18:48.000Z",
 "amount": 600000000000000,
 "status": "CREDITED"
 },*/
