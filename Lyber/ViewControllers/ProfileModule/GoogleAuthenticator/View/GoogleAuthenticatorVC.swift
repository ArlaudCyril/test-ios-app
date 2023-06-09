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
        
        getGoogleOTPUrl()
    }
    
    @objc func verifyBtnAct(){
        let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.typeVerification = "otpValidation"
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func googleAuthenticatorBtnAct(){
        guard let url = URL(string: self.urlGoogleOTP ?? "") else { return }
        UIApplication.shared.open(url)
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
    
        
}

