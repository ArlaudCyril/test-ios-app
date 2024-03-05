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
    
    @IBOutlet var googleAuthenticatorQrCode: UIImageView!
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

        
        CommonUI.setUpButton(btn: googleAuthenticatorBtn, text: CommonFunctions.localisation(key: "TAP_ADD_GOOGLE_AUTHENTICATOR"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
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
//        guard let url = URL(string: self.urlGoogleOTP ?? "") else { return }
//
//        if UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url)
//        } else {
//            let appStoreURL = URL(string: "https://apps.apple.com/us/app/google-authenticator/id388497605")!
//            UIApplication.shared.open(appStoreURL)
//        }
        
        guard let url = URL(string: "otpauth://") else {
            // L'URL scheme n'est pas pris en charge, ce qui signifie que Google Authenticator n'est probablement pas installé
            // Redirigez l'utilisateur vers l'App Store pour télécharger l'application
            if let appStoreURL = URL(string: "https://itunes.apple.com/app/google-authenticator/id388497605") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            // Google Authenticator est installé, ouvrez l'URL pour ajouter le compte
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            // Google Authenticator n'est pas installé, redirigez l'utilisateur vers l'App Store
            if let appStoreURL = URL(string: "https://itunes.apple.com/app/google-authenticator/id388497605") {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
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

