//
//  ContactFormVM.swift
//  Lyber
//
//  Created by Lyber on 12/10/2023.
//

import Foundation
import UIKit

class ContactFormVM{
	func contactSupportAPI(message: String, completion: @escaping ( (SuccessAPI?) -> Void )){
		let param : [String : String] = [Constants.ApiKeys.message: message]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceContactSupport, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
			print(response)
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "contactSupportAPI",code: code, error: error)
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
	}
	
}
