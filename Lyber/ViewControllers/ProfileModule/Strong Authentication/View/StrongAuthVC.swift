//
//  StrongAuthVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit

class StrongAuthVC: ViewController {
    //MARK: - Variables
    var switchList : [UISwitch] = []
    
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var strongAuthLbl: UILabel!
    @IBOutlet var strongAuthDescLbl: UILabel!
    
    @IBOutlet var byGoogleAuthenticatorView: UIView!
    @IBOutlet var byGoogleAuthenticatorLbl: UILabel!
    @IBOutlet var googleAuthenticatorBtn: UIButton!
    @IBOutlet var googleAuthenticatorSwitch: UISwitch!
    
    @IBOutlet var byEmailView: UIView!
    @IBOutlet var byEmailLbl: UILabel!
    @IBOutlet var toMailLbl: UILabel!
    @IBOutlet var mailSwitchBtn: UISwitch!
    
    @IBOutlet var bySMSView: UIView!
    @IBOutlet var bySmsLbl: UILabel!
    @IBOutlet var toNumberLbl: UILabel!
    @IBOutlet var smsSwitchBtn: UISwitch!

    
    @IBOutlet var twoAuthView: UIView!
    @IBOutlet var manageApplicationLbl: UILabel!
    
    @IBOutlet var loginLbl: UILabel!
    @IBOutlet var loginSwitch: UISwitch!
    @IBOutlet var validateWithdrawLbl: UILabel!
    @IBOutlet var validateWithdrawSwitch: UISwitch!
    @IBOutlet var enableWhitelistingLbl: UILabel!
    @IBOutlet var enableWhitelistingSwitch: UISwitch!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        switchList = [googleAuthenticatorSwitch,mailSwitchBtn,smsSwitchBtn]
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
        self.smsSwitchBtn.addTarget(self, action: #selector(smsSwitchBtnAct), for: .touchUpInside)
        self.mailSwitchBtn.addTarget(self, action: #selector(mailSwitchBtnAct), for: .touchUpInside)
        self.googleAuthenticatorSwitch.addTarget(self, action: #selector(googleAuthenticatorSwitchAct), for: .touchUpInside)
        self.googleAuthenticatorBtn.addTarget(self, action: #selector(googleAuthenticatorBtnAct), for: .touchUpInside)
        
        self.loginSwitch.addTarget(self, action: #selector(loginSwitchAct), for: .touchUpInside)
        self.validateWithdrawSwitch.addTarget(self, action: #selector(validateWithdrawSwitchAct), for: .touchUpInside)
        self.enableWhitelistingSwitch.addTarget(self, action: #selector(enableWhitelistingSwitchAct), for: .touchUpInside)
        
        //If strong authentified
        adjustViewSwitch()
        
    }
}

//MARK: - objective functions
extension StrongAuthVC{
    @objc func backBtnAct(){
        let vc = ProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    @objc func smsSwitchBtnAct(sender : UISwitch){
        if sender.isOn == true{
            CommonFunctions.showLoader(self.view)
            VerificationVM().TwoFAApi(type2FA: "phone", completion: {[weak self]response in
                CommonFunctions.hideLoader(self?.view ?? UIView())
                if let response = response{
                    userData.shared.has2FA = true
                    userData.shared.type2FA = "phone"
                    userData.shared.dataSave()
                    self?.smsSwitchBtn.isOn = true
                    self?.adjustViewSwitch()
                }
            })
            
        }else {
            desactivateTwoFA()
            smsSwitchBtn.isOn = false
        }
    }
    
    @objc func mailSwitchBtnAct(sender : UISwitch){
        if sender.isOn == true{
            CommonFunctions.showLoader(self.view)
            VerificationVM().TwoFAApi(type2FA: "email", completion: {[weak self]response in
                CommonFunctions.hideLoader(self?.view ?? UIView())
                if let response = response{
                    userData.shared.has2FA = true
                    userData.shared.type2FA = "email"
                    userData.shared.dataSave()
                    self?.adjustViewSwitch()
                }
            })
            
        }else {
            desactivateTwoFA()
        }
    }
    
    @objc func googleAuthenticatorBtnAct(){
        let vc = GoogleAuthenticatorVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func googleAuthenticatorSwitchAct(){
        //this button is just used for desactivating 2FA
        if (userData.shared.type2FA == "otp" && userData.shared.has2FA == true){
            desactivateTwoFA()
            self.googleAuthenticatorSwitch.isOn = false
        }
        else{
            googleAuthenticatorBtnAct()
        }
    }
    
    @objc func loginSwitchAct(sender : UISwitch){
        if (userData.shared.has2FA == true){
            if sender.isOn == true{
                var params = ["login": true,
                              "withdrawal": userData.shared.scope2FAWithdrawal,
                              "whitelisting": userData.shared.scope2FAWhiteListing]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FALogin = true
                        userData.shared.dataSave()
                    }
                })
            }else{
                var params = ["login": false,
                              "withdrawal": userData.shared.scope2FAWithdrawal,
                              "whitelisting": userData.shared.scope2FAWhiteListing]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FALogin = false
                        userData.shared.dataSave()
                    }
                })
            }
        }
    }
    
    @objc func validateWithdrawSwitchAct(sender : UISwitch){
        if (userData.shared.has2FA == true){
            if sender.isOn == true{
                var params = ["login": userData.shared.scope2FALogin,
                              "withdrawal": true,
                              "whitelisting": userData.shared.scope2FAWhiteListing]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FAWithdrawal = true
                        userData.shared.dataSave()
                    }
                })
            }else{
                var params = ["login": userData.shared.scope2FALogin,
                              "withdrawal": false,
                              "whitelisting": userData.shared.scope2FAWhiteListing]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FAWithdrawal = false
                        userData.shared.dataSave()
                    }
                })
            }
        }
    }
    
    @objc func enableWhitelistingSwitchAct(sender : UISwitch){
        if (userData.shared.has2FA == true){
            if sender.isOn == true{
                var params = ["login": userData.shared.scope2FALogin,
                              "withdrawal": userData.shared.scope2FAWithdrawal,
                              "whitelisting": true]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FAWhiteListing = true
                        userData.shared.dataSave()
                    }
                })
            }else{
                var params = ["login": userData.shared.scope2FALogin,
                              "withdrawal": userData.shared.scope2FAWithdrawal,
                              "whitelisting": false]
                
                StrongAuthVM().scope2FAApi(params: params, completion: {[weak self]response in
                    if response != nil{
                        userData.shared.scope2FAWhiteListing = false
                        userData.shared.dataSave()
                    }
                })
            }
        }
    }
}

//MARK: - others functions
extension StrongAuthVC{
    func desactivateTwoFA(){
        VerificationVM().TwoFAApi(type2FA: "none", completion: {[weak self]response in
            if let response = response{
                self?.twoAuthView.isHidden = true
                userData.shared.has2FA = false
                userData.shared.type2FA = "none"
                userData.shared.dataSave()
                self?.adjustViewSwitch()
            }
        })
    }
    
    func adjustViewSwitch(){
        if ((userData.shared.has2FA) == true){
            self.twoAuthView.isHidden = false
            googleAuthenticatorBtn.isHidden = true
            googleAuthenticatorSwitch.isHidden = false
            
            self.loginSwitch.isOn = userData.shared.scope2FALogin
            self.validateWithdrawSwitch.isOn = userData.shared.scope2FAWithdrawal
            self.enableWhitelistingSwitch.isOn = userData.shared.scope2FAWhiteListing
          
            
            if((userData.shared.type2FA) == "otp"){
                googleAuthenticatorSwitch.isOn = true
                
                smsSwitchBtn.isEnabled = false
                smsSwitchBtn.backgroundColor = UIColor(named: "purpleGrey_400")
                smsSwitchBtn.layer.cornerRadius = 16.0
                
                mailSwitchBtn.isEnabled = false
                mailSwitchBtn.backgroundColor = UIColor(named: "purpleGrey_400")
                mailSwitchBtn.layer.cornerRadius = 16.0
            }else if((userData.shared.type2FA) == "phone"){
                smsSwitchBtn.isOn = true
                
                googleAuthenticatorSwitch.isEnabled = false
                googleAuthenticatorSwitch.backgroundColor = UIColor(named: "purpleGrey_400")
                googleAuthenticatorSwitch.layer.cornerRadius = 16.0
                
                mailSwitchBtn.isEnabled = false
                mailSwitchBtn.backgroundColor = UIColor(named: "purpleGrey_400")
                mailSwitchBtn.layer.cornerRadius = 16.0
                
            }else if((userData.shared.type2FA) == "email"){
                mailSwitchBtn.isOn = true
                
                googleAuthenticatorSwitch.isEnabled = false
                googleAuthenticatorSwitch.backgroundColor = UIColor(named: "purpleGrey_400")
                googleAuthenticatorSwitch.layer.cornerRadius = 16.0
                
                smsSwitchBtn.isEnabled = false
                smsSwitchBtn.backgroundColor = UIColor(named: "purpleGrey_400")
                smsSwitchBtn.layer.cornerRadius = 16.0
                
            }
        }else{
            self.twoAuthView.isHidden = true
            googleAuthenticatorSwitch.isHidden = true
            googleAuthenticatorBtn.isHidden = false
            resetAllSwitch()
        }
    }
    
    func resetAllSwitch(){
        for switchElement in switchList{
            switchElement.isEnabled = true
            switchElement.backgroundColor = UIColor.systemBackground
            //switchElement.layer.cornerRadius = 16.0
        }
    }
}
