//
//  ChangePasswordVM.swift
//  Lyber
//
//  Created by Lyber on 03/11/2023.
//

import Foundation
import BigNum
import CryptoKit

class ChangePasswordVM{
	func passwordChangeChallengeAPI(completion: @escaping ( (ChallengeAPI?) -> Void )){
		
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServicePasswordChangeChallenge, withParameters: [:], ofType: ChallengeAPI.self, onSuccess: { response in
			print(response)
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "passwordChangeChallengeAPI",code: code, error: error)
			completion(nil)
		}, method: .GET, img: nil, imageParameter: nil, headerType: "user")
	}
	
	func setNewPasswordAPI(b: String, salt: String, oldPassword: String, newPassword: String, completion: @escaping ( (SuccessAPI?) -> Void )){
		//Calculation of A, M1, phoneSalt, phoneVerifier, emailSalt, emailVerifier
		var params : [String : String] = [:]
		let serverPublicKey = BigNum.init(b)!
		let salt = BigNum.init(salt)!
		let configuration = SRPConfiguration<SHA512>(.N2048)
		let client = SRPClient(configuration: configuration)
		let clientKeys = client.generateKeys()
		let spk = SRPKey(serverPublicKey)
		
		do {
			//email and old password
			let clientSharedSecret = try client.calculateSharedSecret(username: userData.shared.email, password: oldPassword, salt: salt.bytes, clientKeys: clientKeys, serverPublicKey: spk)
			let clientProof = client.calculateSimpleClientProof(clientPublicKey: clientKeys.public, serverPublicKey: spk, sharedSecret: clientSharedSecret)
			let A = BigNum(bytes: clientKeys.public.bytes).dec
			let M1 = BigNum(bytes: clientProof).dec
			
			//email, phone and new password
			let (emailSalt, emailVerifier) = client.generateSaltAndVerifier(username: userData.shared.email, password: newPassword)
			let (phoneSalt, phoneVerifier) = client.generateSaltAndVerifier(username: "\(userData.shared.countryCode)\(userData.shared.phone_no.phoneFormat)", password: newPassword)
			
			params = [
				Constants.ApiKeys.A: A,
				Constants.ApiKeys.M1: M1,
				Constants.ApiKeys.emailSalt: BigNum(bytes: emailSalt).dec,
				Constants.ApiKeys.emailVerifier: emailVerifier.number.dec,
				Constants.ApiKeys.phoneSalt: BigNum(bytes: phoneSalt).dec,
				Constants.ApiKeys.phoneVerifier: phoneVerifier.number.dec
			]
		}catch{
			print("error")
		}
								
		ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userServicePassword, withParameters: params, ofType: SuccessAPI.self, onSuccess: { response in
			completion(response)
		}, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "setNewPasswordAPI",code: code, error: error)
			completion(nil)
		}, method: .PostWithJSON, img: nil, imageParameter: nil, headerType: "user")
	}
}
