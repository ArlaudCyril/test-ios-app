//
//  AddCryptoAddressVM.swift
//  Lyber
//
//  Created by sonam's Mac on 06/08/22.
//

import Foundation
class AddCryptoAddressVM{
    func getNetworksDataApi(completion: @escaping ( (NetworkDataAPI?) -> Void )){
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.networkServiceNetworks, withParameters: [:], ofType: NetworkDataAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
	
	func getNetworkByIdApi(id: String, completion: @escaping ( (NetworkDataByIdAPI?) -> Void )){
		let param : [String:Any] = [Constants.ApiKeys.id : id]
		
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.networkServiceNetwork, withParameters: param, ofType: NetworkDataByIdAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
    
}
