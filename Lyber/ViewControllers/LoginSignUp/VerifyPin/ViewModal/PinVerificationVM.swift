//
//  PinVerificationVM.swift
//  Lyber
//
//  Created by sonam's Mac on 09/11/22.
//

import Foundation
class PinVerificationVM{
    func refreshTokenApi(completion: @escaping ( (LogInAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.method: "refresh_token",
                                    Constants.ApiKeys.refresh_token: userData.shared.refreshToken ]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userLogin, withParameters: param, ofType: LogInAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: false)
    }
}
