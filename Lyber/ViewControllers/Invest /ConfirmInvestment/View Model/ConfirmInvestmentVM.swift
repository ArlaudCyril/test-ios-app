//
//  ConfirmInvestmentVM.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import Foundation

class ConfirmInvestmentVM{
    func InvestOnAssetApi(assetId : String ,assetName : String,amount : Double,assetAmount : Double,frequency: String,completion: @escaping ( (SuccessAPI?) -> Void )){
        
        var params : [String : Any] = [:]
        params[Constants.ApiKeys.asset_id] = assetId
        params[Constants.ApiKeys.asset_name] = assetName
        params[Constants.ApiKeys.amount] = amount
        params[Constants.ApiKeys.asset_amount] = assetAmount
        if frequency != ""{
            params[Constants.ApiKeys.frequency] = frequency.uppercased()
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.investOnAsset, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func activateStrategyApi(strategyName : String ,amount : Double,frequency: String, ownerUuid: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.strategy_name : strategyName,
                                       Constants.ApiKeys.amount : amount,
                                       Constants.ApiKeys.frequency : CommonFunctions.frequenceEncoder(frequence: frequency),
                                       Constants.ApiKeys.owner_uuid : ownerUuid]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func editActiveStrategyApi(strategyName : String ,amount : Double,frequency: String, ownerUuid: String, completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.strategy_name : strategyName,
                                       Constants.ApiKeys.amount : amount,
                                       Constants.ApiKeys.frequency : CommonFunctions.frequenceEncoder(frequence: frequency),
                                       Constants.ApiKeys.owner_uuid : ownerUuid]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.strategyServiceActiveStrategy, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func exchangeCryptoApi(exchangeFrom : String ,exchangeTo : String,exchangeFromAmount : Double,exchangeToAmount: Double,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.exchange_from : exchangeFrom,
                                       Constants.ApiKeys.exchange_to : exchangeTo,
                                       Constants.ApiKeys.exchange_from_amount : String(exchangeFromAmount),
                                       Constants.ApiKeys.exchange_to_amount : String(exchangeToAmount)]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSwapCrypto, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func SellApi(assetId: String,amount : Double,assetAmount : Double,completion: @escaping ( (SuccessAPI?) -> Void )){
        var params : [String : Any] = [:]
        params[Constants.ApiKeys.asset_id] = assetId
        params[Constants.ApiKeys.amount] = "\(amount)"
        params[Constants.ApiKeys.asset_amount] = assetAmount
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSellCrypto, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}

