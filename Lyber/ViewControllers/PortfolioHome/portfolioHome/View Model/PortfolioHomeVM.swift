//
//  PortfolioHomeVM.swift
//  Lyber
//
//  Created by sonam's Mac on 25/07/22.
//

import Foundation
class PortfolioHomeVM{
//    var controller : AllAssetsVC?
    func getMyAssetsApi(completion: @escaping ( (MyAssetsAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userAssets, withParameters: [:], ofType: MyAssetsAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getRecurringInvestmentApi(completion: @escaping ( (RecurringInvestmentAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestments, withParameters: [:], ofType: RecurringInvestmentAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAllAvailableAssetsApi(order : String,completion: @escaping ( (TrendingCoinsAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.order : order,
                                       Constants.ApiKeys.page : 1,
                                       Constants.ApiKeys.limit : 6]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.coingeckoCoins, withParameters: params, ofType: TrendingCoinsAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
}
