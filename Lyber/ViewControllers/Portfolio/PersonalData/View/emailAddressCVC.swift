//
//  emailAddressCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class emailAddressCVC: UICollectionViewCell {
    //MARK: - Variables
    var controller : EnterPhoneVC?
    var eyeClicked = false
    //MARK: - IB OUTLETS
    @IBOutlet var emailAddresslbl: UILabel!
    @IBOutlet var emailAddressDescLbl: UILabel!
    @IBOutlet var enterEmailVw: UIView!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordVw: UIView!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var eyeBtn: UIButton!
    @IBOutlet var requirementsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetUpCell()
    }
}

extension emailAddressCVC{
    func SetUpCell(){
        CommonUI.setUpLbl(lbl: self.emailAddresslbl, text: CommonFunctions.localisation(key: "MAIL_ADDRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.emailAddressDescLbl, text: CommonFunctions.localisation(key: "INFORMATION_USED"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.emailAddressDescLbl, text: CommonFunctions.localisation(key: "INFORMATION_USED"), lineSpacing: 6, textAlignment: .left)
        CommonUI.setUpViewBorder(vw: self.enterEmailVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.passwordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
		
		CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "PASSWORD_REQUIREMENTS"), textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
		requirementsLbl.numberOfLines = 0
		
        
		self.emailTF.placeholder = CommonFunctions.localisation(key: "MAIL_ADDRESS")
        self.emailTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.emailTF.textColor = UIColor.Purple35126D
        self.emailTF.delegate = self
        self.emailTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
		self.passwordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
        self.passwordTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.passwordTF.textColor = UIColor.Purple35126D
		self.passwordTF.isSecureTextEntry = true
        self.passwordTF.delegate = self
        self.passwordTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        self.eyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
    }
}

//MARK: - Text Field Delegates
extension emailAddressCVC: UITextFieldDelegate{
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
            return (newString.length <= 40 )
        }else if textField == passwordTF{
            return (newString.length <= 30 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTF{
            CommonUI.setUpViewBorder(vw: self.enterEmailVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTF{
            CommonUI.setUpViewBorder(vw: self.enterEmailVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == passwordTF{
            CommonUI.setUpViewBorder(vw: self.passwordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
    
}

//MARK: - objective functions
extension emailAddressCVC{
    @objc func editChange(_ tf : UITextField){
        if tf == emailTF{
            self.controller?.email = tf.text ?? ""
        }else if tf == passwordTF{
			self.controller?.emailPassword = tf.text ?? ""
			if #available(iOS 16.0, *) {
				let pattern = /(?=.*[a-z]+)(?=.*[A-Z]+)(?=.*[^\w]+).{10,}/
				if (passwordTF.text?.firstMatch(of: pattern) != nil)
				{
					CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "STRONG_PASSWORD"), textColor: UIColor.Green_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
					controller?.nextButton.isUserInteractionEnabled = true
					controller?.nextButton.backgroundColor = UIColor.PurpleColor
				}else{
					//Disable button
					CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "PASSWORD_REQUIREMENTS"), textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
					controller?.nextButton.isUserInteractionEnabled = false
					controller?.nextButton.backgroundColor = .gray
				}
			}else{
				controller?.nextButton.backgroundColor = UIColor.PurpleColor
				controller?.nextButton.isUserInteractionEnabled = true
			}
        }
        
        
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
