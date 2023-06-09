//
//  GoogleAuthenticatorVerificationVM.swift
//  Lyber
//
//  Created by Lyber on 15/03/2023.
//

import Foundation

class VerificationVM{
    func TwoFAOtpApi(code:String?, type2FA: String?, completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.type2FA : type2FA ?? "",Constants.ApiKeys.googleOTP : code ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userService2FA, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func TwoFAApi(type2FA: String?, completion: @escaping ( (SuccessAPI?) -> Void )){
        
		let params : [String : Any] = [Constants.ApiKeys.type2FA : type2FA ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userService2FA, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func verify2FAApi(code:String?, completion: @escaping ( (LogInAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.code : code ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceVerify2FA, withParameters: params, ofType: LogInAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
	
	func walletCreateWithdrawalRequest(otp: String?, data: [String : Any] ,onSuccess: @escaping ( (SuccessAPI?) -> Void ),onFailure: @escaping((FailureAPI?) -> Void) = {_ in }){
        let params : [String : Any] = [Constants.ApiKeys.otp : otp ?? "",
									   Constants.ApiKeys.asset : data["assetId"] ?? "",
									   Constants.ApiKeys.amount : data["amount"] ?? "",
									   Constants.ApiKeys.destination : data["destination"] ?? "",
									   Constants.ApiKeys.chain : data["chain"] ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdraw, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            print(response)
            onSuccess(response)
		}, onFailure: { reload, error, code  in
			let failure = FailureAPI(message: error, code: code)
			onFailure(failure)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
