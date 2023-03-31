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
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}

