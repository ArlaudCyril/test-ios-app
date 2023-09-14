//
//  PersonalDataVM.swift
//  Lyber
//
//  Created by sonam's Mac on 30/06/22.
//

import Foundation
import BigNum
import CryptoKit

class PersonalDataVM{
    func personalDataApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        if personalData?.fisrtName ?? "" != ""{
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
		}
		if personalData?.language ?? "" != ""{
			param[Constants.ApiKeys.language] =  personalData?.language?.uppercased() ?? ""
        }
        
        
        if profile_info_step == 4{
            param[Constants.ApiKeys.address1] =  "\(personalData?.streetNumber ?? ""),\(personalData?.streetName ?? ""),\(personalData?.CityName ?? ""),\(personalData?.stateName ?? ""),\(personalData?.zipCode ?? "")"
            param[Constants.ApiKeys.city] =  personalData?.CityName ?? ""
            param[Constants.ApiKeys.state] =  personalData?.stateName ?? ""
            param[Constants.ApiKeys.zip_code] =  personalData?.zipCode ?? ""
            param[Constants.ApiKeys.country] =  personalData?.CountryName ?? ""
        }
        
        if profile_info_step == 5{
            param[Constants.ApiKeys.investment_experience] = personalData?.investmentExp ?? ""
            param[Constants.ApiKeys.income_source] =  personalData?.sourceOfIncome ?? ""
            param[Constants.ApiKeys.occupation] =  personalData?.workIndustry ?? ""
            param[Constants.ApiKeys.incomeRange] =  personalData?.annualIncome?.replacingOccurrences(of: "k€/month", with: "") ?? ""
        }
        
//        param[Constants.ApiKeys.personal_info_step] =  profile_info_step
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserInfo, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func setAddressApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        if profile_info_step == 4{
            param[Constants.ApiKeys.streetNumber] = personalData?.streetNumber ?? ""
            param[Constants.ApiKeys.street] =  personalData?.streetName ?? ""
            param[Constants.ApiKeys.city] =  personalData?.CityName ?? ""
            param[Constants.ApiKeys.stateOrProvince] =  personalData?.stateName ?? ""
            param[Constants.ApiKeys.zipCode] =  personalData?.zipCode ?? ""
            param[Constants.ApiKeys.country] =  personalData?.CountryName ?? ""
        }
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserAddress, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func setInvestmentExperienceApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        if profile_info_step == 5{
            param[Constants.ApiKeys.investmentExperience] = personalData?.investmentExp ?? ""
            param[Constants.ApiKeys.incomeSource] =  personalData?.sourceOfIncome ?? ""
            param[Constants.ApiKeys.occupation] =  personalData?.workIndustry ?? ""
            param[Constants.ApiKeys.incomeRange] =  personalData?.annualIncome?.encoderAnnualIncome
			param[Constants.ApiKeys.mainUse] =  personalData?.activity ?? ""
        }
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestmentExperience, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    
    func sendVerificationEmailApi(email : String?,password : String?, completion: @escaping ( (OTPAPI?) -> Void )){
        // Configure SRP to work with SHA512 and safe prime 2048 bits
        let configuration = SRPConfiguration<SHA512>(.N2048)
        let client = SRPClient(configuration: configuration)
        
        let (emailSalt, emailVerifier) = client.generateSaltAndVerifier(username: email ?? "", password: password ?? "")
		let (phoneSalt, phoneVerifier) = client.generateSaltAndVerifier(username: "\(userData.shared.countryCode)\(userData.shared.phone_no.phoneFormat)", password: password ?? "")
        let param: [String: Any] = [Constants.ApiKeys.email: email ?? "",
                                    Constants.ApiKeys.emailSalt: BigNum(bytes: emailSalt).dec,
                                    Constants.ApiKeys.emailVerifier: emailVerifier.number.dec,
                                    Constants.ApiKeys.phoneSalt: BigNum(bytes: phoneSalt).dec,
                                    Constants.ApiKeys.phoneVerifier: phoneVerifier.number.dec]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.setEmailAndPassword, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func checkEmailVerificationApi(code : String?, completion: @escaping ( (OTPAPI?) -> Void )){
        let params : [String : Any] = [Constants.ApiKeys.code : code ?? ""]

        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userVerifyEmail, withParameters: params, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
//            CommonFunction.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
    
    func finishRegistrationApi(completion: @escaping ( (SuccessAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.finishRegistration, withParameters: [:], ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error, code in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerType: "registration")
    }
}
