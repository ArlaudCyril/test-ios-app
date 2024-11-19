//
//  GoogleAuthenticatorVerificationVM.swift
//  Lyber
//
//  Created by Lyber on 15/03/2023.
//

import Foundation

class VerificationVM{
    func TwoFAApi(type2FA: String?,otp: String, googleOtp: String? = "", controller: ViewController, completion: @escaping ( (SuccessAPI?) -> Void )){
        
		var params : [String : Any] = [Constants.ApiKeys.type2FA : type2FA ?? "",
									   Constants.ApiKeys.otp: otp]
        
		if(!(googleOtp?.isEmpty ?? false)){
			params[Constants.ApiKeys.googleOtp] = googleOtp
		}
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "TwoFAApi",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
    
    func verify2FAApi(code:String?, controller: ViewController, completion: @escaping ( (LogInAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.code : code ?? ""]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceVerify2FA, withParameters: params, ofType: LogInAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "verify2FAApi",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
	
    func walletCreateWithdrawalRequest(action : String?, otp: String? = "", data: [String : Any] , controller: ViewController, previousController: ViewController = ViewController(), minimumWithdraw: String, onSuccess: @escaping ( (SuccessAPI?) -> Void ),onFailure: @escaping((FailureAPI?) -> Void) = {_ in }){
        var params : [String : Any] = [:]
        var url = ""
        if(action == "withdraw"){
            params =  [Constants.ApiKeys.asset : data["asset"] ?? "",
            Constants.ApiKeys.amount : data["amount"] ?? "",
            Constants.ApiKeys.destination : data["destination"] ?? "",
            Constants.ApiKeys.network : data["network"] ?? ""]
            
            url = Constants.ApiUrlKeys.walletServiceWithdraw
        }else{
            params =  [Constants.ApiKeys.ribId : data["ribId"] ?? "",
            Constants.ApiKeys.iban : data["iban"] ?? "",
            Constants.ApiKeys.bic : data["bic"] ?? "",
            Constants.ApiKeys.amount : data["amount"] ?? ""]
            
            url = Constants.ApiUrlKeys.walletServiceWithdrawEuro
        }
        
		if(otp != ""){
			params[Constants.ApiKeys.otp] = otp ?? ""
		}
		
        ApiHandler.callApiWithParameters(url: url, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            onSuccess(response)
		}, onFailure: { reload, error, code  in
			let failure = FailureAPI(message: error, code: code)
            CommonFunctions.handleErrors(caller: "walletCreateWithdrawalRequest",code: code, error: error, controller: controller, previousController: previousController, arguments: ["asset": data["asset"] as? String ?? "usdc", "network": data["network"] as? String ?? "", "minimumWithdraw": minimumWithdraw])
			onFailure(failure)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user", integrity: true)
    }
    
    func userCloseAccountRequest(otp: String, onSuccess: @escaping ( (SuccessAPI?) -> Void ),onFailure: @escaping((FailureAPI?) -> Void) = {_ in }){
        var params : [String : Any] = [Constants.ApiKeys.otp : otp]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userCloseAccount, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            onSuccess(response)
        }, onFailure: { reload, error, code  in
            let failure = FailureAPI(message: error, code: code)
            CommonFunctions.handleErrors(caller: "userCloseAccountRequest", code: code, error: error)
            onFailure(failure)
        }, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user", integrity: true)
        
    }
	
    func verifyPasswordChangeAPI(code: String, controller: ViewController, onSuccess: @escaping ( (SuccessAPI?) -> Void ),onFailure: @escaping((FailureAPI?) -> Void) = {_ in }){
		let params : [String : Any] = [Constants.ApiKeys.code : code]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyPasswordChange, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            onSuccess(response)
        }, onFailure: { reload, error, code  in
            let failure = FailureAPI(message: error, code: code)
            CommonFunctions.handleErrors(caller: "verifyPasswordChangeAPI", code: code, error: error, controller: controller)
            onFailure(failure)
        }, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
        
    }
}
