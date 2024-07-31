//
//  EnterPhoneVM.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation
import CommonCrypto

class EnterPhoneVM {
    private var lastSignUpApiCall: Date?
    // MARK:- API CALL
	func SignUpApi(phoneNumber: String,countryCode : String, completion: @escaping ( (signUpApi?) -> Void )){
        let currentTime = Date()
        if let lastCall = self.lastSignUpApiCall {
            let remainingSeconds = 60 - currentTime.timeIntervalSince(lastCall)
            if remainingSeconds > 0 {
                CommonFunctions.toster(CommonFunctions.localisation(key: "WAIT_BEFORE_OTP", parameter: String(Int(remainingSeconds))))
                completion(nil)
                return
            }
        }
        
        self.lastSignUpApiCall = currentTime
        
        let secretKey = "409f3hui4rbf2d2E/4-39u2!-9di4b23-01C*SRFV2d12jbf)2DBFG3i4f24f"
        let timestamp = String(Int(Date().timeIntervalSince1970))
        var phone : String = phoneNumber
        
        if(phone.first == "0"){
            phone.remove(at: phone.startIndex)
        }
        let payload = "{\"countryCode\":\(Int(countryCode) ?? 0),\"phoneNo\":\"\(phone)\"}"
        let signature = createSignature(secretKey: secretKey, payload: payload, timestamp: timestamp)

        let param: [String: Any] = [
            Constants.ApiKeys.phoneNo: phone,
            Constants.ApiKeys.countryCode: Int(countryCode) ?? 0 as Any,
            Constants.ApiKeys.signature: signature,
            Constants.ApiKeys.timestamp: timestamp
        ]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetPhone, withParameters: param, ofType: signUpApi.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "SignUpApi",code: code, error: error)
			completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "signature")
    }
    
    func enterOTPApi(otp: String, completion: @escaping ( (OTPAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.code: otp]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyPhoneNo, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "enterOTPApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func logInWithPhoneChallengeApi(phoneNumber: String,countryCode : String, completion: @escaping ( (ChallengeAPI?) -> Void )){
        let param: [String: Any] = [
            Constants.ApiKeys.phoneNo: "\(Int(countryCode) ?? 0)\(phoneNumber)"
        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userChallenge, withParameters: param, ofType: ChallengeAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "logInWithPhoneChallengeApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func logInChallengeApi(email: String, completion: @escaping ( (ChallengeAPI?) -> Void )){
        let param: [String: Any] = [
            Constants.ApiKeys.email: email
        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userChallenge, withParameters: param, ofType: ChallengeAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "logInChallengeApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "none")
    }
    
    func logInApi(A: String,M1 : String,method : String, completion: @escaping ( (LogInAPI?) -> Void )){
        let param: [String: Any] = [
            Constants.ApiKeys.method: method,
            Constants.ApiKeys.A: A,
            Constants.ApiKeys.M1: M1,
        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userLogin, withParameters: param, ofType: LogInAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "logInApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "user")
    }
    
    func sendDeviceTokenToServer(deviceToken: String){
		var headerType = "user"
		let param: [String: Any] = [
			"token": deviceToken,
			"device": "IOS"
		]
		if(userData.shared.userToken == ""){
			headerType = "registration"
		}
            ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.registerDeviceToken, withParameters: param, ofType: ResendOtpAPI.self, onSuccess: { response in
                print(response)
                CommonFunctions.hideLoader()
            }, onFailure: { reload, error, code in
                print(error)
                CommonFunctions.toster(error)
            }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: headerType)
    }
}
//MARK: other functions
extension EnterPhoneVM{
    
    func createSignature(secretKey: String, payload: String, timestamp: String) -> String {
        let message = "\(timestamp).\(payload)"
        let key = secretKey.data(using: .utf8)!
        let messageData = message.data(using: .utf8)!

        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), key.bytes, key.count, messageData.bytes, messageData.count, &hmac)

        let hmacData = Data(hmac)
        return hmacData.map { String(format: "%02hhx", $0) }.joined()
    }
}

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
