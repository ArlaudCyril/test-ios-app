//
//  EmailLoginCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 04/08/22.
//

import UIKit

class EmailLoginCVC: UICollectionViewCell {
    var controller : EmailLoginVC?
    var eyeClicked = false
    //MARK:- IB OUTLETS
    @IBOutlet var roundView: UIView!
    @IBOutlet var enterEmailLbl: UILabel!
    @IBOutlet var enterEmailDescLbl: UILabel!
    @IBOutlet var emailView: UIView!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var eyeBtn: UIButton!
    @IBOutlet var loginByPhoneBtn: UIButton!
	@IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var scrollStackVw: UIStackView!
}

//Mark: - SetUpUI
extension EmailLoginCVC{
    func setUpUI(){
//        IQKeyboardManager.shared.enableAutoToolbar = false
		
        CommonUI.setUpLbl(lbl: enterEmailLbl, text: CommonFunctions.localisation(key: "HAPPY_SEE_YOU_BACK"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: enterEmailDescLbl, text: CommonFunctions.localisation(key: "ENTER_EMAIL_LOGIN"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.enterEmailDescLbl.numberOfLines = 0
		
        CommonUI.setTextWithLineSpacing(label: enterEmailDescLbl, text: CommonFunctions.localisation(key: "ENTER_EMAIL_LOGIN"), lineSpacing: 6, textAlignment: .left)
		self.emailTF.placeholder = CommonFunctions.localisation(key: "MAIL_ADDRESS")
		self.passwordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
    
       
        CommonUI.setUpViewBorder(vw: self.emailView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        self.emailTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.emailTF.delegate = self
        self.passwordTF.font = UIFont.MabryPro(Size.Large.sizeValue())
        self.passwordTF.delegate = self
        CommonUI.setUpButton(btn: self.loginByPhoneBtn, text: CommonFunctions.localisation(key: "LOGIN_PHONE"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.loginByPhoneBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "LOGIN_PHONE") ), for: .normal)
		
		CommonUI.setUpButton(btn: self.forgotPasswordBtn, text: "", textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.forgotPasswordBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "FORGOT_PASSWORD") ), for: .normal)

        
        self.eyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
        self.emailTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.passwordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.loginByPhoneBtn.addTarget(self, action: #selector(loginByPhoneBtnAct), for: .touchUpInside)
		self.forgotPasswordBtn.addTarget(self, action: #selector(forgotPasswordAct), for: .touchUpInside)
    }
    
    func configureWithData(){
        
    }
}
//MARK: - objective functions
extension EmailLoginCVC{
   
    @objc func editChange(_ tf : UITextField){
        if tf == emailTF{
            self.controller?.email = tf.text ?? ""
        }else if tf == passwordTF{
            self.controller?.password = tf.text ?? ""
        }
       
    }
    
    @objc func loginByPhoneBtnAct(){
        self.controller?.navigationController?.popViewController(animated: false)
    }
    
    @objc func eyeBtnAct(){
        self.eyeClicked = !self.eyeClicked
        if self.eyeClicked{
            self.passwordTF.isSecureTextEntry = false
            self.eyeBtn.setImage(Assets.visibility.image(), for: .normal)
        }else{
            self.passwordTF.isSecureTextEntry = true
            self.eyeBtn.setImage(Assets.visibility_off.image(), for: .normal)
        }
    }
	
	@objc func forgotPasswordAct(){
		let vc = ForgotPasswordVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		self.controller?.navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - Text Field Delegates
extension EmailLoginCVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF{
            self.passwordTF.becomeFirstResponder()
        }else if textField == passwordTF{
            self.passwordTF.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == emailTF{
            return (newString.length <= 70 )
        }else if textField == passwordTF{
            return (newString.length <= 30 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTF{
            CommonUI.setUpViewBorder(vw: self.emailView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF{
            CommonUI.setUpViewBorder(vw: self.emailView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
            if eyeClicked{
                self.passwordTF.isSecureTextEntry = false
            }else{
                self.passwordTF.isSecureTextEntry = true
            }
        }
    }
    
}
