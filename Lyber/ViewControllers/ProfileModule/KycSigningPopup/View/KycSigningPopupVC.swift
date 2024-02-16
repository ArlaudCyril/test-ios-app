//
//  KycSigningPopupVC.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 01/02/2024.
//

import UIKit

class KycSigningPopupVC: ViewController {
    //MARK: - Variables
    var type : KycSigningPopupModel = .kyc
    
    //Buy Usdt
    var controller : UIViewController = UIViewController()
    var toAsset : PriceServiceResume = PriceServiceResume()
    
    //certification
    var identityVerificationController : IdentityVerificationVC?
    
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var DescriptionLbl: UILabel!
    
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var actionBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
       
    }

    //MARK: - SetUpUI

    override func setUpUI(){
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        handleTypePopUp()
        
        self.actionBtn.addTarget(self, action: #selector(actionBtnAct), for: .touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let tapp = UITapGestureRecognizer(target: self, action: #selector(outerTapped))
        self.outerView.addGestureRecognizer(tapp)
        
    }
    
}

//MARK: - objective functions
extension KycSigningPopupVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func outerTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func actionBtnAct(){
        switch self.type {
        case .kyc:
            let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            IdentityVerificationVM().startKycApi(headerType: "user", completion: {response in
                if response != nil {
                    vc.kycUrl = response?.data?.url ?? ""
                    vc.revalidation = true
                    let navVC = UINavigationController(rootViewController: vc)
                    UIApplication.shared.windows[0].rootViewController = navVC
                    UIApplication.shared.windows[0].makeKeyAndVisible()
                    navVC.navigationController?.popToRootViewController(animated: true)
                    navVC.setNavigationBarHidden(true , animated: true)
                }
            })
            break
            
        case .signing:
            let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            KycWebVM().getSignUrlApi(completion:{ response in
                if(response != nil){
                    vc.kycUrl = response?.data?.url ?? ""
                    let navVC = UINavigationController(rootViewController: vc)
                    UIApplication.shared.windows[0].rootViewController = navVC
                    UIApplication.shared.windows[0].makeKeyAndVisible()
                    navVC.navigationController?.popToRootViewController(animated: true)
                    navVC.setNavigationBarHidden(true , animated: true)
                    
                }
            })
            break
            
        case .buyUsdt:
            let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.strategyType = .singleCoin
            vc.asset = self.toAsset
            self.controller.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true)
            break
            
        case .certification:
            self.identityVerificationController?.btnPressed = true
            if(self.identityVerificationController?.urlKyc != ""){
                let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                vc.kycUrl = self.identityVerificationController?.urlKyc ?? ""
                self.identityVerificationController?.navigationController?.pushViewController(vc, animated: true)
                self.dismiss(animated: true)
            }else{
                self.actionBtn.showLoading()
            }
            break
        }
    }
}

//MARK: - Other functions
extension KycSigningPopupVC{
    func handleTypePopUp(){
        switch self.type {
        case .kyc:
            CommonUI.setUpLbl(lbl: self.titleLbl, text: CommonFunctions.localisation(key: "VALIDATE_KYC"), textColor: UIColor.PurpleGrey_800, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            self.titleLbl.numberOfLines = 0
            CommonUI.setUpLbl(lbl: self.DescriptionLbl, text: CommonFunctions.localisation(key: "PLEASE_VALIDATE_KYC"), textColor: UIColor.PurpleGrey_600, font: UIFont.MabryPro(Size.Large.sizeValue()))
            self.DescriptionLbl.numberOfLines = 0
            
            CommonUI.setUpButton(btn: self.cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            self.actionBtn.setTitle(CommonFunctions.localisation(key: "VALIDATE_KYC"), for: .normal)
            break
            
        case .signing:
            CommonUI.setUpLbl(lbl: self.titleLbl, text: CommonFunctions.localisation(key: "SIGN_CONTRACT"), textColor: UIColor.PurpleGrey_800, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            self.titleLbl.numberOfLines = 0
            CommonUI.setUpLbl(lbl: self.DescriptionLbl, text: CommonFunctions.localisation(key: "USER_NOT_SIGNED_CONTRACT"), textColor: UIColor.PurpleGrey_600, font: UIFont.MabryPro(Size.Large.sizeValue()))
            self.DescriptionLbl.numberOfLines = 0
            
            CommonUI.setUpButton(btn: self.cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            self.actionBtn.setTitle(CommonFunctions.localisation(key: "SIGN_CONTRACT"), for: .normal)
            break
            
        case .buyUsdt:
            CommonUI.setUpLbl(lbl: self.titleLbl, text: CommonFunctions.localisation(key: "BUY_USDT"), textColor: UIColor.PurpleGrey_800, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            
            CommonUI.setUpLbl(lbl: self.DescriptionLbl, text: CommonFunctions.localisation(key: "INVEST_IN_ASSET_USDT"), textColor: UIColor.PurpleGrey_600, font: UIFont.MabryPro(Size.Large.sizeValue()))
            self.DescriptionLbl.numberOfLines = 0
            
            CommonUI.setUpButton(btn: self.cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            self.actionBtn.setTitle(CommonFunctions.localisation(key: "BUY_USDT"), for: .normal)
            break
            
        case .certification:
            CommonUI.setUpLbl(lbl: self.titleLbl, text: CommonFunctions.localisation(key: "WARNING"), textColor: UIColor.PurpleGrey_800, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            
            CommonUI.setUpLbl(lbl: self.DescriptionLbl, text: CommonFunctions.localisation(key: "CERTIFY_HONOUR_EU"), textColor: UIColor.PurpleGrey_600, font: UIFont.MabryPro(Size.Large.sizeValue()))
            self.DescriptionLbl.numberOfLines = 0
            
            CommonUI.setUpButton(btn: self.cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
            self.actionBtn.setTitle(CommonFunctions.localisation(key: "YES_CERTIFY"), for: .normal)
            break
        }
    }
}
