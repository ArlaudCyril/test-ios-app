//
//  PortfolioHomeVM.swift
//  Lyber
//
//  Created by sonam's Mac on 2/07/22.
//

import Foundation
class PortfolioHomeVM{
//    var controller : AllAssetsVC?
    func getMyAssetsApi(completion: @escaping ( (MyAssetsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userAssets, withParameters: [:], ofType: MyAssetsAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getMyAssetsApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
    
   func getActiveStrategiesApi(completion: @escaping ( (RecurrentInvestmentStrategyAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: [:], ofType: RecurrentInvestmentStrategyAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getActiveStrategiesApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
    
	func callWalletGetBalanceApi(completion: @escaping ( ([Balance]?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceBalance, withParameters: [:], ofType: BalanceAPI.self, onSuccess: { response in
			print(response)
			
			let balanceDataDict : [String:BalanceData] = response.data
			var balances : [Balance] = []
			for (id, balanceData) in balanceDataDict{
				let balance = Balance(id: id, balanceData: balanceData)
				balances.append(balance)
			}
            
            completion(balances)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "callWalletGetBalanceApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
	
    func walletGetBalanceHistoryApi(limit: Int, daily: Bool, completion: @escaping ( (BalanceHistoryAPI?) -> Void )){
		
		let param : [String : Any] = [Constants.ApiKeys.limit : limit,
                                      Constants.ApiKeys.daily : daily]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceHistory, withParameters: param, ofType: BalanceHistoryAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "walletGetBalanceHistoryApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
	
	func walletGetPerformanceApi(completion: @escaping ( (PerformanceAPI?) -> Void )){
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServicePerformance, withParameters: [:], ofType: PerformanceAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "walletGetPerformanceApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}
