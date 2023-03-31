//
//  RecurringDetailVM.swift
//  Lyber
//
//  Created by sonam's Mac on 29/08/22.
//

import Foundation
class RecurringDetailVM{
    func getRecurringDetailApi(id : String,completion: @escaping ( (RecurringInvestmentDetailAPi?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.id : id]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestment, withParameters: params, ofType: RecurringInvestmentDetailAPi.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func deleteInvestmentApi(id : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.id : id]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestment, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
