//
//  BalanceTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 29/07/22.
//

import Foundation

class BalanceVM{
    func getTransactionsApi(assetID : String,completion: @escaping ( (TransactionsAPI?) -> Void )){
        let params : [String :Any] = [Constants.ApiKeys.asset_id : assetID]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceTransactions, withParameters: params, ofType: TransactionsAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getTransactionsApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}
