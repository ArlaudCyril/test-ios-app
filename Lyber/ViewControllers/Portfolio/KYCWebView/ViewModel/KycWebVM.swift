//
//  KycWebVM.swift
//  Lyber prod
//
//  Created by Lyber on 05/12/2023.
//

import Foundation

class KycWebVM{
	func getSignUrlApi(completion: @escaping ( (UrlAPI?) -> Void )){
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.kycServiceSignUrl, withParameters: [:], ofType: UrlAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "getSignUrlApi",code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}
}
