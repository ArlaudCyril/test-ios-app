//
//  ApiVM.swift
//  Lyber
//
//  Created by Elie Boyrivent on 03/10/2024.
//

import Foundation

class ApiVM{
    func getIntegrityAPI(requestHash: String, keyId: String, completion: @escaping ( (DataAPI?) -> Void )){
        let params = [Constants.ApiKeys.requestHash : requestHash, Constants.ApiKeys.keyId : keyId]

        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceIntegrity, withParameters: params, ofType: DataAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "getIntegrityAPI",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "none")
    }
}
