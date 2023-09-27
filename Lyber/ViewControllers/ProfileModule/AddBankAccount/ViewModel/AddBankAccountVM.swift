//
//  AddBankAccountVM.swift
//  Lyber
//
//  Created by sonam's Mac on 27/07/22.
//

import Foundation
class AddBankAccountVM{
    func addBankAccountApi(iban : String,bic : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.iban: iban,
                                       Constants.ApiKeys.bic : bic]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userBankInfo, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
            completion(nil)
        }, method: .POST, img: nil, imageParamater: nil, headerType: "user")
    }
}
