//
//  EnableWhitelistingVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation

class EnableWhitelistingVM{
    func enableWhitelistingApi(enable : Bool,Security : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.enable : enable,
                                       Constants.ApiKeys.extra_security : Security]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userEnableWhitelisting, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
