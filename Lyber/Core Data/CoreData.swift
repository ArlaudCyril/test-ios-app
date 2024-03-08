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
	var firstname = ""
    var lastname = ""
	var userUuid = ""
	var registeredAt = ""
    var userToken = ""
    var refreshToken = ""
    var registrationToken = ""
	var language = ""
    var time : Date? = nil
    var email = ""
	var profile_image = ""
    var phone_no = ""
    var countryCode = ""
    var isAccountCreated = false
    var isEducationStrategyRead = false
    var logInPinSet = 0
    var is_push_enabled = 0
    var personalDataStepComplete  = 0
    var stepRegisteringComplete  = 0
    var enterPhoneStepComplete  = 0
    var balance = 0.0
    var faceIdEnabled = false
    var iban = ""
    var bic = ""
    var extraSecurity = "none"
    var scope2FALogin = false
    var scope2FAWhiteListing = false
    var scope2FAWithdrawal = false
    var has2FA = false
    var type2FA = "none"
	
	//Profile informations
	///Phase 1
	var firstnameRegistration = ""
	var lastnameRegistration = ""
	var placeOfBirth = ""
	var birthDate = ""
	var countryOfBirth = ""
	var nationality = ""
	var isUsCitizen = ""
	///Phase 2
	var address = ""
	var city = ""
	var zipCode = ""
	var country = ""
	///Phase 3
	var investmentExperience = ""
	var sourceOfIncome = ""
	var workIndustry = ""
	var annualIncome = ""
    var activityOnLyber = ""
	var userSigned = false
	
	
    class var shared: userData{
        struct singleTon {
            static let instance = userData()
        }
        return singleTon.instance
    }

    
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
        newData.setValue(userToken, forKey: "accessToken")
        newData.setValue(refreshToken, forKey: "refreshToken")
        newData.setValue(registrationToken, forKey: "registrationToken")
        newData.setValue(language, forKey: "language")
        newData.setValue(time, forKey: "time")
        newData.setValue(email, forKey: "email")
        newData.setValue(phone_no, forKey: "phone_no")
        newData.setValue(countryCode, forKey: "countryCode")
        newData.setValue(isAccountCreated, forKey: "isAccountCreated")
        newData.setValue(isEducationStrategyRead, forKey: "isEducationStrategyRead")
        newData.setValue(logInPinSet, forKey: "logInPinSet")
        newData.setValue(is_push_enabled, forKey: "is_push_enabled")
        newData.setValue(personalDataStepComplete, forKey: "personalDataStepComplete")
        newData.setValue(stepRegisteringComplete, forKey: "stepRegisteringComplete")
        newData.setValue(enterPhoneStepComplete, forKey: "enterPhoneStepComplete")
        newData.setValue(balance, forKey: "balance")
        newData.setValue(iban, forKey: "iban")
        newData.setValue(bic, forKey: "bic")
        newData.setValue(faceIdEnabled, forKey: "faceIdEnabled")
        newData.setValue(extraSecurity, forKey: "extraSecurity")
        newData.setValue(profile_image, forKey: "profile_image")
        newData.setValue(scope2FALogin, forKey: "scope2FALogin")
        newData.setValue(scope2FAWhiteListing, forKey: "scope2FAWhiteListing")
        newData.setValue(scope2FAWithdrawal, forKey: "scope2FAWithdrawal")
        newData.setValue(has2FA, forKey: "has2FA")
        newData.setValue(type2FA, forKey: "type2FA")
		
		//Profil informations
		newData.setValue(firstname, forKey: "firstname")
        newData.setValue(lastname, forKey: "lastname")
		newData.setValue(userUuid, forKey: "userUuid")
		newData.setValue(registeredAt, forKey: "registeredAt")
		newData.setValue(firstnameRegistration, forKey: "firstnameRegistration")
		newData.setValue(lastnameRegistration, forKey: "lastnameRegistration")
		newData.setValue(placeOfBirth, forKey: "placeOfBirth")
		newData.setValue(birthDate, forKey: "birthDate")
		newData.setValue(countryOfBirth, forKey: "countryOfBirth")
		newData.setValue(nationality, forKey: "nationality")
		newData.setValue(isUsCitizen, forKey: "isUsCitizen")
		
		newData.setValue(address, forKey: "address")
		newData.setValue(city, forKey: "city")
		newData.setValue(zipCode, forKey: "zipCode")
		newData.setValue(country, forKey: "country")
		
		newData.setValue(investmentExperience, forKey: "investmentExperience")
		newData.setValue(sourceOfIncome, forKey: "sourceOfIncome")
		newData.setValue(workIndustry, forKey: "workIndustry")
		newData.setValue(annualIncome, forKey: "annualIncome")
        newData.setValue(activityOnLyber, forKey: "activityOnLyber")
		newData.setValue(userSigned, forKey: "userSigned")
        
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
        
        //MARK: - Uncomment when you want to update the types of variables in your bdd
        /*let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not access documents directory")
        }

        let storeURL = documentsURL.appendingPathComponent("Lyber.sqlite")

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil,
                                               at: storeURL, options: options)
        } catch {
            print("Error adding persistent store: \(error)")
        }*/

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
                    if let isEducationStrategyRead = result.value(forKey: "isEducationStrategyRead") as? Bool{
                        self.isEducationStrategyRead = isEducationStrategyRead
                        print("data get isEducationStrategyRead \(isEducationStrategyRead)")
                    }
                    if let accessToken = result.value(forKey: "accessToken") as? String{
                        self.userToken = accessToken
                        print("data get accessToken \(accessToken)")
                    }
                    if let refreshToken = result.value(forKey: "refreshToken") as? String{
                        self.refreshToken = refreshToken
                        print("data get refreshToken \(refreshToken)")
                    }
                    if let registrationToken = result.value(forKey: "registrationToken") as? String{
                        self.registrationToken = registrationToken
                        print("data get registrationToken \(registrationToken)")
                    }
					if let language = result.value(forKey: "language") as? String{
                        self.language = language
                        print("data get language \(language)")
                    }
                    if let time = result.value(forKey: "time") as? Date{
                        self.time = time
                        print("data get time \(time)")
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
					if let stepRegisteringComplete = result.value(forKey: "stepRegisteringComplete") as? Int{
                        self.stepRegisteringComplete = stepRegisteringComplete
                        print("data get stepRegisteringComplete \(stepRegisteringComplete)")
                    }
					if let enterPhoneStepComplete = result.value(forKey: "enterPhoneStepComplete") as? Int{
                        self.enterPhoneStepComplete = enterPhoneStepComplete
                        print("data get enterPhoneStepComplete \(enterPhoneStepComplete)")
                    }
                    if let phone_no = result.value(forKey: "phone_no") as? String{
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
                    if let faceIdEnabled = result.value(forKey: "faceIdEnabled") as? Bool{
                        self.faceIdEnabled = faceIdEnabled
                        print("data get faceIdEnabled \(faceIdEnabled)")
                    }
                    if let extraSecurity = result.value(forKey: "extraSecurity") as? String{
                        self.extraSecurity = extraSecurity
                        print("data get extraSecurity \(extraSecurity)")
                    }
					if let profile_image = result.value(forKey: "profile_image") as? String{
                        self.profile_image = profile_image
                        print("data get profile_image \(profile_image)")
                    }
                    if let scope2FALogin = result.value(forKey: "scope2FALogin") as? Bool{
                        self.scope2FALogin = scope2FALogin
                        print("data get scope2FALogin \(scope2FALogin)")
                    }
                    if let scope2FAWhiteListing = result.value(forKey: "scope2FAWhiteListing") as? Bool{
                        self.scope2FAWhiteListing = scope2FAWhiteListing
                        print("data get scope2FAWhiteListing \(scope2FAWhiteListing)")
                    }
                    if let scope2FAWithdrawal = result.value(forKey: "scope2FAWithdrawal") as? Bool{
                        self.scope2FAWithdrawal = scope2FAWithdrawal
                        print("data get scope2FAWithdrawal \(scope2FAWithdrawal)")
                    }
                    if let has2FA = result.value(forKey: "has2FA") as? Bool{
                        self.has2FA = has2FA
                        print("data get has2FA \(has2FA)")
                    }
                    if let type2FA = result.value(forKey: "type2FA") as? String{
                        self.type2FA = type2FA
                        print("data get type2FA \(type2FA)")
                    }
					
					//Profile informations
					if let firstname = result.value(forKey: "firstname") as? String{
						self.firstname = firstname
						print("data get firstname \(firstname)")
					}
					if let lastname = result.value(forKey: "lastname") as? String{
                        self.lastname = lastname
                        print("data get lastname \(lastname)")
                    }
                    if let userUuid = result.value(forKey: "userUuid") as? String{
						self.userUuid = userUuid
						print("data get userUuid \(userUuid)")
					}
					if let registeredAt = result.value(forKey: "registeredAt") as? String{
						self.registeredAt = registeredAt
						print("data get registeredAt \(registeredAt)")
					}
					if let firstnameRegistration = result.value(forKey: "firstnameRegistration") as? String{
						self.firstnameRegistration = firstnameRegistration
						print("data get firstnameRegistration \(firstnameRegistration)")
					}
					if let lastnameRegistration = result.value(forKey: "lastnameRegistration") as? String{
						self.lastnameRegistration = lastnameRegistration
						print("data get lastnameRegistration \(lastnameRegistration)")
					}
					if let placeOfBirth = result.value(forKey: "placeOfBirth") as? String{
						self.placeOfBirth = placeOfBirth
						print("data get placeOfBirth \(placeOfBirth)")
					}
					if let birthDate = result.value(forKey: "birthDate") as? String{
						self.birthDate = birthDate
						print("data get birthDate \(birthDate)")
					}
					if let countryOfBirth = result.value(forKey: "countryOfBirth") as? String{
						self.countryOfBirth = countryOfBirth
						print("data get countryOfBirth \(countryOfBirth)")
					}
					if let nationality = result.value(forKey: "nationality") as? String{
						self.nationality = nationality
						print("data get nationality \(nationality)")
					}
					if let isUsCitizen = result.value(forKey: "isUsCitizen") as? String{
						self.isUsCitizen = isUsCitizen
						print("data get isUsCitizen \(isUsCitizen)")
					}
					if let address = result.value(forKey: "address") as? String{
						self.address = address
						print("data get address \(address)")
					}
					if let city = result.value(forKey: "city") as? String{
						self.city = city
						print("data get city \(city)")
					}
					if let zipCode = result.value(forKey: "zipCode") as? String{
						self.zipCode = zipCode
						print("data get zipCode \(zipCode)")
					}
					if let country = result.value(forKey: "country") as? String{
						self.country = country
						print("data get country \(country)")
					}
					if let investmentExperience = result.value(forKey: "investmentExperience") as? String{
						self.investmentExperience = investmentExperience
						print("data get investmentExperience \(investmentExperience)")
					}
					if let sourceOfIncome = result.value(forKey: "sourceOfIncome") as? String{
						self.sourceOfIncome = sourceOfIncome
						print("data get sourceOfIncome \(sourceOfIncome)")
					}
					if let workIndustry = result.value(forKey: "workIndustry") as? String{
						self.workIndustry = workIndustry
						print("data get workIndustry \(workIndustry)")
					}
					if let annualIncome = result.value(forKey: "annualIncome") as? String{
						self.annualIncome = annualIncome
						print("data get annualIncome \(annualIncome)")
					}
					if let activityOnLyber = result.value(forKey: "activityOnLyber") as? String{
                        self.activityOnLyber = activityOnLyber
                        print("data get activityOnLyber \(activityOnLyber)")
                    }
                    if let userSigned = result.value(forKey: "userSigned") as? Bool{
						self.userSigned = userSigned
						print("data get userSigned \(userSigned)")
					}
                }
            }
        } catch {
            print("something error during getting data")
        }
    }
	
	func registered(){
		
		self.isAccountCreated = true
		
		self.personalDataStepComplete = 0
		self.stepRegisteringComplete = 0
		self.enterPhoneStepComplete = 0
		self.registrationToken = ""
		
		//Profile informations
		self.placeOfBirth = ""
		self.birthDate = ""
		self.countryOfBirth = ""
		self.nationality = ""
		self.isUsCitizen = ""
		
		self.address = ""
		self.city = ""
		self.zipCode = ""
		self.country = ""
		
		self.investmentExperience = ""
		self.sourceOfIncome = ""
		self.workIndustry = ""
		self.annualIncome = ""
        self.activityOnLyber = ""
		self.userSigned = false
		
		self.dataSave()
	}
	
	func disconnect(){
//all except following
//		self.isAccountCreated = false
//		self.isEducationStrategyRead = false
//		self.personalDataStepComplete = 0
//		self.stepRegisteringComplete = 0
//		self.enterPhoneStepComplete = 0
//		self.registrationToken = ""
//		self.language = ""
		self.userToken = ""
		self.refreshToken = ""
		self.time = nil
		self.firstname = ""
        self.lastname = ""
		self.userUuid = ""
		self.registeredAt = ""
		self.profile_image = ""
		self.email = ""
		self.phone_no = ""
		self.countryCode = ""
		self.logInPinSet = 0
		self.is_push_enabled = 0
		self.balance = 0
		self.iban = ""
		self.bic = ""
		self.faceIdEnabled = false
		self.extraSecurity = "none"
		self.scope2FALogin = false
		self.scope2FAWhiteListing = false
		self.scope2FAWithdrawal = false
		self.has2FA = false
		self.type2FA = "none"
		
		self.dataSave()
	}
    
    func deleteData(){//maybe it delete also language
		//all except self.language = ""
        self.isAccountCreated = false
        self.isEducationStrategyRead = false
        self.userToken = ""
        self.refreshToken = ""
        self.registrationToken = ""
        self.time = nil
        self.firstname = ""
        self.lastname = ""
        self.userUuid = ""
        self.registeredAt = ""
		self.firstnameRegistration = ""
        self.lastnameRegistration = ""
		self.profile_image = ""
        self.email = ""
        self.phone_no = ""
        self.countryCode = ""
        self.logInPinSet = 0
        self.is_push_enabled = 0
        self.personalDataStepComplete = 0
        self.stepRegisteringComplete = 0
        self.enterPhoneStepComplete = 0
        self.balance = 0
        self.iban = ""
        self.bic = ""
        self.faceIdEnabled = false
        self.extraSecurity = "none"
        self.scope2FALogin = false
        self.scope2FAWhiteListing = false
        self.scope2FAWithdrawal = false
        self.has2FA = false
        self.type2FA = "none"
		
		//Profile informations
		self.placeOfBirth = ""
		self.birthDate = ""
		self.countryOfBirth = ""
		self.nationality = ""
		self.isUsCitizen = ""
		
		self.address = ""
		self.city = ""
		self.zipCode = ""
		self.country = ""
		
		self.investmentExperience = ""
		self.sourceOfIncome = ""
		self.workIndustry = ""
		self.annualIncome = ""
        self.activityOnLyber = ""
		self.userSigned = false

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
