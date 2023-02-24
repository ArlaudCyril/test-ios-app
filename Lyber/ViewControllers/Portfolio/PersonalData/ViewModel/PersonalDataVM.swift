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
        
        
        if profile_info_step == 4{
            param[Constants.ApiKeys.address1] =  "\(personalData?.streetNumber ?? ""),\(personalData?.buildingFloor ?? ""),\(personalData?.CityName ?? ""),\(personalData?.stateName ?? ""),\(personalData?.zipCode ?? "")"
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
            param[Constants.ApiKeys.personalAssets] =   personalData?.personalAssets?.replacingOccurrences(of: " assets", with: "") ?? ""
        }
        
//        param[Constants.ApiKeys.personal_info_step] =  profile_info_step
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserInfo, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func setAddressApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        if profile_info_step == 4{
//            param[Constants.ApiKeys.address1] =  "\(personalData?.streetNumber ?? ""),\(personalData?.buildingFloor ?? ""),\(personalData?.CityName ?? ""),\(personalData?.stateName ?? ""),\(personalData?.zipCode ?? "")"
            param[Constants.ApiKeys.streetNumber] =  Int(personalData?.streetNumber ?? "")
            param[Constants.ApiKeys.street] =  personalData?.buildingFloor ?? ""
            param[Constants.ApiKeys.city] =  personalData?.CityName ?? ""
            param[Constants.ApiKeys.stateOrProvince] =  personalData?.stateName ?? ""
            param[Constants.ApiKeys.zipCode] =  Int(personalData?.zipCode ?? "")
            param[Constants.ApiKeys.country] =  personalData?.CountryName ?? ""
        }
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userSetUserAddress, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func setInvestmentExperienceApi(profile_info_step : Int,personalData : personalDataStruct?, completion: @escaping ( (OTPAPI?) -> Void )){
        
        var param: [String: Any] = [:]
        if profile_info_step == 5{
            param[Constants.ApiKeys.investmentExperience] = personalData?.investmentExp ?? ""
            param[Constants.ApiKeys.incomeSource] =  personalData?.sourceOfIncome ?? ""
            param[Constants.ApiKeys.occupation] =  personalData?.workIndustry ?? ""
            param[Constants.ApiKeys.incomeRange] =  personalData?.annualIncome?.replacingOccurrences(of: "k€/month", with: "") ?? ""
            param[Constants.ApiKeys.personalAssets] =   personalData?.personalAssets?.replacingOccurrences(of: " assets", with: "") ?? ""
        }
      
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userInvestmentExperience, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    
    
    func getPersonalDataApi(completion: @escaping ( (UserPersonalData?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.userPersonal_info, withParameters: [:], ofType: UserPersonalData.self, onSuccess: { response in
            completion(response)
            CommonFunctions.hideLoader()
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .GET, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func sendVerificationEmailApi(email : String?,password : String?, completion: @escaping ( (OTPAPI?) -> Void )){
        // Configure SRP to work with SHA512 and safe prime 2048 bits
        let configuration = SRPConfiguration<SHA512>(.N2048)
        let client = SRPClient(configuration: configuration)
        
        let (emailSalt, emailVerifier) = client.generateSaltAndVerifier(username: email ?? "", password: password ?? "")
        let (phoneSalt, phoneVerifier) = client.generateSaltAndVerifier(username: "\(userData.shared.phone_no)", password: password ?? "")
        let param: [String: Any] = [Constants.ApiKeys.email: email ?? "",
                                    Constants.ApiKeys.emailSalt: BigNum(bytes: emailSalt).dec,
                                    Constants.ApiKeys.emailVerifier: emailVerifier.number.dec,
                                    Constants.ApiKeys.phoneSalt: BigNum(bytes: phoneSalt).dec,
                                    Constants.ApiKeys.phoneVerifier: phoneVerifier.number.dec]
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.setEmailAndPassword, withParameters: param, ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func checkEmailVerificationApi(uuid : String? , completion: @escaping ( (OTPAPI?) -> Void )){
        let link = "\(Constants.ApiUrlKeys.userVerifyEmail)?uuid=\(uuid ?? "")&code=\(1234)"
        ApiHandler.callApiWithParameters(url: link, withParameters: [:], ofType: OTPAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
//            CommonFunction.toster(error)
        }, method: .GetString, img: nil, imageParamater: nil, headerPresent: true)
    }
    
    func finishRegistrationApi(completion: @escaping ( (SuccessAPI?) -> Void )){
        
        ApiHandler.callApiWithParameters(url: Constants.ApiUrlKeys.finishRegistration, withParameters: [:], ofType: SuccessAPI.self, onSuccess: { response in
            completion(response)
        }, onFailure: { reload, error in
            completion(nil)
            CommonFunctions.toster(error)
        }, method: .PostWithJSON, img: nil, imageParamater: nil, headerPresent: true)
    }
}
