//
//  CoreData.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import Foundation
import CoreData
import UIKit

class userData : NSObject {
    var accessToken = ""
    var refreshToken = ""
    var time : Date? = nil
    var id = ""
    var email = ""
    var name = ""
    var rating = 0.0
    var profile_image = ""
    var profilePicType = ""
    var phone_no = 0
    var phoneVerified = 0
    var countryCode = ""
    var walletBalance = 0
    var isAccountCreated = false
    var isPersonalInfoFilled = false
    var isIdentityVerified = false
    var isEducationStrategyRead = false
    var logInPinSet = 0
    var is_push_enabled = 0
    var isPhoneVerified = false
    var personalDataStepComplete  = 0
    var step = 0
    var balance = 0.0
    var faceIdEnabled = 0
    var iban = ""
    var bic = ""
    var extraSecurity = ""
    var strongAuthVerified = false
    var enableWhiteListing = false
    
    class var shared: userData{
        struct singleTon {
            static let instance = userData()
        }
        return singleTon.instance
    }

    func fromSignUpData(_ data : LoginAPI?){// why no refresh token here
        self.accessToken = data?.token ?? ""
        self.profile_image = data?.user?.profilePic ?? ""
        self.profilePicType = data?.user?.profilePicType ?? ""
        self.name = "\(data?.user?.firstName ?? "") \(data?.user?.lastName ?? "")"
        self.email = data?.user?.email ?? ""
        self.phone_no = data?.user?.phoneNo ?? 0
        self.countryCode = data?.user?.countryCode ?? ""
        self.logInPinSet = data?.user?.loginPin ?? 0
        self.is_push_enabled = data?.user?.isPushEnabled ?? 0
        self.personalDataStepComplete = data?.user?.personal_info_step ?? 0
        self.isPhoneVerified = data?.user?.phoneNoVerified == true ? true : false
        self.balance = data?.user?.balance ?? 0
        self.iban = data?.user?.iban ?? ""
        self.bic = data?.user?.bic ?? ""
        self.step = data?.user?.step ?? 0
        self.faceIdEnabled = data?.user?.isFaceIDEnabled ?? 0
        self.extraSecurity = data?.user?.extraSecurity ?? ""
        self.strongAuthVerified = data?.user?.isStrongAuthVerified ?? false
        self.enableWhiteListing = data?.user?.isAddressWhitelistingEnabled ?? false
        
        if data?.user?.step == 1{
            self.isAccountCreated = true
        }else if data?.user?.step == 2{
            self.isPersonalInfoFilled = true
//            self.isIdentityVerified = true
        }else if data?.user?.step == 3{
            self.isIdentityVerified = true
        }else if data?.user?.step == 4{
            self.isIdentityVerified = true
            self.isEducationStrategyRead = true
        }
       
//        self.walletBalance = data.wallet ?? 0
        dataSave()
    }

//    func fromPersonalData(_ data : ProfileAPI?){
//        self.name = "\(data?.firstName ?? "") \(data?.lastName ?? "")"
//        self.profile_image = data?.profilePic ?? ""
//        self.profilePicType = data?.profilePicType ?? ""
//        self.email = data?.email ?? ""
//        self.phone_no = data?.phoneNo ?? 0
//        self.countryCode = data?.countryCode ?? ""
//        self.logInPinSet = data?.loginPin ?? 0
//        self.is_push_enabled = data?.isPushEnabled ?? 0
//        self.personalDataStepComplete = data?.personalInfoStep ?? 0
//        self.balance = data?.balance ?? 0
//        self.iban = data?.iban ?? ""
//        self.bic = data?.bic ?? ""
//        self.step = data?.step ?? 0
//        self.faceIdEnabled = data?.isFaceIDEnabled ?? 0
//        self.extraSecurity = data?.extraSecurity ?? ""
//        self.strongAuthVerified = data?.isStrongAuthVerified ?? false
//        self.enableWhiteListing = data?.isAddressWhitelistingEnabled ?? false
//        
//        if data?.step == 1{
//            self.isAccountCreated = true
//        }else if data?.step == 2{
//            self.isPersonalInfoFilled = true
////            self.isIdentityVerified = true
//        }else if data?.step == 3{
//            self.isIdentityVerified = true
//        }else if data?.step == 4{
//            self.isIdentityVerified = true
//            self.isEducationStrategyRead = true
//        }
////        self.phoneVerified = data.isVerified!
////        self.profile_image = data.profilePic ?? ""
////        self.walletBalance = data.wallet ?? 0
//        dataSave()
//    }
    
    func dataSave(){
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "UserData"))
        
        do {
            try context.execute(DelAllReqVar)
        } catch {
            print(error)
        }
        let newData = NSEntityDescription.insertNewObject(forEntityName: "UserData", into: context)
        newData.setValue(accessToken, forKey: "accessToken")
        newData.setValue(refreshToken, forKey: "refreshToken")
        newData.setValue(time, forKey: "time")
        newData.setValue(name, forKey: "name")
        newData.setValue(email, forKey: "email")
        newData.setValue(phone_no, forKey: "phone_no")
        newData.setValue(countryCode, forKey: "countryCode")
        newData.setValue(isAccountCreated, forKey: "isAccountCreated")
        newData.setValue(isPersonalInfoFilled, forKey: "isPersonalInfoFilled")
        newData.setValue(isIdentityVerified, forKey: "isIdentityVerified")
        newData.setValue(isEducationStrategyRead, forKey: "isEducationStrategyRead")
        newData.setValue(logInPinSet, forKey: "logInPinSet")
        newData.setValue(is_push_enabled, forKey: "is_push_enabled")
        newData.setValue(isPhoneVerified, forKey: "isPhoneVerified")
        newData.setValue(personalDataStepComplete, forKey: "personalDataStepComplete")
        newData.setValue(step, forKey: "step")
        newData.setValue(balance, forKey: "balance")
        newData.setValue(iban, forKey: "iban")
        newData.setValue(bic, forKey: "bic")
        newData.setValue(faceIdEnabled, forKey: "faceIdEnabled")
        newData.setValue(extraSecurity, forKey: "extraSecurity")
        newData.setValue(strongAuthVerified, forKey: "strongAuthVerified")
        newData.setValue(profile_image, forKey: "profile_image")
        newData.setValue(profilePicType, forKey: "profilePicType")
        newData.setValue(enableWhiteListing, forKey: "enableWhiteListing")
//        newData.setValue(walletBalance, forKey: "wallet")
        do {
            try context.save()
            print(newData)
            print("new data saved")
        }catch{
            print("new data save error")
        }
    }
    
   
    
    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserData")
        request.returnsObjectsAsFaults = true
        do{
            let results = try context.fetch(request)
            if(results.count > 0){
                for result in results as![NSManagedObject]{
                    
                    if let isAccountCreated = result.value(forKey: "isAccountCreated") as? Bool{
                        self.isAccountCreated = isAccountCreated
                        print("data get isAccountCreated \(isAccountCreated)")
                    }
                    if let isPersonalInfoFilled = result.value(forKey: "isPersonalInfoFilled") as? Bool{
                        self.isPersonalInfoFilled = isPersonalInfoFilled
                        print("data get isPersonalInfoFilled \(isPersonalInfoFilled)")
                    }
                    if let isIdentityVerified = result.value(forKey: "isIdentityVerified") as? Bool{
                        self.isIdentityVerified = isIdentityVerified
                        print("data get isIdentityVerified \(isIdentityVerified)")
                    }
                    if let isEducationStrategyRead = result.value(forKey: "isEducationStrategyRead") as? Bool{
                        self.isEducationStrategyRead = isEducationStrategyRead
                        print("data get isEducationStrategyRead \(isEducationStrategyRead)")
                    }
                    if let accessToken = result.value(forKey: "accessToken") as? String{
                        self.accessToken = accessToken
                        print("data get accessToken \(accessToken)")
                    }
                    if let refreshToken = result.value(forKey: "refreshToken") as? String{
                        self.refreshToken = refreshToken
                        print("data get refreshToken \(refreshToken)")
                    }
                    if let time = result.value(forKey: "time") as? Date{
                        self.time = time
                        print("data get time \(time)")
                    }
                    if let name = result.value(forKey: "name") as? String{
                        self.name = name
                        print("data get name \(name)")
                    }
                    if let email = result.value(forKey: "email") as? String{
                        self.email = email
                        print("data get email \(email)")
                    }
                    if let logInPinSet = result.value(forKey: "logInPinSet") as? Int{
                        self.logInPinSet = logInPinSet
                        print("data get logInPinSet \(logInPinSet)")
                    }
                    if let is_push_enabled = result.value(forKey: "is_push_enabled") as? Int{
                        self.is_push_enabled = is_push_enabled
                        print("data get is_push_enabled \(is_push_enabled)")
                    }
                    if let personalDataStepComplete = result.value(forKey: "personalDataStepComplete") as? Int{
                        self.personalDataStepComplete = personalDataStepComplete
                        print("data get personal_Data_Step_Complete \(personalDataStepComplete)")
                    }
                    if let isPhoneVerified = result.value(forKey: "isPhoneVerified") as? Bool{
                        self.isPhoneVerified = isPhoneVerified
                        print("data get isPhoneVerified \(isPhoneVerified)")
                    }
                    if let step = result.value(forKey: "step") as? Int{
                        self.step = step
                        print("data get step \(step)")
                    }
                    if let phone_no = result.value(forKey: "phone_no") as? Int{
                        self.phone_no = phone_no
                        print("data get phone_no \(phone_no)")
                    }
                    if let countryCode = result.value(forKey: "countryCode") as? String{
                        self.countryCode = countryCode
                        print("data get countryCode \(countryCode)")
                    }
                    if let balance = result.value(forKey: "balance") as? Double{
                        self.balance = balance
                        print("data get balance \(balance)")
                    }
                    if let iban = result.value(forKey: "iban") as? String{
                        self.iban = iban
                        print("data get iban \(iban)")
                    }
                    if let bic = result.value(forKey: "bic") as? String{
                        self.bic = bic
                        print("data get bic \(bic)")
                    }
                    if let faceIdEnabled = result.value(forKey: "faceIdEnabled") as? Int{
                        self.faceIdEnabled = faceIdEnabled
                        print("data get faceIdEnabled \(faceIdEnabled)")
                    }
                    if let extraSecurity = result.value(forKey: "extraSecurity") as? String{
                        self.extraSecurity = extraSecurity
                        print("data get extraSecurity \(extraSecurity)")
                    }
                    if let strongAuthVerified = result.value(forKey: "strongAuthVerified") as? Bool{
                        self.strongAuthVerified = strongAuthVerified
                        print("data get strongAuthVerified \(strongAuthVerified)")
                    }
                    if let profile_image = result.value(forKey: "profile_image") as? String{
                        self.profile_image = profile_image
                        print("data get profile_image \(profile_image)")
                    }
                    if let profilePicType = result.value(forKey: "profilePicType") as? String{
                        self.profilePicType = profilePicType
                        print("data get profilePicType \(profilePicType)")
                    }
                    if let enableWhiteListing = result.value(forKey: "enableWhiteListing") as? Bool{
                        self.enableWhiteListing = enableWhiteListing
                        print("data get enableWhiteListing \(enableWhiteListing)")
                    }
                }
            }
        } catch {
            print("something error during getting data")
        }
    }
    
    func deleteData(){
        self.isAccountCreated = false
        self.isPersonalInfoFilled = false
        self.isIdentityVerified = false
        self.isEducationStrategyRead = false
        self.accessToken = ""
        self.refreshToken = ""
        self.time = nil
        self.id = ""
        self.name = ""
        self.rating = 0.0
        self.profile_image = ""
        self.email = ""
        self.phone_no = 0
        self.countryCode = ""
        self.phoneVerified = 0
        self.walletBalance = 0
        self.logInPinSet = 0
        self.is_push_enabled = 0
        self.isPhoneVerified = false
        self.personalDataStepComplete = 0
        self.step = 0
        self.balance = 0
        self.iban = ""
        self.bic = ""
        self.faceIdEnabled = 0
        self.extraSecurity = ""
        self.strongAuthVerified = false
        self.profile_image = ""
        self.profilePicType = ""
        self.enableWhiteListing = false

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "UserData"))
        do {
            try context.execute(DelAllReqVar)
        } catch {
            print(error)
        }
    }
}
