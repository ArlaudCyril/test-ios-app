//
//  GoogleAuthenticatorVM.swift
//  Lyber
//
//  Created by Lyber on 08/03/2023.
//

import Foundation

class GoogleAuthenticatorVM{
    func getGoogleOTPUrlApi(completion: @escaping ( (UrlAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceGoogleOtp, withParameters: [:], ofType: UrlAPI.self, onSuccess: { response in
            print(response)
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getGoogleOTPUrlApi",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}

