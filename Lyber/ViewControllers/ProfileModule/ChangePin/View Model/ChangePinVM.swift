//
//  ChangePinVM.swift
//  Lyber
//
//  Created by sonam's Mac on 22/07/22.
//

import Foundation
class ChangePinVM{
    func sendOtpApi(completion: @escaping ( (SuccessAPI?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userPinOtp, withParameters: [:], ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func enterOtpApi(otp : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params: [String : Any] = [Constants.ApiKeys.otp : otp]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userPinVerifyPhone, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func setNewPinApi(Pin : String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params: [String : Any] = [Constants.ApiKeys.newPin : Pin]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userPin, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PUT, img: nil, imageParamater: nil, headerPresent: true)
    }
}
