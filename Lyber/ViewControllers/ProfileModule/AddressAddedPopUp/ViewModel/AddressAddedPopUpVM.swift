//
//  AddressAddedPopUpVM.swift
//  Lyber
//
//  Created by sonam's Mac on 23/08/22.
//

import Foundation
class AddressAddedPopUpVM{
    
	func deleteAddressApi(network: String, address: String,completion: @escaping ( (SuccessAPI?) -> Void )){
        let params : [String: Any] = [Constants.ApiKeys.network : network,
									 Constants.ApiKeys.address: address]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdrawalAddress, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "deleteAddressApi",code: code, error: error)
            completion(nil)
        }, method: .DELETEWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
}
