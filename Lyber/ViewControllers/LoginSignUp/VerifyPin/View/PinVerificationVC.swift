//
//  PinVerificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 08/07/22.
//

import UIKit
import LocalAuthentication

class PinVerificationVC: ViewController {
    var pinCreatedDelegate : ((String)->())?
    var enterDigitCounts : Int! = 0
    var tryNumber : Int! = 0
	var pins : [otpTextField] = []
    
    //MARK:- IB OUTLETS
	@IBOutlet var logOutBtn: UIButton!
    @IBOutlet var enterYourPinLbl: UILabel!
    @IBOutlet var pinTF1: otpTextField!
    @IBOutlet var pinTF2: otpTextField!
    @IBOutlet var pinTF3: otpTextField!
    @IBOutlet var pinTF4: otpTextField!
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var useFaceIdVw: UIView!
    @IBOutlet var useFaceIdLbl: UILabel!
    @IBOutlet var key1: UIButton!
    @IBOutlet var key2: UIButton!
    @IBOutlet var key3: UIButton!
    @IBOutlet var key4: UIButton!
    @IBOutlet var key5: UIButton!
    @IBOutlet var key6: UIButton!
    @IBOutlet var key7: UIButton!
    @IBOutlet var key8: UIButton!
    @IBOutlet var key9: UIButton!
    @IBOutlet var key0: UIButton!
    @IBOutlet var keyCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

	//MARK: - SetUpUI

    override func setUpUI(){
		pins = [pinTF1,pinTF2,pinTF3,pinTF4]
		
		CommonUI.setUpButton(btn: self.logOutBtn, text: CommonFunctions.localisation(key: "LOG_OUT"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProBold(Size.Medium.sizeValue()))
		self.logOutBtn.addTarget(self, action: #selector(LogOutAct), for: .touchUpInside)
		
        CommonUI.setUpLbl(lbl: self.enterYourPinLbl, text: CommonFunctions.localisation(key: "ENTER_PIN"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.XXlarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.orLbl, text: CommonFunctions.localisation(key: "OR"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        self.useFaceIdVw.layer.cornerRadius = 8
//        self.useBiometricVw.backgroundColor = UIColor.borderColor
        CommonUI.setUpLbl(lbl: self.useFaceIdLbl, text: CommonFunctions.localisation(key: "USE_FACE_ID"), textColor: UIColor.PurpleColor, font: UIFont.AtypDisplayRegular(Size.Large.sizeValue()))
        
        
		for pin in self.pins{
            pin.textColor = UIColor.PurpleColor
//            pin.otpDelegate = self
            pin.layer.cornerRadius = (pin.layer.bounds.width )/2
        }
        
        let btnKeys : [UIButton] = [key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,keyCancel]
        for (index,key) in btnKeys.enumerated(){
            CommonUI.setUpButton(btn: key , text: "\(index)", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
            if index == 10 {
                key.setTitle("", for: .normal)
            }else if index == 11{
                key.setTitle("", for: .normal)
            }
            key.tag = index
            key.addTarget(self, action: #selector(keyTyped), for: .touchUpInside)
        }
		
		//Face Id
		let localAuthenticationContext = LAContext()
		localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
		let authType = localAuthenticationContext.biometryType
		
		if(authType != .faceID){
			userData.shared.faceIdEnabled = false
			userData.shared.dataSave()
		}
			
		
		
		if(userData.shared.faceIdEnabled == true){
			let biometricTap = UITapGestureRecognizer(target: self, action: #selector(authenticationWithTouchID))
			self.useFaceIdVw.addGestureRecognizer(biometricTap)
			authenticationWithTouchID()
		}else{
			self.useFaceIdVw.isHidden = true
			self.orLbl.isHidden = true
		}
		
        
    }
}

//MARK:- objective functions
extension PinVerificationVC{
    @objc func keyTyped(sender : UIButton){
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9,0:
            print("typed ",sender.tag)
            if enterDigitCounts == 0{
                self.pinTF1.backgroundColor = UIColor.PurpleColor
                self.pinTF1.text = "\(sender.tag)"
                self.enterDigitCounts = self.enterDigitCounts + 1
            }else if enterDigitCounts == 1{
                self.pinTF2.backgroundColor = UIColor.PurpleColor
                self.pinTF2.text = "\(sender.tag)"
                self.enterDigitCounts = self.enterDigitCounts + 1
            }else if enterDigitCounts == 2{
                self.pinTF3.backgroundColor = UIColor.PurpleColor
                self.pinTF3.text = "\(sender.tag)"
                self.enterDigitCounts = self.enterDigitCounts + 1
            }else if enterDigitCounts == 3{
                self.pinTF4.backgroundColor = UIColor.PurpleColor
                self.pinTF4.text = "\(sender.tag)"
                self.enterDigitCounts = self.enterDigitCounts + 1
                let enteredPin = "\(self.pinTF1.text ?? "")\(self.pinTF2.text ?? "")\(self.pinTF3.text ?? "")\(self.pinTF4.text ?? "")"
                if userData.shared.logInPinSet == Int(enteredPin){
                    print("Verified")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.GoToScreen()
                    })
                    
                    
                }else{
					resetPin()
                    if(self.tryNumber == 3)
                    {
                        userData.shared.logInPinSet = 0
                        userData.shared.dataSave()
                        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
						GlobalVariables.isLogin = true
                        let nav = UINavigationController(rootViewController: vc)
                        CommonFunctions.toster(Constants.AlertMessages.tooManyFailedAttemptPleaseReauthenticate)
                        nav.modalPresentationStyle = .fullScreen
                        nav.navigationBar.isHidden = true
                        self.present(nav, animated: true, completion: nil)
                        
                    
                    }else{
                        self.tryNumber+=1
                        CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
                    }
                    
                }
            }
            break
        case 10:
            print("typed ",sender.tag)
            if enterDigitCounts >= 1{
                if enterDigitCounts == 4{
                    self.pinTF4.text = ""
                    self.pinTF4.backgroundColor = UIColor.borderColor
                }else if enterDigitCounts == 3{
                    self.pinTF3.text = ""
                    self.pinTF3.backgroundColor = UIColor.borderColor
                }else if enterDigitCounts == 2{
                    self.pinTF2.text = ""
                    self.pinTF2.backgroundColor = UIColor.borderColor
                }else if enterDigitCounts == 1{
                    self.pinTF1.text = ""
                    self.pinTF1.backgroundColor = UIColor.borderColor
                }
                self.enterDigitCounts = self.enterDigitCounts - 1
            }
            break
       
        default:
            break
        }
    }
    
    @objc func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"

        var authError: NSError?
        let reasonString = "To access the secure data"
        logMessage("Lauching face id")
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        self.GoToScreen()
                    }
                } else {
                    // Log the error from the evaluation process
                    if let evalError = evaluateError as NSError? {
                        self.logMessage("Authentication failed: \(self.evaluateAuthenticationPolicyMessageForLA(code: evalError.code))")
                    }
                }
            }
        } else {
            // The device cannot use biometric authentication
            if let error = authError {
                logMessage("Biometric authentication is not available on this device. Reason: \(self.evaluateAuthenticationPolicyMessageForLA(code: error.code))")
                // Additional logging to understand why biometrics are not available
                switch error.code {
                case LAError.biometryNotAvailable.rawValue:
                    logMessage("Biometrics are not available on this device.")
                case LAError.biometryNotEnrolled.rawValue:
                    logMessage("Biometrics are not enrolled on this device.")
                case LAError.biometryLockout.rawValue:
                    logMessage("Biometrics are locked out due to too many failed attempts.")
                default:
                    logMessage("An unknown error occurred with biometrics.")
                }
            } else {
                logMessage("Failed to retrieve any specific error regarding biometrics.")
            }
        }
    }
	
	@objc func LogOutAct(){
		CommonFunctions.logout()
	}
    
	
	//MARK: Other functions
	
    func evaluatePolicyFailErrorMessageForLA(code: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch code {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch code {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(code: Int) -> String {
        var message = ""
        switch code {
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(code: code)
        }
        
        return message
    }
    
    func GoToScreen(){
        var vc = ViewController()
        
		if userData.shared.stepRegisteringComplete < 2 && GlobalVariables.isRegistering == true{
			vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}else{
			 vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}
		self.navigationController?.pushViewController(vc, animated: true)

    }
	
	func resetPin(){
		enterDigitCounts = 0
		for pin in self.pins{
			pin.text = ""
			pin.backgroundColor = UIColor.borderColor
		}
	}
}
