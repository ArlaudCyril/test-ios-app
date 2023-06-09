//
//  AddressAddedPopUpVM.swift
//  Lyber
//
//  Created by sonam's Mac on 23/08/22.
//

import Foundation
class AddressAddedPopUpVM{
    
    func getAddressDetailApi(addressId: String,completion: @escaping ( (Address?) -> Void )){
        let param : [String: Any] = [Constants.ApiKeys.id : addressId]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: Address.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
//            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func deleteAddressApi(addressId: String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let param : [String: Any] = [Constants.ApiKeys.address_id : addressId]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
//            completion(nil)
            CommonFunctions.toster(error)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    
    
}
