//
//  AddressAddedPopUpVM.swift
//  Lyber
//
//  Created by sonam's Mac on 23/08/22.
//

import Foundation
class AddressAddedPopUpVM{
    
    func addWhiteListingAddressApi(cryptoAddress : cryptoAddressModel?,completion: @escaping ( (SuccessAPI?) -> Void )){
        var param : [String : Any] = [:]
//        let param : [String : Any] = [Constants.ApiKeys.name : cryptoAddress?.addressName ?? "",
//                                      Constants.ApiKeys.network : cryptoAddress?.network ?? "",
//                                      Constants.ApiKeys.address : cryptoAddress?.address ?? "",
//                                      Constants.ApiKeys.origin : cryptoAddress?.origin ?? "",
//                                      Constants.ApiKeys.exchange : cryptoAddress?.exchange ?? "",
//                                      Constants.ApiKeys.logo : cryptoAddress?.logo ?? ""]
        param[Constants.ApiKeys.name] = cryptoAddress?.addressName ?? ""
        param[Constants.ApiKeys.network] = cryptoAddress?.network ?? ""
        param[Constants.ApiKeys.address] = cryptoAddress?.address ?? ""
        param[Constants.ApiKeys.origin] = cryptoAddress?.origin ?? ""
        param[Constants.ApiKeys.logo] = cryptoAddress?.logo ?? ""
        if cryptoAddress?.exchange ?? "" != ""{
            param[Constants.ApiKeys.exchange] = cryptoAddress?.exchange ?? ""
            
        }
        
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunction.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func getAddressDetailApi(addressId: String,completion: @escaping ( (Address?) -> Void )){
        let param : [String: Any] = [Constants.ApiKeys.id : addressId]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: Address.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
//            completion(nil)
            CommonFunction.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func deleteAddressApi(addressId: String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let param : [String: Any] = [Constants.ApiKeys.address_id : addressId]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
//            completion(nil)
            CommonFunction.toster(error)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    
    
}
