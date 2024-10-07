//
//  ResetPasswordVM.swift
//  Lyber
//
//  Created by Lyber on 03/08/2023.
//

import Foundation
import Crypto
import BigNum
class ResetPasswordVM{
	func forgotPasswordAPI(email: String, completion: @escaping ( (SuccessAPI?) -> Void )){
		let param = [Constants.ApiKeys.email : email]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceForgot, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "forgotPasswordAPI",code: code, error: error)
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
	}
	
	func resetPasswordIdentifierAPI(token: String, completion: @escaping ( (IdentifiersAPI?) -> Void )){
		let param : [String: Any] = [:]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceResetPasswordIdentifiers, withParameters: param, ofType: IdentifiersAPI.self, onSuccess: { response in
			completion(response)
			CommonFunctions.hideLoader()
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "resetPasswordIdentifierAPI",code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParameter: nil, headerType: token)
	}
	
	func resetPasswordApi(token: String, email : String?, phone: String?, password : String?, completion: @escaping ( (SuccessAPI?) -> Void )){
		// Configure SRP to work with SHA512 and safe prime 2048 bits
		
		let configuration = SRPConfiguration<SHA512>(.N2048)
		let client = SRPClient(configuration: configuration)
		
		let (emailSalt, emailVerifier) = client.generateSaltAndVerifier(username: email ?? "", password: password ?? "")
		let (phoneSalt, phoneVerifier) = client.generateSaltAndVerifier(username: phone?.phoneFormat ?? "", password: password ?? "")
		let param: [String: Any] = [Constants.ApiKeys.emailSalt: BigNum(bytes: emailSalt).dec,
									Constants.ApiKeys.emailVerifier: emailVerifier.number.dec,
									Constants.ApiKeys.phoneSalt: BigNum(bytes: phoneSalt).dec,
									Constants.ApiKeys.phoneVerifier: phoneVerifier.number.dec]
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServiceResetPassword, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "resetPasswordApi",code: code, error: error)
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: token)
	}
}
