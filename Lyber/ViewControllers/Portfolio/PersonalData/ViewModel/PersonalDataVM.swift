//
//  PersonalDataVM.swift
//  Lyber
//
//  Created by sonam's Mac on 30/06/22.
//

import Foundation
import BigNum
import CryptoKit
import UIKit

class PersonalDataVM{
    //func personalDataApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
	func personalDataApi(language: String, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        /*if personalData?.fisrtName ?? "" != ""{
            param[Constants.ApiKeys.firstName] =  personalData?.fisrtName ?? ""
        }
        if personalData?.lastName ?? "" != ""{
            param[Constants.ApiKeys.lastName] =  personalData?.lastName ?? ""
        }
        if personalData?.birthPlace ?? "" != ""{
            param[Constants.ApiKeys.birthPlace] =  personalData?.birthPlace ?? ""
        }
        if personalData?.birthDate ?? "" != ""{
            param[Constants.ApiKeys.birthDate] =  personalData?.birthDate ?? ""
        }
        if personalData?.birthCountry ?? "" != ""{
            param[Constants.ApiKeys.birthCountry] =  personalData?.birthCountry ?? ""
        }
        if personalData?.nationality ?? "" != ""{
            param[Constants.ApiKeys.nationality] =  personalData?.nationality ?? ""
        }
		if personalData?.isUsPerson ?? "" != ""{
			param[Constants.ApiKeys.isUSCitizen] =  personalData?.isUsPerson ?? "" == "Yes" ? true : false
		}*/
		param[Constants.ApiKeys.language] =  language
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserInfo, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "personalDataApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func setAddressApi(personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        param[Constants.ApiKeys.isUSCitizen] =  personalData?.isUsPerson ?? "" == "Yes" ? true : false
        param[Constants.ApiKeys.street] = personalData?.street ?? ""
		param[Constants.ApiKeys.streetNumber] = personalData?.streetNumber ?? ""
		param[Constants.ApiKeys.city] =  personalData?.CityName ?? ""
		param[Constants.ApiKeys.zipCode] =  personalData?.zipCode ?? ""
		param[Constants.ApiKeys.country] =  personalData?.CountryName ?? ""
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserAddress, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "setAddressApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func setInvestmentExperienceApi(personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
		param[Constants.ApiKeys.investmentExperience] = personalData?.investmentExp ?? ""
		param[Constants.ApiKeys.incomeSource] =  personalData?.sourceOfIncome ?? ""
		param[Constants.ApiKeys.occupation] =  personalData?.workIndustry ?? ""
		param[Constants.ApiKeys.incomeRange] =  personalData?.annualIncome?.encoderAnnualIncome
		param[Constants.ApiKeys.mainUse] =  personalData?.activity ?? ""
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestmentExperience, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "setInvestmentExperienceApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    
    func sendVerificationEmailApi(email : String?,password : String?, completion: @escaping ( (OTPAPI?) -> Void )){
        // Configure SRP to work with SHA512 and safe prime 2048 bits
        let configuration = SRPConfiguration<SHA512>(.N2048)
        let client = SRPClient(configuration: configuration)
        
        let (emailSalt, emailVerifier) = client.generateSaltAndVerifier(username: email ?? "", password: password ?? "")
		let (phoneSalt, phoneVerifier) = client.generateSaltAndVerifier(username: "\(Int(userData.shared.countryCode) ?? 0)\(userData.shared.phone_no.phoneFormat)", password: password ?? "")
        let param: [String: Any] = [Constants.ApiKeys.email: email ?? "",
                                    Constants.ApiKeys.emailSalt: BigNum(bytes: emailSalt).dec,
                                    Constants.ApiKeys.emailVerifier: emailVerifier.number.dec,
                                    Constants.ApiKeys.phoneSalt: BigNum(bytes: phoneSalt).dec,
                                    Constants.ApiKeys.phoneVerifier: phoneVerifier.number.dec]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.setEmailAndPassword, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "sendVerificationEmailApi",code: code, error: error)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
	func checkEmailVerificationApi(controller: UIViewController, code : String?, completion: @escaping ( (OTPAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.code : code ?? ""]

        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyEmail, withParameters: params, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "checkEmailVerificationApi",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
	func finishRegistrationApi(controller: UIViewController, completion: @escaping ( (SuccessAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.finishRegistration, withParameters: [:], ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
			CommonFunctions.handleErrors(caller: "finishRegistrationApi",code: code, error: error, controller: controller)
            completion(nil)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
}
