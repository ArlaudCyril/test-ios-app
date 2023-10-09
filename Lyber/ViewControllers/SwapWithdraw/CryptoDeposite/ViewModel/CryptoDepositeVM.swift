//
//  CryptoDepositeVM.swift
//  Lyber
//
//  Created by Lyber on 19/04/2023.
//

import Foundation

class CryptoDepositeVM{
	func getWalletAdressApi(assetId: String, network: String, completion: @escaping ( (WalletAddressAPI?) -> Void )){
		let params : [String:Any] = [Constants.ApiKeys.asset : assetId,
									 Constants.ApiKeys.network : network]
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceAddress, withParameters:params, ofType: WalletAddressAPI.self, onSuccess: { response in
			completion(response)
			print("success api correct")
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getWalletAdressApi",code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}
}
