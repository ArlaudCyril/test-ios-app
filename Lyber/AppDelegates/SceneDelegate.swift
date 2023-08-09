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
        if urlStr.hasPrefix("lyber://reset-password"){
			let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
			let token = components?.queryItems?.first(where: { $0.name == "token" })?.value
			let vc = ResetPasswordVC.instantiateFromAppStoryboard(appStoryboard: .Main)
			vc.token = token ?? ""
			let navController = UINavigationController(rootViewController: vc)
			navController.navigationBar.isHidden = true
			window?.rootViewController = navController
			window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }
    
}

extension SceneDelegate{
    func checkInitialAppSetup(){
        userData.shared.getData()
		if(userData.shared.language == ""){
			if(Bundle.main.preferredLocalizations.first == "fr")
			{
				userData.shared.language = "fr"
			}else{
				userData.shared.language = "en"
			}
			userData.shared.dataSave()
		}
		self.controllerDelegate()
    }

	
	func controllerDelegate(){
		let path = Bundle.main.path(forResource: userData.shared.language, ofType: "lproj")!
		GlobalVariables.bundle = Bundle(path: path)!
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
				PinVerificationVM().refreshTokenApi(completion: {[weak self]response in
					if let response = response{
						//print encore server error
						userData.shared.userToken = response.data?.accessToken ?? ""
						userData.shared.refreshToken = response.data?.refreshToken ?? ""
						userData.shared.time = Date()
						userData.shared.dataSave()
						print("current time \(Date())")
						GlobalVariables.isLogin = true
						CommonFunctions.loadingProfileApi()
						if userData.shared.logInPinSet != 0{
							let vc = PinVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Main)
							let navController = UINavigationController(rootViewController: vc)
							navController.navigationBar.isHidden = true
							self?.window?.rootViewController = navController
							self?.window?.makeKeyAndVisible()
						}else{
							let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
							let navController = UINavigationController(rootViewController: vc)
							navController.navigationBar.isHidden = true
							self?.window?.rootViewController = navController
							self?.window?.makeKeyAndVisible()
						}
					}
				})
				
			}
				
		} catch {
			print(error)
			let  vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
			let navController = UINavigationController(rootViewController: vc)
			navController.navigationBar.isHidden = true
			window?.rootViewController = navController
			window?.makeKeyAndVisible()
			
		}
		
		
	}
}
