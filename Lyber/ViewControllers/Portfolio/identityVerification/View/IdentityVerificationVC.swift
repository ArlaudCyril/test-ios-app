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
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var verificationLbl: UILabel!
    @IBOutlet var verificationDescLbl: UILabel!
    @IBOutlet var disclaimerTitleLbl: UILabel!
    @IBOutlet var disclaimerDescLbl: UILabel!
    
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
        
        
        self.reviewInformationsBtn.setTitle(CommonFunctions.localisation(key: "REVIEW_INFORMATIONS"), for: .normal)
        self.kycBtn.setTitle(CommonFunctions.localisation(key: "START_VERIFICATION"), for: .normal)
        
        self.headerView.closeBtn.addTarget(self, action: #selector(closeBtnAct), for: .touchUpInside)
		
        self.reviewInformationsBtn.addTarget(self, action: #selector(reviewInformationsBtnAct), for: .touchUpInside)
        self.kycBtn.addTarget(self, action: #selector(kycBtnAct), for: .touchUpInside)
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
