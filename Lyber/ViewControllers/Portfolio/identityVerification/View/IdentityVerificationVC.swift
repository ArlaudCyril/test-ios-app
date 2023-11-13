//
//  IdentityVerificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/06/22.
//

import UIKit
import JWTDecode

class IdentityVerificationVC: ViewController {
    //MARK: - Variables
	var urlKyc : String = ""
	var timer: Timer?
	var btnPressed = false
	var isCGUChecked = false
	var isPrivacyChecked = false
	
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var verificationLbl: UILabel!
    @IBOutlet var verificationDescLbl: UILabel!
    @IBOutlet var disclaimerTitleLbl: UILabel!
    @IBOutlet var disclaimerDescLbl: UILabel!
    
	@IBOutlet var labelCGU: UILabel!
    @IBOutlet var checkBoxCGU: UIImageView!
	@IBOutlet var labelPrivacy: UILabel!
    @IBOutlet var checkBoxPrivacy: UIImageView!
    
	@IBOutlet var reviewInformationsBtn: PurpleButton!
    @IBOutlet var kycBtn: PurpleButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
		startKyc()
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkKycStatus), userInfo: nil, repeats: true)
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
		self.headerView.backBtn.isHidden = true
		self.headerView.closeBtn.isHidden = false
        CommonUI.setUpLbl(lbl: self.verificationLbl, text: CommonFunctions.localisation(key: "IDENTITY_VERIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.verificationDescLbl, text: "", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: self.verificationDescLbl, text: CommonFunctions.localisation(key: "FINALISE_REGISTRATION_VERIFY_IDENTITY"), lineSpacing: 4, textAlignment: .left)
		
		CommonUI.setUpLbl(lbl: self.disclaimerTitleLbl, text: CommonFunctions.localisation(key: "DISCLAIMER"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryPro(Size.XXlarge.sizeValue()))
		CommonUI.setUpLbl(lbl: self.disclaimerDescLbl, text:"", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setTextWithLineSpacing(label: self.disclaimerDescLbl, text: CommonFunctions.localisation(key: "INFORMATION_PROVIDED_APPLICATION_NOT_INVESTMENT_ADVICE"), lineSpacing: 4, textAlignment: .left)
        
		let tapGestureCGU = UITapGestureRecognizer(target: self, action: #selector(checkBoxCGUTapped))
		let tapGesturePrivacy = UITapGestureRecognizer(target: self, action: #selector(checkBoxPrivacyTapped))
		
		checkBoxCGU.addGestureRecognizer(tapGestureCGU)
		checkBoxPrivacy.addGestureRecognizer(tapGesturePrivacy)
		
		//labelCGU
		CommonUI.setUpLbl(lbl: self.labelCGU, text: "", textColor: UIColor.PurpleColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.labelCGU.numberOfLines = 0
		
		let attributedTextCGU = NSMutableAttributedString(string: CommonFunctions.localisation(key: "LABEL_CGU_CONDITIONS"))
		
		let underlineRangeCGU = (CommonFunctions.localisation(key: "LABEL_CGU_CONDITIONS") as NSString).range(of: CommonFunctions.localisation(key: "CGU_CONDITIONS"))
		
		attributedTextCGU.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRangeCGU)
		
		self.labelCGU.attributedText = attributedTextCGU
		
		let tapGestureLabelCGU = UITapGestureRecognizer(target: self, action: #selector(labelCGUTapped))
		self.labelCGU.addGestureRecognizer(tapGestureLabelCGU)
		
		//labelPrivacy
		CommonUI.setUpLbl(lbl: self.labelPrivacy, text: "", textColor: UIColor.PurpleColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.labelPrivacy.numberOfLines = 0
		
		let attributedTextPrivacy = NSMutableAttributedString(string: CommonFunctions.localisation(key: "LABEL_PRIVACY_POLICY"))
		
		let underlineRangePrivacy = (CommonFunctions.localisation(key: "LABEL_PRIVACY_POLICY") as NSString).range(of: CommonFunctions.localisation(key: "PRIVACY_POLICY"))
		
		attributedTextPrivacy.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underlineRangePrivacy)
		
		self.labelPrivacy.attributedText = attributedTextPrivacy
		
		let tapGestureLabelPrivacy = UITapGestureRecognizer(target: self, action: #selector(labelPrivacyTapped))
		self.labelPrivacy.addGestureRecognizer(tapGestureLabelPrivacy)
		
		
		//other
        self.reviewInformationsBtn.setTitle(CommonFunctions.localisation(key: "REVIEW_INFORMATIONS"), for: .normal)
        self.kycBtn.setTitle(CommonFunctions.localisation(key: "START_VERIFICATION"), for: .normal)
        
        self.headerView.closeBtn.addTarget(self, action: #selector(closeBtnAct), for: .touchUpInside)
		
        self.reviewInformationsBtn.addTarget(self, action: #selector(reviewInformationsBtnAct), for: .touchUpInside)
        self.kycBtn.addTarget(self, action: #selector(kycBtnAct), for: .touchUpInside)
		
		self.kycBtn.backgroundColor = UIColor.greyDisabled
		self.kycBtn.isUserInteractionEnabled = false
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		timer?.invalidate()
	}
}

//MARK: - objective functions
extension IdentityVerificationVC{
    @objc func closeBtnAct(){
		CommonFunctions.stopRegistration()
    }
    
    @objc func kycBtnAct(){
		self.btnPressed = true
		if(self.urlKyc != ""){
			let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			vc.Ubalurl = self.urlKyc
			self.navigationController?.pushViewController(vc, animated: true)
		}else{
			self.kycBtn.showLoading()
		}
		
    }
	
	@objc func reviewInformationsBtnAct(){
		let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		vc.isEditData = true
		self.navigationController?.pushViewController(vc, animated: false)
    }
	
	@objc func checkKycStatus() {
		if self.urlKyc != "" {
			timer?.invalidate()
			if(self.btnPressed == true){
				self.kycBtn.hideLoading()
				kycBtnAct()
			}
		}
	}
	
	@objc func labelCGUTapped() {
		if let url = URL(string: "https://www.lyber.com/terms-conditions") {
			UIApplication.shared.open(url)
		}
	}
	
	@objc func labelPrivacyTapped() {
		if let url = URL(string: "https://www.lyber.com/privacy") {
			UIApplication.shared.open(url)
		}
	}
	
	@objc func checkBoxCGUTapped() {
		
		self.isCGUChecked = !self.isCGUChecked
		
		if(self.isCGUChecked){
			checkBoxCGU.setImage(Assets.purple_checkbox.image())
		}else{
			checkBoxCGU.setImage(Assets.purple_circle.image())
		}
			
		if(self.isCGUChecked && self.isPrivacyChecked){
			self.kycBtn.backgroundColor = UIColor.purple_500
			self.kycBtn.isUserInteractionEnabled = true
		}else{
			self.kycBtn.backgroundColor = UIColor.greyDisabled
			self.kycBtn.isUserInteractionEnabled = false
		}
	}

	@objc func checkBoxPrivacyTapped() {
		self.isPrivacyChecked = !self.isPrivacyChecked
		
		if(self.isPrivacyChecked){
			checkBoxPrivacy.setImage(Assets.purple_checkbox.image())
		}else{
			checkBoxPrivacy.setImage(Assets.purple_circle.image())
		}
		
		if(self.isCGUChecked && self.isPrivacyChecked){
			self.kycBtn.backgroundColor = UIColor.purple_500
			self.kycBtn.isUserInteractionEnabled = true
		}else{
			self.kycBtn.backgroundColor = UIColor.greyDisabled
			self.kycBtn.isUserInteractionEnabled = false
		}
	}
}

//MARK: - Other functions
extension IdentityVerificationVC{
	func startKyc(){
		IdentityVerificationVM().startKycApi(completion: {response in
			if response != nil {
				self.urlKyc = response?.data?.url ?? ""
			}
		})
	}
}
