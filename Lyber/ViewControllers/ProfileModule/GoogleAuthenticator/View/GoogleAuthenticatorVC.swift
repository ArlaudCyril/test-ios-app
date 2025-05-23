//
//  GoogleAuthenticatorVC.swift
//  Lyber
//
//  Created by Lyber on 03/03/2023.
//

import Foundation
import UIKit
import SwiftUI

//MARK: - Initialisation
class GoogleAuthenticatorVC : SwipeGesture {
    
    //MARK: - Variables
    var urlGoogleOTP: String?
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var twoFactorLbl: UILabel!
    @IBOutlet var twoFactorDescLbl: UILabel!
    
    @IBOutlet var googleAuthenticatorQrCodeLbl: UILabel!
    @IBOutlet var googleAuthenticatorQrCode: UIImageView!
    
    @IBOutlet var googleAuthenticatorBtnLbl: UILabel!
    @IBOutlet var googleAuthenticatorBtn: UIButton!
    @IBOutlet var verifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


	//MARK: - Functions
    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: self.twoFactorLbl, text: CommonFunctions.localisation(key: "TWO_FA"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.twoFactorDescLbl, text: CommonFunctions.localisation(key: "ADD_GOOGLE_AUTHENTICATOR"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        self.twoFactorDescLbl.numberOfLines = 0
        
        CommonUI.setUpLbl(lbl: self.googleAuthenticatorQrCodeLbl, text: CommonFunctions.localisation(key: "SCAN_QR_CODE_CONFIGURE_ACCOUNT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.googleAuthenticatorBtnLbl, text: CommonFunctions.localisation(key: "ADD_GOOGLE_AUTHENTICATOR_MANUALLY"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpButton(btn: googleAuthenticatorBtn, text: CommonFunctions.localisation(key: "COPY_KEY"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.verifyBtn.setTitle(CommonFunctions.localisation(key: "VERIFY"), for: .normal)
        
        self.verifyBtn.addTarget(self, action: #selector(verifyBtnAct), for: .touchUpInside)
        self.googleAuthenticatorBtn.addTarget(self, action: #selector(googleAuthenticatorBtnAct), for: .touchUpInside)
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.showPopUp()
        getGoogleOTPUrl()
    }
    
    @objc func verifyBtnAct(){
		let details = ["type2FA" : "google"]
		ConfirmInvestmentVM().userGetOtpApi(action: "type", data: details, completion: {[weak self]response in
			if response != nil{
				let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				vc.typeVerification = "google"
				vc.controller = self
				vc.action = "otpValidation"
				self?.present(vc, animated: true, completion: nil)
			}
		})
        
    }
    
    @objc func googleAuthenticatorBtnAct(){
        guard let url = URL(string: self.urlGoogleOTP ?? ""),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let queryItems = components.queryItems else {
                return
            }
            
        let secretValue = queryItems.first(where: { $0.name == "secret" })?.value
        
        UIPasteboard.general.string = secretValue
        CommonFunctions.toster(CommonFunctions.localisation(key: "COPIED"))
    }
    
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func generateQRCode(string: String)->UIImage?{
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator"){
            filter.setValue(data, forKey: "inputMessage")
            
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            if let output = filter.outputImage?.transformed(by: transform)
            {
                return UIImage(ciImage: output)
                
            }
            
        }
        return nil
    }
    
    func getGoogleOTPUrl()
    {
        GoogleAuthenticatorVM().getGoogleOTPUrlApi(completion: {[]response in
            if let response = response{
                //Generating QR code
                self.googleAuthenticatorQrCode.image = self.generateQRCode(string:response.data?.url ?? "")
                self.urlGoogleOTP = response.data?.url
            }
        })
    }
    func showPopUp(){
        let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.type = .googleAuthenticator
        self.present(vc, animated: false)
    }
}

