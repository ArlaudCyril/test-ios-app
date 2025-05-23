//
//  EnableWhitelistingVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//"withdrawalLock": "3d"

import Foundation

class EnableWhitelistingVM{
    func changeWhitelistingSecurityApi(withdrawalLock : String, controller: ViewController, completion: @escaping ( (SuccessAPI?) -> Void )){
        
        let params : [String : Any] = [Constants.ApiKeys.withdrawalLock : withdrawalLock]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "changeWhitelistingSecurityApi",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user")
    }
}
