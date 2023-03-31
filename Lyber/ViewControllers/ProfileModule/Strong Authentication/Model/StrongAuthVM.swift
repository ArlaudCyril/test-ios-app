//
//  StrongAuthVM.swift
//  Lyber
//
//  Created by Lyber on 17/03/2023.
//

import Foundation

class StrongAuthVM{
    func scope2FAApi(params : [String : Any],completion: @escaping ( (SuccessAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceScope2FA, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}

