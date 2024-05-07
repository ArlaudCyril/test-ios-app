//
//  ResetPasswordVC.swift
//  Lyber
//
//  Created by Lyber on 04/08/2023.
//

import UIKit

class ResetPasswordVC: ViewController {
	//MARK: - Variables
	var token = ""
	
	//MARK: - IB OUTLETS
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var nextBtnView: UIView!
	@IBOutlet var contentView: UIView!
	@IBOutlet var nextButton: PurpleButton!
	@IBOutlet var titleLbl: UILabel!
	@IBOutlet var subtitleLbl: UILabel!
	@IBOutlet var requirementsLbl: UILabel!
	@IBOutlet var passwordTF: UITextField!
	@IBOutlet var passwordVw: UIView!
    @IBOutlet var passwordEyeBtn: UIButton!
	
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
		
		CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "RESET_PASSWORD"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: subtitleLbl, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: subtitleLbl, text: CommonFunctions.localisation(key: "ENTER_NEW_PASSWORD"), lineSpacing: 6, textAlignment: .left)
		CommonUI.setUpLbl(lbl: self.requirementsLbl, text: CommonFunctions.localisation(key: "PASSWORD_REQUIREMENTS"), textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
		self.nextButton.setTitle(CommonFunctions.localisation(key: "SAVE_NEW_PASSWORD"), for: .normal)
		self.nextButton.backgroundColor = UIColor.gray
		self.nextButton.isUserInteractionEnabled = false
		
		CommonUI.setUpViewBorder(vw: self.passwordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
		self.passwordTF.delegate = self
		self.passwordTF.placeholder = CommonFunctions.localisation(key: "ENTER_PASSWORD")
		self.passwordTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
		
        self.passwordEyeBtn.addTarget(self, action: #selector(eyeBtnAct), for: .touchUpInside)
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
		
	}
}

//MARK: - objective functions
extension ResetPasswordVC : UITextFieldDelegate{
	@objc func backBtnAct(){
        CommonFunctions.goHome()	
	}
	
	@objc func nextBtnAct(){
		if(token != ""){
			ResetPasswordVM().resetPasswordIdentifierAPI(token: token, completion: {response in
				if response != nil{
					ResetPasswordVM().resetPasswordApi(token: self.token, email: response?.data.email, phone: response?.data.phoneNo, password: self.passwordTF.text, completion: {response in
						let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
						GlobalVariables.isLogin = true
						self.navigationController?.pushViewController(vc, animated: true)
					})
				}
			})
		}
	}
	
	
	@objc func editChange(_ tf : UITextField){
		if #available(iOS 16.0, *) {
			let pattern = /(?=.*[a-z]+)(?=.*[A-Z]+)(?=.*[^\w]+).{10,}/
			if (passwordTF.text?.firstMatch(of: pattern) != nil)
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
    
    @objc func eyeBtnAct(sender: UIButton){
        self.passwordTF.isSecureTextEntry = !self.passwordTF.isSecureTextEntry
    }
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		CommonUI.setUpViewBorder(vw: self.passwordVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
		return true
	}
}


