//
//  CryptoDepositeVM.swift
//  Lyber
//
//  Created by Lyber on 19/04/2023.
//

import Foundation

class CryptoDepositeVM{
	func getWalletAdressApi(assetId: String, chain: String, completion: @escaping ( (WalletAddressAPI?) -> Void )){
		let params : [String:Any] = ["asset" : assetId,
									 "chain" : chain]
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.walletServiceAddress, withParameters:params, ofType: WalletAddressAPI.self, onSuccess: { response in
			completion(response)
			print("success api correct")
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error in
			completion(nil)
			print("error api not correct")
			CommonFunctions.toster(error)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}
}
