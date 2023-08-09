//
//  ForgotPasswordVC.swift
//  Lyber
//
//  Created by Lyber on 03/08/2023.
//

import UIKit
import IQKeyboardManagerSwift

class ForgotPasswordVC: ViewController {
	//MARK: - Variables
	var email = String()
	//MARK: - IB OUTLETS
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var nextBtnView: UIView!
	@IBOutlet var contentView: UIView!
	@IBOutlet var nextButton: PurpleButton!
	@IBOutlet var titleLbl: UILabel!
	@IBOutlet var subtitleLbl: UILabel!
	@IBOutlet var emailTF: UITextField!
	@IBOutlet var emailVw: UIView!
	
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
		
		CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "HAPPENS_EVEN_BEST"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: subtitleLbl, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: subtitleLbl, text: CommonFunctions.localisation(key: "SEND_RESET_LINK_EMAIL_ADDRESS"), lineSpacing: 6, textAlignment: .left)
		
		self.nextButton.setTitle(CommonFunctions.localisation(key: "SEND_RESET_LINK"), for: .normal)
		self.nextButton.backgroundColor = UIColor.gray
		self.nextButton.isUserInteractionEnabled = false
		
		CommonUI.setUpViewBorder(vw: self.emailVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
		self.emailTF.delegate = self
		self.emailTF.placeholder = CommonFunctions.localisation(key: "ENTER_EMAIL_ADDRESS")
		self.emailTF.addTarget(self, action: #selector(editChange), for: .editingChanged)
		
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
		
	}
}

//MARK: - objective functions
extension ForgotPasswordVC : UITextFieldDelegate{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func nextBtnAct(){
		ResetPasswordVM().forgotPasswordAPI(email: self.emailTF.text ?? "", completion: {response in
			if response != nil{
				let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
				vc.confirmationType = .LinkSent
				vc.previousViewController = self
				self.present(vc, animated: true)
			}
		})
	}
	
	
	@objc func editChange(_ tf : UITextField){
		if self.emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && emailTF.text?.isValidEmail() == true{
			self.nextButton.backgroundColor = UIColor.PurpleColor
			self.nextButton.isUserInteractionEnabled = true
		}
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		CommonUI.setUpViewBorder(vw: self.emailVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
		return true
	}
}

//MARK: - Other functions
extension ForgotPasswordVC{

}

