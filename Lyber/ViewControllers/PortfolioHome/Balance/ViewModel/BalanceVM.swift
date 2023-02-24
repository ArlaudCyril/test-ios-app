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
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userTransactions, withParameters: params, ofType: TransactionsAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
}
