//
//  ChangePasswordVC.swift
//  Lyber
//
//  Created by Lyber on 02/11/2023.
//

import Foundation
import UIKit

class ChangePasswordVC: ViewController {
	//MARK: - Variables
	var token = ""
	let changePasswordVM = ChangePasswordVM()
	
	//MARK: - IB OUTLETS
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var nextBtnView: UIView!
	@IBOutlet var contentView: UIView!
	@IBOutlet var nextButton: PurpleButton!
	@IBOutlet var titleLbl: UILabel!
	@IBOutlet var requirementsLbl: UILabel!
	
	
	@IBOutlet var oldPasswordTitle: UILabel!
	@IBOutlet var oldPasswordTF: UITextField!
	@IBOutlet var oldPasswordVw: UIView!
    @IBOutlet var oldPasswordEyeBtn: UIButton!
	
	@IBOutlet var newPasswordTitle: UILabel!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var newPasswordVw: UIView!
    @IBOutlet var newPasswordEyeBtn: UIButton!
    
    @IBOutlet var confirmNewPasswordTitle: UILabel!
	@IBOutlet var confirmNewPasswordTF: UITextField!
	@IBOutlet var confirmNewPasswordVw: UIView!
    @IBOutlet var confirmNewPasswordEyeBtn: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.isHidden = true
		setUpUI()
	}
	//MARK: - SetUpUI
	
	override func setUpUI(){
		self.headerView.headerLbl.isHidden = true
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
		self.contentView.layer.cornerRadius = 32
		self.contentView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		
		CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "CHANGE_PASSWORD"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: oldPasswordTitle, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: oldPasswordTitle, text: CommonFunctions.localisation(key: "ENTER_OLD_PASSWORD"), lineSpacing: 6, textAlignment: .left)
		
		CommonUI.setUpLbl(lbl: newPasswordTitle, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: newPasswordTitle, text: CommonFunctions.localisation(key: "ENTER_NEW_PASSWORD"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: confirmNewPasswordTitle, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: confirmNewPasswordTitle, text: CommonFunctions.localisation(key: "CONFIRM_NEW_PASSWORD"), lineSpacing: 6, textAlignment: .left)
		
		CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "PASSWORD_REQUIREMENTS"), textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
		self.nextButton.setTitle(CommonFunctions.localisation(key: "SAVE_NEW_PASSWORD"), for: .normal)
		self.nextButton.backgroundColor = UIColor.gray
		self.nextButton.isUserInteractionEnabled = false
		
		CommonUI.setUpViewBorder(vw: self.oldPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
		
		CommonUI.setUpViewBorder(vw: self.newPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        
        CommonUI.setUpViewBorder(vw: self.confirmNewPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
		
		//oldPasswordTF configuration
		self.oldPasswordTF.delegate = self
		self.oldPasswordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
		self.oldPasswordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.oldPasswordEyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
		
		//newPasswordTF configuration
        self.newPasswordTF.delegate = self
        self.newPasswordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
        self.newPasswordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.newPasswordEyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
        self.newPasswordTF.isUserInteractionEnabled = true
        
        //confirmNewPasswordTF configuration
		self.confirmNewPasswordTF.delegate = self
		self.confirmNewPasswordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
		self.confirmNewPasswordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
        self.confirmNewPasswordEyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
		
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
		
	}
}

//MARK: - objective functions
extension ChangePasswordVC : UITextFieldDelegate{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: true)
	}

	@objc func nextBtnAct(){
		if(oldPasswordTF.text == newPasswordTF.text){
            CommonFunctions.toster(CommonFunctions.localisation(key: "NEW_PASSWORD_CANNOT_SAME"))
        }else if(newPasswordTF.text != confirmNewPasswordTF.text){
			CommonFunctions.toster(CommonFunctions.localisation(key: "NEW_PASSWORD_MUST_BE_SAME"))
		}else{
			changePasswordVM.passwordChangeChallengeAPI( completion: {response in
				if response != nil{
                    let bData = response?.data?.b ?? ""
                    let saltData = response?.data?.salt ?? ""
					self.changePasswordVM.setNewPasswordAPI(b: bData, salt: saltData, oldPassword: self.oldPasswordTF.text ?? "", newPassword: self.newPasswordTF.text ?? "", completion: {response in
                        if response != nil {
                            let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                            vc.typeVerification = "email"
                            vc.action = "setNewPassword"
                            vc.controller = self
                            vc.resendClosure = {[weak self] in
                                self?.changePasswordVM.setNewPasswordAPI(b: bData, salt: saltData, oldPassword: self?.oldPasswordTF.text ?? "", newPassword: self?.newPasswordTF.text ?? "", completion: {_ in})
                            }
                            self.present(vc, animated: true)
                        }
					})
				}
			})
		}
	}
	
	
	@objc func editChange(_ tf : UITextField){
		if #available(iOS 16.0, *) {
			let pattern = /(?=.*[a-z]+)(?=.*[A-Z]+)(?=.*[^\w]+).{10,}/
			if (newPasswordTF.text?.firstMatch(of: pattern) != nil)
			{
				CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "STRONG_PASSWORD"), textColor: UIColor.Green_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
				self.nextButton.backgroundColor = UIColor.PurpleColor
				self.nextButton.isUserInteractionEnabled = true
			}else{
				CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "PASSWORD_REQUIREMENTS"), textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
				self.nextButton.isUserInteractionEnabled = false
				self.nextButton.backgroundColor = .gray
			}
		}else{
			self.nextButton.backgroundColor = UIColor.PurpleColor
			self.nextButton.isUserInteractionEnabled = true
		}
		
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if textField == oldPasswordTF{
			CommonUI.setUpViewBorder(vw: self.oldPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
		}else if textField == newPasswordTF{
			CommonUI.setUpViewBorder(vw: self.newPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else{
            CommonUI.setUpViewBorder(vw: self.confirmNewPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
		return true
	}
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == oldPasswordTF{
            CommonUI.setUpViewBorder(vw: self.oldPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == newPasswordTF{
            CommonUI.setUpViewBorder(vw: self.newPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else{
            CommonUI.setUpViewBorder(vw: self.confirmNewPasswordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @objc func eyeBtnAct(sender: UIButton){
        switch sender{
        case oldPasswordEyeBtn:
            self.oldPasswordTF.isSecureTextEntry = !self.oldPasswordTF.isSecureTextEntry
            self.oldPasswordTF.isSecureTextEntry ? self.oldPasswordEyeBtn.setImage(Assets.visibility_off.image(), for: .normal) : self.oldPasswordEyeBtn.setImage(Assets.visibility.image(), for: .normal)
            break
        case newPasswordEyeBtn:
            self.newPasswordTF.isSecureTextEntry = !self.newPasswordTF.isSecureTextEntry
            self.newPasswordTF.isSecureTextEntry ? self.newPasswordEyeBtn.setImage(Assets.visibility_off.image(), for: .normal) : self.newPasswordEyeBtn.setImage(Assets.visibility.image(), for: .normal)
            break
        case confirmNewPasswordEyeBtn:
            self.confirmNewPasswordTF.isSecureTextEntry = !self.confirmNewPasswordTF.isSecureTextEntry
            self.confirmNewPasswordTF.isSecureTextEntry ? self.confirmNewPasswordEyeBtn.setImage(Assets.visibility_off.image(), for: .normal) : self.confirmNewPasswordEyeBtn.setImage(Assets.visibility.image(), for: .normal)
            break
        default:
            break
        }
    }
}


