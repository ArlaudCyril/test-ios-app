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

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppsFlyerLib.shared().appsFlyerDevKey = "G9y3U7W29YR7RSCN6AdBRC"
        AppsFlyerLib.shared().appleAppID = "1609050369"
        //  Set isDebug to true to see AppsFlyer debug logs
        //AppsFlyerLib.shared().isDebug = true
      
        //Optional
        AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 60)
                
        NotificationCenter.default.addObserver(self,
                selector: #selector(didBecomeActiveNotification),
                // For Swift version < 4.2 replace name argument with the commented out code
                name: UIApplication.didBecomeActiveNotification, //.UIApplicationDidBecomeActive for Swift < 4.2
                object: nil)
        
        IQKeyboardManager.shared.enable = true
        UNUserNotificationCenter.current().delegate = self
		SDImageCodersManager.shared.addCoder(SDImageSVGKCoder.shared)
		FirebaseApp.configure()
		Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
		StripeAPI.defaultPublishableKey = "pk_test_51NVVY7F2A3romcuHdC3JDD9evsFhQvyZ5cYS6wpy9OznXgmYzLvWTG81Zfj2nWGQFZ2zs8RboA3uMLCNPpPV08Zk00McUdiPAt"
        
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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
////        guard let url = url {
////            return
////        }
//        let urlStr = url.absoluteString //1
//        // Parse the custom URL as per your uses, this will change as per requirement
//        if urlStr == "com.ever://"{

////            let navController = UINavigationController(rootViewController: vc)
////            navController.navigationBar.isHidden = true
////            window?.rootViewController = navController
////            window?.makeKeyAndVisible()
//    }
//        return true
//    }
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        print("sdjfsk")
//        return true
//    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Lyber")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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


