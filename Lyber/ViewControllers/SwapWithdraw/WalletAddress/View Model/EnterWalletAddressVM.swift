//
//  EnterWalletAddressVM.swift
//  Lyber
//
//  Created by sonam's Mac on 20/07/22.
//

import Foundation
class EnterWalletAddressVM{
    func withdrawApi(assetId : String ,amount : Double,assetAmount : Double,walletAddress: String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.asset_id : assetId,
                                       Constants.ApiKeys.amount : amount,
                                       Constants.ApiKeys.asset_amount : assetAmount,
                                       Constants.ApiKeys.wallet_address : walletAddress]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWithdrawCrypto, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func withdrawFiatApi(amount : Double,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.amount : amount]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.treezorWithdrawFiat, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerType: "user")
    }
}
