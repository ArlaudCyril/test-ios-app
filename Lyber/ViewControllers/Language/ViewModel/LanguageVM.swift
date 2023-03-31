//
//  LanguageVM.swift
//  Lyber
//
//  Created by Lyber on 29/03/2023.
//

import Foundation
class LanguageVM{
	func setLanguageAPI(language:String,completion: @escaping ( (SuccessAPI?) -> Void )){
		var params : [String : Any] = [:]
		//"language": "french"
		params = [Constants.ApiKeys.language : language.uppercased()]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceLanguage, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error in
			completion(nil)
			CommonFunctions.toster(error)
		}, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
	}
}
