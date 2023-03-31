//
//  CryptoAddressBookVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation
class CryptoAddressBookVM{
    func getWhiteListingAddressApi(searchText : String?,completion: @escaping ( (WhitelistingAddressesAPI?) -> Void )){
        var params : [String: Any] = [:]
        if searchText != ""{
            params[Constants.ApiKeys.keyword] = searchText
        }
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistedAddresses, withParameters: params, ofType: WhitelistingAddressesAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
