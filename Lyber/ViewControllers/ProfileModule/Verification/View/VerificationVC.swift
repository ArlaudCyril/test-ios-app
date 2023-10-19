//
//  VerificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//
import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftUI

final class VerificationVC: ViewController,MyTextFieldDelegate {
    //MARK: - Variables
    var typeVerification : String?
	var action : String?
	var dataWithdrawal : [String : Any]?
	var controller : ViewController?
	var enterPhoneController : EnterPhoneVC?
	var verificationCallBack : ((String)->())?
	var scopes : [String] = []
    
    //MARK: - IB OUTLETS
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var verificationLbl: UILabel!
    @IBOutlet var enterCodeLbl: UILabel!

    @IBOutlet var Tf1: otpTextField!
    @IBOutlet var Tf2: otpTextField!
    @IBOutlet var Tf3: otpTextField!
    @IBOutlet var Tf4: otpTextField!
    @IBOutlet var Tf5: otpTextField!
    @IBOutlet var Tf6: otpTextField!
    @IBOutlet var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        Tf1.becomeFirstResponder()
    }


	//MARK: - SetUpUI
    override func setUpUI(){
		IQKeyboardManager.shared.enableAutoToolbar = false
        switch typeVerification {
            case "google":
                CommonUI.setUpLbl(lbl: enterCodeLbl, text: CommonFunctions.localisation(key: "ENTER_CODE_DISPLAYED_GOOGLE_AUTHENTICATOR"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
            case "phone":
                CommonUI.setUpLbl(lbl: enterCodeLbl, text: CommonFunctions.localisation(key: "ENTER_CODE_RECEIVED_SMS"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
            case "email":
                CommonUI.setUpLbl(lbl: enterCodeLbl, text: CommonFunctions.localisation(key: "ENTER_CODE_RECEIVED_EMAIL"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
            default:
                print("Unsupported 2FA method")
        }
        containerView.layer.cornerRadius = 32;
		self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true
        
        CommonUI.setUpLbl(lbl: verificationLbl, text: CommonFunctions.localisation(key: "VERIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))

        let tfs : [otpTextField] = [Tf1,Tf2,Tf3, Tf4, Tf5, Tf6]
        for tf in tfs {
            tf.delegate = self
            tf.otpDelegate = self
            tf.font = UIFont.MabryProMedium(Size.Large.sizeValue())
            CommonUI.setUpViewBorder(vw: tf, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor)
        }
        CommonUI.setUpButton(btn: backBtn, text: CommonFunctions.localisation(key: "BACK"), textcolor: UIColor.SecondarytextColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        
    }

}

//MARK: - Text Field Delegates
extension VerificationVC: UITextFieldDelegate{
    
    func textFieldDidDelete(_ tf: UITextField) {
        switch tf {
        case Tf1:
            Tf1.resignFirstResponder()
        case Tf2:
            Tf1.becomeFirstResponder()
        case Tf3:
            Tf2.becomeFirstResponder()
        case Tf4:
            Tf3.becomeFirstResponder()
        case Tf5:
            Tf4.becomeFirstResponder()
        case Tf6:
            Tf5.becomeFirstResponder()
            
        default:
            print("error")
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let maxLength = 1
            if string.count == 1{
                textField.text = string
                if Tf1 == textField{
                    Tf2.becomeFirstResponder()
                }else if Tf2 == textField{
                    Tf3.becomeFirstResponder()
                }else if Tf3 == textField{
                    Tf4.becomeFirstResponder()
                }else if Tf4 == textField{
                    Tf5.becomeFirstResponder()
                }else if Tf5 == textField{
                    Tf6.becomeFirstResponder()
                }else if Tf6 == textField{
                    Tf6.resignFirstResponder()
                }
                if Tf1.text != "" && Tf2.text != "" && Tf3.text != "" && Tf4.text != "" && Tf5.text != "" && Tf6.text != ""{

                    self.verifyCode(code: "\(Tf1.text ?? "")\(Tf2.text ?? "")\(Tf3.text ?? "")\(Tf4.text ?? "")\(Tf5.text ?? "")\(Tf6.text ?? "")")
					let tfs = [Tf1,Tf2,Tf3,Tf4,Tf5,Tf6]
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
						for tf in tfs{
							tf?.text = ""
						}
						self.Tf1.becomeFirstResponder()
					})
                }
            }

        return newString.length <= maxLength
    }
}

//MARK: - Other functions
extension VerificationVC{

    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func verifyCode(code: String)
    {
        if(self.action == "otpValidation"){//code ici google authenticator
			let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
			vc.typeVerification = userData.shared.type2FA
			vc.action = "verificationCallback"
			vc.verificationCallBack = {[]codeOtp in
				VerificationVM().TwoFAApi(type2FA: "google", otp: codeOtp, googleOtp: code, completion: {[weak self]response in
					if response != nil{
						userData.shared.has2FA = true
						userData.shared.type2FA = "google"
						userData.shared.dataSave()
						self?.dismiss(animated: true)
						self?.controller?.navigationController?.popToViewController(ofClass: StrongAuthVC.self)
					}
				})
			}
			self.present(vc, animated: true)

		}else if(self.action == "withdraw"){
			VerificationVM().walletCreateWithdrawalRequest(otp: code, data: dataWithdrawal ?? [:], onSuccess:{[]response in
                if response != nil{
					self.dismiss(animated: true)
					CommonFunctions.callWalletGetBalance()
					let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
					vc.confirmationType = .Withdraw
					vc.previousViewController = self.controller
					self.controller?.present(vc, animated: true)

				}
			}, onFailure: {[]response in
				if response != nil{
					if(response?.code != "24"){
						self.dismiss(animated: true)
						self.controller?.navigationController?.popViewController(animated: true)
					}
				}
			})
        }else if(self.action == "changeScope"){
			StrongAuthVM().scope2FAApi(scopes: scopes, otp: code, completion: {[]response in
				if response != nil{
					self.dismiss(animated: true)
					self.verificationCallBack?(code)
				}
				
			}, onFailure: {[]response in
				if response != nil{
					if(response?.code != "24"){
						self.dismiss(animated: true)
					}
				}
			})
        }else if(self.action == "signup"){
			EnterPhoneVM().enterOTPApi(otp: code, completion: {[weak self]response in
				if let response = response{
					print(response)
					userData.shared.enterPhoneStepComplete = 1
					userData.shared.dataSave()
					self?.dismiss(animated: true)
					let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
					self?.controller?.navigationController?.pushViewController(vc, animated: true)
				}
			})
        }else if(self.action == "signup_email"){
			CommonFunctions.showLoader(self.view)
			PersonalDataVM().checkEmailVerificationApi(controller: self, code: code , completion: {[self]response in
				CommonFunctions.hideLoader(self.view)
				if (response != nil){
					userData.shared.enterPhoneStepComplete = 2
					userData.shared.dataSave()
					self.dismiss(animated: true)
					self.enterPhoneController?.GotoNextIndex()
				}
			})
        }else if(self.action == "verificationCallback"){
			self.dismiss(animated: true)
			self.verificationCallBack?(code)
        }else{
            VerificationVM().verify2FAApi(code: code, completion: {[]response in
                if response != nil{
                    userData.shared.userToken = response?.data?.accessToken ?? ""
                    userData.shared.refreshToken = response?.data?.refreshToken ?? ""
                    userData.shared.time = Date()
                    userData.shared.dataSave()
					self.dismiss(animated: true)
                    let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
					vc.isDoubleAuthentified = true
					self.controller?.navigationController?.pushViewController(vc, animated: true)

                }
            })
        }
        
    }

}

