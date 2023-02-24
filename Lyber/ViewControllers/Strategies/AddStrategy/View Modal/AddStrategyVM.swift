//
//  AddStrategyVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/07/22.
//

import Foundation
class AddStrategyVM{
    func addStrategyApi(strategyName:String,assets : [AllAssetsData?],allocation : [Int],completion: @escaping ( (SuccessAPI?) -> Void )){
        var bundle = [[String : Any]]()
        var assetData : [String : Any] = [:]
        var params : [String : Any] = [:]
        
        for i in 0...(assets.count - 1){
            assetData[Constants.ApiKeys.asset] = assets[i]?.id
            assetData[Constants.ApiKeys.share] = allocation[i]
            bundle.append(assetData)
            
            params = [Constants.ApiKeys.strategy_name : strategyName,
                      Constants.ApiKeys.bundle : bundle]
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
