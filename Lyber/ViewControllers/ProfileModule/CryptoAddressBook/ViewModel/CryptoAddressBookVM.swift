//
//  CryptoAddressBookVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation
class CryptoAddressBookVM{
	func createWithdrawalAddress(cryptoAddress : Address?,completion: @escaping ( (SuccessAPI?) -> Void )){
		var param : [String : Any] = [:]
		
		param[Constants.ApiKeys.asset] = cryptoAddress?.asset?.lowercased() ?? ""
		param[Constants.ApiKeys.name] = cryptoAddress?.name ?? ""
		param[Constants.ApiKeys.address] = cryptoAddress?.address ?? ""
		param[Constants.ApiKeys.origin] = cryptoAddress?.origin ?? ""
		if cryptoAddress?.exchange ?? "" != ""{
			param[Constants.ApiKeys.exchange] = cryptoAddress?.exchange ?? ""
			
		}
		
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdrawalAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
			completion(nil)
			CommonFunctions.toster(error)
		}, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
	}
	
    func getWithdrawalAdressAPI(completion: @escaping ( (CryptoAddressesAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdrawalAddress, withParameters: [:], ofType: CryptoAddressesAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerType: "user")
    }
}
