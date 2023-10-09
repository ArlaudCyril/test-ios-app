//
//  InvestmentStrategyVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/07/22.
//
//InvestmentStrategiesAPI.self
import Foundation
class InvestmentStrategyVM{
    func getInvestmentStrategiesApi(completion: @escaping ( (InvestmentStrategiesAPI?) -> Void )){
       
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.investmentStrategies, withParameters:["type":"all"], ofType: InvestmentStrategiesAPI.self, onSuccess: { response in
            completion(response)
            print("success api correct")
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getInvestmentStrategiesApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func deleteStrategyApi(strategyName:String, completion: @escaping ( (SuccessAPI?) -> Void )){
        var params : [String : Any] = [:]
        
        params = [Constants.ApiKeys.strategy_name : strategyName]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "deleteStrategyApi",code: code, error: error)
            completion(nil)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func pauseStrategyApi(strategyName:String, ownerUuid:String, completion: @escaping ( (SuccessAPI?) -> Void )){
        var params : [String : Any] = [:]
        
        params = [Constants.ApiKeys.strategy_name : strategyName,
                  Constants.ApiKeys.owner_uuid : ownerUuid]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "pauseStrategyApi",code: code, error: error)
            completion(nil)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
