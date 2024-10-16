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
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceUser, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "setLanguageAPI",code: code, error: error)
			completion(nil)
		}, method: .PATCHWithJSON, img: nil, imageParameter: nil, headerType: "user", integrity: true)
	}
}
