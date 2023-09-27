//
//  TransactionVM.swift
//  Lyber
//
//  Created by sonam's Mac on 21/07/22.
//

import Foundation
class TransactionVM{
	func getTransactionsApi(limit:Int, offset: Int, completion: @escaping ( (TransactionsAPI?) -> Void )){
		let params : [String : Any] = [Constants.ApiKeys.limit : limit,
									   Constants.ApiKeys.offset : offset]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceTransactions, withParameters: params, ofType: TransactionsAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
