//
//  CryptoAddressBookVM.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import Foundation
class CryptoAddressBookVM{
    func createWithdrawalAddress(cryptoAddress : Address?, controller: ViewController, isEditing: Bool, completion: @escaping ( (SuccessAPI?) -> Void )){
		var param : [String : Any] = [:]
        var caller = "createWithdrawalAddress"
		
		param[Constants.ApiKeys.network] = cryptoAddress?.network?.lowercased() ?? ""
		param[Constants.ApiKeys.name] = cryptoAddress?.name ?? ""
		param[Constants.ApiKeys.address] = cryptoAddress?.address ?? ""
		param[Constants.ApiKeys.origin] = cryptoAddress?.origin ?? ""
		if cryptoAddress?.exchange ?? "" != ""{
			param[Constants.ApiKeys.exchange] = cryptoAddress?.exchange ?? ""
			
		}
        
        if(isEditing){
            caller = "editWithdrawalAddress"
        }
        
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdrawalAddress, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
            CommonFunctions.handleErrors(caller: "createWithdrawalAddress",code: code, error: error, controller: controller, arguments: ["network": cryptoAddress?.network ?? ""])
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
	}
	
    func getWithdrawalAdressAPI(completion: @escaping ( (CryptoAddressesAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceWithdrawalAddress, withParameters: [:], ofType: CryptoAddressesAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getWithdrawalAdressAPI",code: code, error: error)
            completion(nil)
        }, method: .GET, img: nil, imageParameter: nil, headerType: "user")
    }
}
