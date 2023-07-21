//
//  InvestmentModel.swift
//  Lyber
//
//  Created by Lyber on 21/07/2023.
//

import Foundation

//MARK: ExecutionOneInvestmentAPI
struct ExecutionOneInvestmentAPI : Codable{
	var data : ExecutionOneInvestment
}

//MARK: ExecutionOneInvestment
struct ExecutionOneInvestment : Codable {
	var id : String
}

//MARK: OneInvestmentAPI
struct OneInvestmentAPI : Codable {
	let data: OneInvestment
}

//MARK: OneInvestment
struct OneInvestment : Codable {
	let totalStableAmountSpent: String?
	let totalFeeSpent: String?
	let successfulBundleEntries: [BundleOneInvestment]?
	let failedBundleEntries: [BundleOneInvestment]?
	let status: String
}
	
//MARK: BundleOneInvestment
struct BundleOneInvestment : Codable {
	let asset : String
	let share: Int
	let stableAmount: String?
	let assetAmount: String?
}

