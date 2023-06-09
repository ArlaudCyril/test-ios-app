//
//  AddCryptoAddressVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/08/22.
//

import Foundation
class AddCryptoAddressVM{
    func getNetworksDataApi(completion: @escaping ( (NetworkAPI?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userNetworks, withParameters: [:], ofType: NetworkAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func getExchangeApi(completion: @escaping ( (ExchangeAPI?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.aploVenues, withParameters: [:], ofType: ExchangeAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func editWhiteListingAddressApi(cryptoAddress : Address?,completion: @escaping ( (SuccessAPI?) -> Void )){
        let param : [String : Any] = [Constants.ApiKeys.name : cryptoAddress?.name ?? "",
                                      Constants.ApiKeys.asset : cryptoAddress?.asset ?? "",
                                      Constants.ApiKeys.address : cryptoAddress?.address ?? "",
                                      Constants.ApiKeys.origin : cryptoAddress?.origin ?? "",
                                      Constants.ApiKeys.exchange : cryptoAddress?.exchange ?? ""]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userWhitelistAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PUTWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
}
