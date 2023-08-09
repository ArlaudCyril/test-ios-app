//
//  IdentityVerificationVM.swift
//  Lyber
//
//  Created by Lyber on 31/07/2023.
//

import Foundation
class IdentityVerificationVM{
	func startKycApi(completion: @escaping ( (UrlAPI?) -> Void )){
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.kycServiceKyc, withParameters: [:], ofType: UrlAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
			completion(nil)
			CommonFunctions.toster(error)
		}, method: .POST, img: nil, imageParamater: nil, headerType: "registration")
	}
}
