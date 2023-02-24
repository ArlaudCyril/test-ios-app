//
//  StrongAuthVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation
class StrongAuthVM{
    func strongAuthApi(enable : Bool,completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.enable : enable]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userEnableStrongAuth, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
