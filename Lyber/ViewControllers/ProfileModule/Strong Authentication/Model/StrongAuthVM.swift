//
//  StrongAuthVM.swift
//  Lyber
//
//  Created by Lyber on 17/03/2023.
//

import Foundation

class StrongAuthVM{
	func scope2FAApi(scopes : [String], otp: String = "", completion: @escaping ( (SuccessAPI?) -> Void ), onFailure: @escaping ( (FailureAPI?) -> Void )){
		
		var params : [String : Any] = [Constants.ApiKeys.scope2FA : scopes]
		
		if(otp != ""){
			params[Constants.ApiKeys.otp] = otp
		}
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}

