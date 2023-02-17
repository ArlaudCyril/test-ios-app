//
//  AddStrategyVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/07/22.
//

import Foundation
class AddStrategyVM{
    func addStrategyApi(strategyName:String,assets : [AllAssetsData?],allocation : [Int],completion: @escaping ( (SuccessAPI?) -> Void )){
        var array = [[String : Any]]()
        var assetData : [String : Any] = [:]
        var params : [String : Any] = [:]
        
        for i in 0...(assets.count - 1){
            assetData[Constants.ApiKeys.asset_id] = assets[i]?.id
            assetData[Constants.ApiKeys.allocation] = allocation[i]
            array.append(assetData)
            
            params = [Constants.ApiKeys.is_own_strategy : 1,
                      Constants.ApiKeys.strategy_name : strategyName,
                      Constants.ApiKeys.assets : array]
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestmentStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunction.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
