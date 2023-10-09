//
//  GoogleAuthenticatorVerificationVM.swift
//  Lyber
//
//  Created by Lyber on 15/03/2023.
//

import Foundation

class VerificationVM{
	func TwoFAApi(type2FA: String?,otp: String, googleOtp: String? = "", completion: @escaping ( (SuccessAPI?) -> Void )){
        
		var params : [String : Any] = [Constants.ApiKeys.type2FA : type2FA ?? "",
									   Constants.ApiKeys.otp: otp]
        
		if(!(googleOtp?.isEmpty ?? false)){
			params[Constants.ApiKeys.googleOtp] = googleOtp
		}
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "TwoFAApi",code: code, error: error)
            completion(nil)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func verify2FAApi(code:String?, completion: @escaping ( (LogInAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.code : code ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceVerify2FA, withParameters: params, ofType: LogInAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "verify2FAApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
	
	func walletCreateWithdrawalRequest(otp: String? = "", data: [String : Any] ,onSuccess: @escaping ( (SuccessAPI?) -> Void ),onFailure: @escaping((FailureAPI?) -> Void) = {_ in }){
        var params : [String : Any] = [Constants.ApiKeys.asset : data["asset"] ?? "",
									   Constants.ApiKeys.amount : data["amount"] ?? "",
									   Constants.ApiKeys.destination : data["destination"] ?? "",
									   Constants.ApiKeys.network : data["network"] ?? ""]
        
		if(otp != ""){
			params[Constants.ApiKeys.otp] = otp ?? ""
		}
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdraw, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            onSuccess(response)
		}, onFailure: { reload, error, code  in
			let failure = FailureAPI(message: error, code: code)
			CommonFunctions.handleErrors(caller: "walletCreateWithdrawalRequest",code: code, error: error)
			onFailure(failure)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
