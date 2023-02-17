//
//  StrongAuthVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation
class StrongAuthOTPVerifyVM{
    func verifyStrongAuthApi(otp : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.otp : otp]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyStrongAuth, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
