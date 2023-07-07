//
//  LoginVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import AVFoundation


class LoginVC: ViewController {
	let audioSession = AVAudioSession.sharedInstance()
	private var audioLevel : Float = 0.0
	
    //MARK: - IB OUTLETS
    @IBOutlet var backgroundImgVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var LoginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		do {
			try audioSession.setActive(true, options: [])
			audioSession.addObserver(self, forKeyPath: "outputVolume",
									 options: NSKeyValueObservingOptions.new, context: nil)
			audioLevel = audioSession.outputVolume
		} catch {
			print("Error")
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		audioSession.removeObserver(self, forKeyPath: "outputVolume")
		
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "outputVolume"{
			let audioSession = AVAudioSession.sharedInstance()

			if audioSession.outputVolume < audioLevel {
				if(GlobalVariables.baseUrl == ApiEnvironment.Staging.rawValue){
					CommonFunctions.toster("Environnement changé à : Production")
					GlobalVariables.baseUrl = ApiEnvironment.Production.rawValue
	
				}else if(GlobalVariables.baseUrl == ApiEnvironment.Production.rawValue){
					CommonFunctions.toster("Environnement changé à : Dev")
					GlobalVariables.baseUrl = ApiEnvironment.Dev.rawValue
	
				}else{
					CommonFunctions.toster("Environnement changé à : Staging")
					GlobalVariables.baseUrl = ApiEnvironment.Staging.rawValue
				}
			}
			audioLevel = audioSession.outputVolume
		}
	}
	//MARK: - SetUpUI
    override func setUpUI(){
        CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_REINVENTED"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: subtitleLbl, text: CommonFunctions.localisation(key: "DIVERSIFIED_REGULAR_SIMPLE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
		CommonUI.setUpButton(btn: signUpBtn, text: CommonFunctions.localisation(key: "SIGN_UP"), textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        CommonUI.setUpButton(btn: LoginBtn, text: CommonFunctions.localisation(key: "LOG_IN"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.signUpBtn.addTarget(self, action: #selector(signUpBtnAct), for: .touchUpInside)
        self.LoginBtn.addTarget(self, action: #selector(loginBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension LoginVC{
    @objc func signUpBtnAct(){
		GlobalVariables.isRegistering = true
		GlobalVariables.isLogin = false
		var vc = UIViewController()
		if((userData.shared.is_push_enabled != 0 && userData.shared.personalDataStepComplete == 0) || userData.shared.isPersonalInfoFilled == true){
			vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}else if(userData.shared.personalDataStepComplete > 0){
			vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}else{
			vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		}
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func loginBtnAct(){
		GlobalVariables.isRegistering = false
		GlobalVariables.isLogin = true
        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
	
	@objc func volumeDidChange(_ notification: Notification) {
		// Handle the volume change
		if let audioSession = notification.object as? AVAudioSession {
			let newVolume = audioSession.outputVolume
			print("New volume: \(newVolume)")
		}
	}
}
