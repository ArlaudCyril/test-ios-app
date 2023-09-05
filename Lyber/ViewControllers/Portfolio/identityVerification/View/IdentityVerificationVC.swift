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
        CommonUI.setTextWithLineSpacing(label: self.verificationDescLbl, text: CommonFunctions.localisation(key: "FINALISE_REGISTRATION_VERIFY_IDENTITY"), lineSpacing: 6, textAlignment: .left)
        
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
	
	func finishRegistration(){
		//end of register phase
		PersonalDataVM().finishRegistrationApi(completion: {[weak self]response in
			if response != nil {
				userData.shared.time = Date()
				GlobalVariables.isRegistering = false
				userData.shared.userToken = response?.data?.access_token ?? ""
				userData.shared.refreshToken = response?.data?.refresh_token ?? ""
				userData.shared.dataSave()
				CommonFunctions.loadingProfileApi()
				userData.shared.registered()
				let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				self?.navigationController?.pushViewController(vc, animated: true)
			}else{
				CommonFunctions.toster("KYC didn't work")
			}
		})
	}
}
