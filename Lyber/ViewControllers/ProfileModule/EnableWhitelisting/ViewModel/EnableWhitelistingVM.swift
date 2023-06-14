//
//  EnableWhitelistingVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//"withdrawalLock": "3d"

import Foundation

class EnableWhitelistingVM{
    func changeWhitelistingSecurityApi(withdrawalLock : String, completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.withdrawalLock : withdrawalLock]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PATCHWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
