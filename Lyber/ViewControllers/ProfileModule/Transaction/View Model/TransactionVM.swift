//
//  TransactionVM.swift
//  Lyber
//
//  Created by sonam's Mac on 21/07/22.
//

import Foundation
class TransactionVM{
    func getAllTransactionsApi(completion: @escaping ( (TransactionsAPI?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userTransactions, withParameters: [:], ofType: TransactionsAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
