//
//  StrongAuthVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit

class StrongAuthVC: SwipeGesture {
    //MARK: - Variables
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var strongAuthLbl: UILabel!
    @IBOutlet var strongAuthDescLbl: UILabel!
    
    @IBOutlet var byGoogleAuthenticatorView: UIView!
    @IBOutlet var byGoogleAuthenticatorLbl: UILabel!
    @IBOutlet var googleAuthenticatorBtn: UIButton!
    @IBOutlet var googleAuthenticatorBtnImg: UIImageView!
    
    @IBOutlet var byEmailView: UIView!
    @IBOutlet var byEmailLbl: UILabel!
    @IBOutlet var toMailLbl: UILabel!
    @IBOutlet var mailBtnImg: UIImageView!
    
    @IBOutlet var bySMSView: UIView!
    @IBOutlet var bySmsLbl: UILabel!
    @IBOutlet var toNumberLbl: UILabel!
    @IBOutlet var smsBtnImg: UIImageView!

    
    @IBOutlet var twoAuthView: UIView!
    @IBOutlet var manageApplicationLbl: UILabel!
    
    @IBOutlet var loginLbl: UILabel!
    @IBOutlet var loginSwitch: UISwitch!
    @IBOutlet var validateWithdrawLbl: UILabel!
    @IBOutlet var validateWithdrawSwitch: UISwitch!
    @IBOutlet var enableWhitelistingLbl: UILabel!
    @IBOutlet var enableWhitelistingSwitch: UISwitch!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.strongAuthLbl, text: CommonFunctions.localisation(key: "STRONG_AUTHENTIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.strongAuthDescLbl, text: CommonFunctions.localisation(key: "ADDED_SECURITY_LYBER_ACCOUNT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        self.strongAuthDescLbl.numberOfLines = 0
        self.strongAuthDescLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //Google Authenticator
        CommonUI.setUpViewBorder(vw: self.byGoogleAuthenticatorView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.byGoogleAuthenticatorLbl, text: CommonFunctions.localisation(key: "GOOGLE_AUTHENTICATOR"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        //Mail
        CommonUI.setUpViewBorder(vw: self.byEmailView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.byEmailLbl, text: CommonFunctions.localisation(key: "BY_EMAIL"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.toMailLbl, text: "\(CommonFunctions.localisation(key: "TO")): \(userData.shared.email)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        //SMS
        CommonUI.setUpViewBorder(vw: self.bySMSView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.bySmsLbl, text: CommonFunctions.localisation(key: "BY_SMS"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.toNumberLbl, text: "\(CommonFunctions.localisation(key: "TO")): +\(userData.shared.phone_no)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        ////Others
        CommonUI.setUpLbl(lbl: self.manageApplicationLbl, text: CommonFunctions.localisation(key: "MANAGE_APPLICATION_CASES_2FA"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.loginLbl, text: CommonFunctions.localisation(key: "LOG_IN"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.validateWithdrawLbl, text: CommonFunctions.localisation(key: "VALIDATE_WITHDRAWAL"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.enableWhitelistingLbl, text: CommonFunctions.localisation(key: "ENABLE_DISABLE_WHITELISTING"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)

		let tapGestureSms = UITapGestureRecognizer(target: self, action: #selector(smsBtnImgAct))
		self.bySMSView.addGestureRecognizer(tapGestureSms)
		
		let tapGestureEmail = UITapGestureRecognizer(target: self, action: #selector(mailBtnImgAct))
		self.byEmailView.addGestureRecognizer(tapGestureEmail)
		
		let tapGestureGoogle = UITapGestureRecognizer(target: self, action: #selector(googleAuthenticatorBtnImgAct))
        self.byGoogleAuthenticatorView.addGestureRecognizer(tapGestureGoogle)
		
        self.loginSwitch.isOn = true
		self.loginSwitch.isUserInteractionEnabled = false
		
        self.validateWithdrawSwitch.addTarget(self, action: #selector(validateWithdrawSwitchAct), for: .touchUpInside)
        self.enableWhitelistingSwitch.addTarget(self, action: #selector(enableWhitelistingSwitchAct), for: .touchUpInside)
        
        //If strong authentified
        adjustViewImgBtn()
        
    }
}

//MARK: - objective functions
extension StrongAuthVC{
    @objc func backBtnAct(){
		self.navigationController?.popViewController(animated: true)

    }
    
    @objc func smsBtnImgAct(){
		if smsBtnImg.isHidden == true{
			if(userData.shared.type2FA == "google")
			{
				self.changeTwoFa(oldWay: userData.shared.type2FA, newWay: "phone")
			}else{
				let details = ["type2FA" : "phone"]
				ConfirmInvestmentVM().userGetOtpApi(action: "type", data: details ,completion: {[weak self]response in
					if response != nil{
						self?.changeTwoFa(oldWay: userData.shared.type2FA, newWay: "phone")
					}
				})
				
			}
        }
    }
    
    @objc func mailBtnImgAct(sender : UISwitch){
		if mailBtnImg.isHidden == true{
			if(userData.shared.type2FA == "google")
			{
				self.changeTwoFa(oldWay: userData.shared.type2FA, newWay: "email")
			}else{
				let details = ["type2FA" : "email"]
				ConfirmInvestmentVM().userGetOtpApi(action: "type", data: details, completion: {[weak self]response in
					if response != nil{
						self?.changeTwoFa(oldWay: userData.shared.type2FA, newWay: "email")
					}
				})
				
			}
		}
    }
    
    @objc func googleAuthenticatorBtnAct(){
        let vc = GoogleAuthenticatorVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func googleAuthenticatorBtnImgAct(){
        //this button is just used for desactivating 2FA
        if (userData.shared.type2FA != "google"){
			googleAuthenticatorBtnAct()
        }
    }
    
    @objc func validateWithdrawSwitchAct(sender : UISwitch){
		var scopes : [String] = []
		if(userData.shared.scope2FAWhiteListing){
			scopes.append("whitelisting")
		}
		// We do a twoFa request only if we desactive a scope
		if(sender.isOn != true){
			let details = ["scope2FA" : scopes]
            if(userData.shared.type2FA == "google"){
                sender.isOn = !sender.isOn
                let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.typeVerification = userData.shared.type2FA
                vc.action = "changeScope"
                vc.scopes = scopes
                vc.verificationCallBack = {[]code in
                    userData.shared.scope2FAWithdrawal = false
                    userData.shared.dataSave()
                    sender.isOn = false
                }
                self.present(vc, animated: true)
            }else{
                ConfirmInvestmentVM().userGetOtpApi(action: "scope", data: details, completion: {[weak self]response in
                    if response != nil{
                        sender.isOn = !sender.isOn
                        let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                        vc.typeVerification = userData.shared.type2FA
                        vc.action = "changeScope"
                        vc.scopes = scopes
                        vc.verificationCallBack = {[]code in
                            userData.shared.scope2FAWithdrawal = false
                            userData.shared.dataSave()
                            sender.isOn = false
                        }
                        self?.present(vc, animated: true)
                    }
                })
            }
		}else{
			//we active
			scopes.append(contentsOf: ["withdrawal"])
			
			StrongAuthVM().scope2FAApi(scopes: scopes, completion: {[]response in
				if response != nil{
					userData.shared.scope2FAWithdrawal = true
					userData.shared.dataSave()
					sender.isOn = true
				}
			},onFailure: {_ in })
		}
    }
    
    @objc func enableWhitelistingSwitchAct(sender : UISwitch){
		var scopes : [String] = []
		if(userData.shared.scope2FAWithdrawal){
			scopes.append("withdrawal")
		}
		// We do a twoFa request only if we desactive a scope
		if(sender.isOn != true){
			let details = ["scope2FA" : scopes]
			ConfirmInvestmentVM().userGetOtpApi(action: "scope", data: details, completion: {[weak self]response in
				if response != nil{
					sender.isOn = !sender.isOn
					let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
					vc.typeVerification = userData.shared.type2FA
					vc.action = "changeScope"
					vc.scopes = scopes
					vc.verificationCallBack = {[]code in
						userData.shared.scope2FAWhiteListing = false
						userData.shared.dataSave()
						sender.isOn = false
					}
					self?.present(vc, animated: true)
				}
			})
		}else{
			//we active
			scopes.append(contentsOf: ["whitelisting"])
			
			StrongAuthVM().scope2FAApi(scopes: scopes, completion: {[]response in
				if response != nil{
					userData.shared.scope2FAWhiteListing = true
					userData.shared.dataSave()
					sender.isOn = true
				}
			}, onFailure: {_ in})
		}
		
    }
}

//MARK: - others functions
extension StrongAuthVC{
    
    func adjustViewImgBtn(){
		googleAuthenticatorBtn.isHidden = false
		googleAuthenticatorBtnImg.isHidden = true
		
		smsBtnImg.isHidden = true
		mailBtnImg.isHidden = true
		
		self.validateWithdrawSwitch.isOn = userData.shared.scope2FAWithdrawal
		self.enableWhitelistingSwitch.isOn = userData.shared.scope2FAWhiteListing
	  
		
		if((userData.shared.type2FA) == "google"){
			googleAuthenticatorBtn.isHidden = true
			googleAuthenticatorBtnImg.isHidden = false
			
		}else if((userData.shared.type2FA) == "phone"){
			smsBtnImg.isHidden = false
			
		}else if((userData.shared.type2FA) == "email"){
			mailBtnImg.isHidden = false
		}
    }
	
	func changeTwoFa(oldWay: String, newWay: String){
		let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		vc.typeVerification = oldWay
		vc.action = "verificationCallback"
		vc.verificationCallBack = {[]code in
			VerificationVM().TwoFAApi(type2FA: newWay, otp: code, completion: {[weak self]response in
				if response != nil{
					userData.shared.has2FA = true
					userData.shared.type2FA = newWay
					userData.shared.dataSave()
					self?.adjustViewImgBtn()
				}
			})
		}
		self.present(vc, animated: true)
	}
}
