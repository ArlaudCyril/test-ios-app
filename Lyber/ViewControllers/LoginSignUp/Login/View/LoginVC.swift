//
//  LoginVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import AVFoundation
import AppsFlyerLib


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
			if(AppConfig.dictEnvVariables["ENV"] as? String == "DEV"){
				if audioSession.outputVolume < audioLevel {
					if(GlobalVariables.baseUrl == ApiEnvironment.Staging.rawValue){
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
	}
	//MARK: - SetUpUI
    override func setUpUI(){
        CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_CRYPTO_FINGERTIPS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: subtitleLbl, text: CommonFunctions.localisation(key: "SIMPLE_SECURE_DIVERSIFIED_INVESTMENT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
		self.subtitleLbl.numberOfLines = 0
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
		if(userData.shared.personalDataStepComplete > 0 && userData.shared.personalDataStepComplete < 3){
			vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}else{
			vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}
        AppsFlyerLib.shared().logEvent(AFEventContentView, withValues: [
          AFEventParamContent: "RegistrationPage",
        ]);
		self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func loginBtnAct(){
		GlobalVariables.isRegistering = false
		GlobalVariables.isLogin = true
        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
	
	@objc func volumeDidChange(_ notification: Notification) {
		// Handle the volume change
		if let audioSession = notification.object as? AVAudioSession {
			let newVolume = audioSession.outputVolume
			print("New volume: \(newVolume)")
		}
	}
}
