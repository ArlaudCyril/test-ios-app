//
//  ExportVm.swift
//  Lyber
//
//  Created by Lyber on 01/09/2023.
//

import Foundation

class ExportVm{
	func exportApi(date: String, completion: @escaping ( (SuccessAPI?) -> Void )){
		
		var params : [String : Any] = [Constants.ApiKeys.date : date]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceExport, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
			print(response)
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParamater: nil, headerType: "user")
	}
}
