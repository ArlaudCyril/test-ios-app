//
//  AddStrategyVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/07/22.
//

import Foundation
class AddStrategyVM{
    func addStrategyApi(strategy:Strategy,completion: @escaping ( (SuccessAPI?) -> Void )){
        var bundle = [[String : Any]]()
        var assetData : [String : Any] = [:]
        var params : [String : Any] = [:]
        
        for i in 0...(strategy.bundle.count - 1){
            assetData[Constants.ApiKeys.asset] = strategy.bundle[i].asset
            assetData[Constants.ApiKeys.share] = strategy.bundle[i].share
            bundle.append(assetData)
        }
        params = [Constants.ApiKeys.strategy_name : strategy.name ?? "",
                  Constants.ApiKeys.bundle : bundle]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func tailorStrategyApi(newStrategy:Strategy,completion: @escaping ( (SuccessAPI?) -> Void )){
        var bundle = [[String : Any]]()
        var assetData : [String : Any] = [:]
        var params : [String : Any] = [:]
        
        for i in 0...(newStrategy.bundle.count - 1){
            assetData[Constants.ApiKeys.asset] = newStrategy.bundle[i].asset
            assetData[Constants.ApiKeys.share] = newStrategy.bundle[i].share
            bundle.append(assetData)
        }
        params = [Constants.ApiKeys.strategy_name : newStrategy.name ?? "",
                  Constants.ApiKeys.bundle : bundle]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
}
