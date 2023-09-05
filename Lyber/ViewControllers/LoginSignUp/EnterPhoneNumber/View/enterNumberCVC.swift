//
//  enterNumberCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import ADCountryPicker
import CountryPickerView
import FlagPhoneNumber

class enterNumberCVC: UICollectionViewCell {
    var controller : EnterPhoneVC?
    var eyeClicked = false
    //MARK: - IB OUTLETS
    @IBOutlet var countryPickerVw: CountryPickerView!
    @IBOutlet var roundView: UIView!
    @IBOutlet var enterNumberLbl: UILabel!
    @IBOutlet var enterNumberDescLbl: UILabel!
    @IBOutlet var countryCodeBtn: UIButton!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var numberView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var eyeBtn: UIButton!
    @IBOutlet var loginByEmailBtn: UIButton!
    @IBOutlet var forgotPasswordBtn: UIButton!
    @IBOutlet var scrollStackVw: UIStackView!
}

//Mark: - SetUpUI
extension enterNumberCVC{
    func setUpUI(){
//        IQKeyboardManager.shared.enableAutoToolbar = false
		self.phoneTF.placeholder = CommonFunctions.localisation(key: "ENTER_PHONE_NUMBER")
		self.passwordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
        CommonUI.setUpLbl(lbl: enterNumberLbl, text: CommonFunctions.localisation(key: "PHONE_NUMBER"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: enterNumberDescLbl, text: CommonFunctions.localisation(key: "ENTER_PHONE_DESCRIPTION"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: enterNumberDescLbl, text: CommonFunctions.localisation(key: "ENTER_PHONE_DESCRIPTION"), lineSpacing: 6, textAlignment: .left)
    
        CommonUI.setUpButton(btn: countryCodeBtn, text: self.controller?.countryCode ?? "", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        self.phoneTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.phoneTF.delegate = self
        self.passwordTF.font = UIFont.MabryPro(Size.Large.sizeValue())
        self.passwordTF.delegate = self
        CommonUI.setUpButton(btn: self.loginByEmailBtn, text: "", textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.loginByEmailBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "LOGIN_EMAIL") ), for: .normal)
		
		CommonUI.setUpButton(btn: self.forgotPasswordBtn, text: "", textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.forgotPasswordBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "FORGOT_PASSWORD") ), for: .normal)
		
        if GlobalVariables.isLogin == true{
            self.loginByEmailBtn.isHidden = false
            self.forgotPasswordBtn.isHidden = false
            self.enterNumberLbl.text = CommonFunctions.localisation(key: "HAPPY_SEE_YOU_BACK")
            self.enterNumberDescLbl.text = CommonFunctions.localisation(key: "ENTER_PHONE_NUMBER_LOGIN")
            self.passwordView.isHidden = false
        }else{
            self.loginByEmailBtn.isHidden = true
            self.forgotPasswordBtn.isHidden = true
            self.passwordView.isHidden = true
            self.passwordTF.isHidden = true
        }
        
        self.phoneTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.passwordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.loginByEmailBtn.addTarget(self, action: #selector(loginByEmailAct), for: .touchUpInside)
		self.forgotPasswordBtn.addTarget(self, action: #selector(forgotPasswordAct), for: .touchUpInside)
        self.eyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
		
        countryPickerVw.delegate = self
        countryPickerVw.dataSource = self
        countryPickerVw.customizeView()
				
    }

}

//MARK: - objective functions
extension enterNumberCVC{
    @objc func editChange(_ tf : UITextField){
        if tf == phoneTF{
            self.controller?.phoneNumber = tf.text ?? ""
        }else if tf == passwordTF{
            self.controller?.password = passwordTF.text ?? ""
        }
        
    }
    
    @objc func loginByEmailAct(){
        let vc = EmailLoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		self.controller?.navigationController?.pushViewController(vc, animated: false)
    }
	
	@objc func forgotPasswordAct(){
        let vc = ForgotPasswordVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        self.controller?.navigationController?.pushViewController(vc, animated: false)
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
}

//MARK: - COUNTRY PICKER DELEGATES
extension enterNumberCVC: CountryPickerViewDelegate,CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.countryCodeBtn.setTitle(country.phoneCode, for: .normal)
        self.controller?.countryCode = country.phoneCode
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?{
        return "Select Country"
    }
}



//MARK: - Text Field Delegates
extension enterNumberCVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTF{
            self.passwordTF.becomeFirstResponder()
        }else if textField == passwordTF{
            self.passwordTF.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == phoneTF{
            return (newString.length <= 15 )
        }
        if textField == passwordTF{
            return (newString.length <= 30 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTF{
            CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTF{
            CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
        if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
            if eyeClicked{
                self.passwordTF.isSecureTextEntry = false
            }else{
                self.passwordTF.isSecureTextEntry = true
            }
        }
    }
    
}
