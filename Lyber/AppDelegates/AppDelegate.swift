//
//  AppDelegate.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Branch
import UserNotifications
import SDWebImage
import SDWebImageSVGKitPlugin
import FirebaseCore
import FirebaseCrashlytics
import StripeApplePay
import AppsFlyerLib
import AppTrackingTransparency
import GooglePlaces
import OSLog

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppsFlyerLib.shared().appsFlyerDevKey = "G9y3U7W29YR7RSCN6AdBRC"
        GMSPlacesClient.provideAPIKey(AppConfig.dictEnvVariables["PLACES_API_KEY"] as? String ?? "AIzaSyAp7c7z5phKb1IkXwJdOrJDGRHMIyr26BE")
        AppsFlyerLib.shared().appleAppID = AppConfig.dictEnvVariables["APPSFLYER_APP_ID"] as? String ?? "1609050369"
        //  Set isDebug to true to see AppsFlyer debug logs
        //AppsFlyerLib.shared().isDebug = true
      
        //Optional
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
                
        NotificationCenter.default.addObserver(self,
                selector: #selector(didBecomeActiveNotification),
                name: UIApplication.didBecomeActiveNotification, object: nil)
        
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
		SDImageCodersManager.shared.addCoder(SDImageSVGKCoder.shared)
		FirebaseApp.configure()
		Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
		StripeAPI.defaultPublishableKey = AppConfig.dictEnvVariables["STRIPE_KEY"] as? String ?? "pk_test_51NVVY7F2A3romcuHdC3JDD9evsFhQvyZ5cYS6wpy9OznXgmYzLvWTG81Zfj2nWGQFZ2zs8RboA3uMLCNPpPV08Zk00McUdiPAt"
        
        return true
    }
    
    @objc func didBecomeActiveNotification() {
        AppsFlyerLib.shared().start()
            if #available(iOS 14, *) {
              ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status {
                case .denied:
                    print("AuthorizationSatus is denied")
                case .notDetermined:
                    print("AuthorizationSatus is notDetermined")
                case .restricted:
                    print("AuthorizationSatus is restricted")
                case .authorized:
                    print("AuthorizationSatus is authorized")
                @unknown default:
                    fatalError("Invalid authorization status")
                }
              }
            }
        }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        userData.shared.is_push_enabled = 2
        userData.shared.dataSave()
    }
    func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        EnterPhoneVM().sendDeviceTokenToServer(deviceToken: deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
        userData.shared.is_push_enabled = 1
        userData.shared.dataSave()
    }
	
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let content = notification.request.content
		print(content)

		if let userInfo = content.userInfo as? [String: Any],
		let acme2 = userInfo["acme2"] as? NSDictionary,
		let lyberId = acme2.object(forKey: "lyberId") as? Int {
			if(lyberId == 2002)
			{//transaction success
				PortfolioDetailVC.transactionFinished(success: true)
			}
			else if(lyberId == 2003){//transaction failure
				PortfolioDetailVC.transactionFinished(success: false)
			}
			else if(lyberId == 2005){//amount
				PortfolioHomeVM().callWalletGetBalanceApi(completion: {[]response in
					if response != nil {
						CommonFunctions.setBalances(balances: response ?? [])
					}
				})
			}
			print(lyberId)
		}

		completionHandler([.alert, .badge, .sound])
	}

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Lyber")
        
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


