//
//  SceneDelegate.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import Branch
import SocketIO
import JWTDecode

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    class var shared: SceneDelegate{
        struct singleTon {
            static let instance = SceneDelegate()
        }
        return singleTon.instance
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        self.checkInitialAppSetup()

        Thread.sleep(forTimeInterval: 1.5)
        window?.overrideUserInterfaceStyle = .light
        // workaround for SceneDelegate continueUserActivity not getting called on cold start
        //              if let userActivity = connectionOptions.userActivities.first {
        //                BranchScene.shared().scene(scene, continue: userActivity)
        //              } else if !connectionOptions.urlContexts.isEmpty {
        //                BranchScene.shared().scene(scene, openURLContexts: connectionOptions.urlContexts)
        //              }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
//        SocketIOManager.sharedInstance.establishConnection()
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let urlStr = url.absoluteString
        if urlStr == "com.lyber://"{
            let vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            vc.openFromLink = true
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
        BranchScene.shared().scene(scene, openURLContexts: URLContexts)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }
    
}

extension SceneDelegate{
    func checkInitialAppSetup(){
        userData.shared.getData()
		if(userData.shared.userToken != ""){
			loadingProfileApi()
		}else{
			if(Bundle.main.preferredLocalizations.first == "fr")
			{
				userData.shared.language = "fr"
			}else{
				userData.shared.language = "en"
			}
			userData.shared.dataSave()
			controllerDelegate()
		} 
    }
	
	func loadingProfileApi(){
		ProfileVM().getProfileDataApi(completion: {[]response in
			if let response = response{
				//handle language
				if(response.data?.language == ""){
					if(Bundle.main.preferredLocalizations.first == "fr")
					{
						userData.shared.language = "fr"
					}else{
						userData.shared.language = "en"
					}
				}else{
					userData.shared.language = response.data?.language?.lowercased() ?? ""
				}
				userData.shared.firstname = response.data?.firstName ?? ""
				userData.shared.lastname = response.data?.lastName ?? ""
				userData.shared.has2FA = response.data?.has2FA ?? false
				userData.shared.type2FA = response.data?.type2FA ?? "none"
				userData.shared.phone_no = response.data?.phoneNo ?? ""
				userData.shared.email = response.data?.email ?? ""
				//userData.shared.profile_image = response.data?.profilePic ?? ""
				userData.shared.scope2FALogin = response.data?.scope2FA?.login ?? false
				userData.shared.scope2FAWhiteListing =  response.data?.scope2FA?.whitelisting ?? false
				userData.shared.scope2FAWithdrawal = response.data?.scope2FA?.withdrawal ?? false
				
				userData.shared.dataSave()
				
				self.controllerDelegate()
			}
		})
	}
	
	func controllerDelegate(){
		let path = Bundle.main.path(forResource: userData.shared.language, ofType: "lproj")!
		GlobalVariables.bundle = Bundle(path: path)!
		if(userData.shared.refreshToken == ""){
			let  vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
			let navController = UINavigationController(rootViewController: vc)
			navController.navigationBar.isHidden = true
			window?.rootViewController = navController
			window?.makeKeyAndVisible()
		}else{
			do {
				let refreshToken = try decode(jwt: userData.shared.refreshToken)
				print(refreshToken)
				let exp = refreshToken.body["exp"]
				if (NSDate().timeIntervalSince1970 > exp as! Double) {
					print("Refresh token expired")
					let  vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
					let navController = UINavigationController(rootViewController: vc)
					navController.navigationBar.isHidden = true
					window?.rootViewController = navController
					window?.makeKeyAndVisible()
				}else{
					print("Refresh token not expired")
					if userData.shared.logInPinSet != 0{
						let vc = PinVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Main)
						let navController = UINavigationController(rootViewController: vc)
						navController.navigationBar.isHidden = true
						window?.rootViewController = navController
						window?.makeKeyAndVisible()
					}else if userData.shared.isPhoneVerified == true{
						let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
						let navController = UINavigationController(rootViewController: vc)
						navController.navigationBar.isHidden = true
						window?.rootViewController = navController
						window?.makeKeyAndVisible()
					}
				}
				
				if userData.shared.logInPinSet != 0{
					let vc = PinVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Main)
					let navController = UINavigationController(rootViewController: vc)
					navController.navigationBar.isHidden = true
					window?.rootViewController = navController
					window?.makeKeyAndVisible()
				}else if userData.shared.isPhoneVerified == true{
					let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
					let navController = UINavigationController(rootViewController: vc)
					navController.navigationBar.isHidden = true
					window?.rootViewController = navController
					window?.makeKeyAndVisible()
				}
			} catch {
				print(error)
				
			}
		}
		
	}
}
