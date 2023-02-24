//
//  EnterPhoneVM.swift
//  Lyber
//
//  Created by sonam's Mac on 29/06/22.
//

import Foundation

class EnterPhoneVM {
    // MARK:- API CALL
    func SignUpApi(phoneNumber: String,countryCode : String, completion: @escaping ( (signUpApi?) -> Void )){
        
        let param: [String: Any] = [
            Constants.ApiKeys.phoneNo: phoneNumber,
            Constants.ApiKeys.countryCode: Int(countryCode) ?? 0 as Any,
//            Constants.ApiKeys.device_type: Constants.deviceType,
//            Constants.ApiKeys.device_id: Constants.deviceID,
//            Constants.ApiKeys.device_token: Constants.deviceToken,
        ]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetPhone, withParameters: param, ofType: signUpApi.self, onSuccess: { response in
            completion(response)
//            CommonFunction.toster(response.message ?? "")
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: false)
    }
    
    func enterOTPApi(otp: String, completion: @escaping ( (OTPAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.code: Int(otp) ?? 0 as Any]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyPhoneNo, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func setLoginPinApi(Pin: String, completion: @escaping ( (OTPAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.login_pin: Pin]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetLoginPin, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func logInWithPhoneChallengeApi(phoneNumber: String,countryCode : String, completion: @escaping ( (LoginChallengeAPI?) -> Void )){
        let param: [String: Any] = [
            Constants.ApiKeys.phoneNo: "\(Int(countryCode) ?? 0)\(phoneNumber)"
        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userChallenge, withParameters: param, ofType: LoginChallengeAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: false)
    }
    
    func logInChallengeApi(email: String, completion: @escaping ( (LoginChallengeAPI?) -> Void )){
        let param: [String: Any] = [
            Constants.ApiKeys.email: email
        ]
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userChallenge, withParameters: param, ofType: LoginChallengeAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: false)
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
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func enableNotificationApi(enable: Int, completion: @escaping ( (OTPAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.is_push_enabled: enable]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userResetNotification, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PUT, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func enableFaceIdApi(enable: Int, completion: @escaping ( (SuccessAPI?) -> Void )){
        let param: [String: Any] = [Constants.ApiKeys.face_id: Constants.deviceID,
                                    Constants.ApiKeys.enable_face_id : enable]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userActivateFaceId, withParameters: param, ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func resendOtpCodeApi(completion: @escaping ( (ResendOtpAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userResendPhoneVerificationOtp, withParameters: [:], ofType: ResendOtpAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .POST, img: nil, imageParamater: nil, headerPresent: true)
    }
}
