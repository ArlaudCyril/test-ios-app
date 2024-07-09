//
//  VerificationKycSigningTVC.swift
//  Lyber
//
//  Created by Elie Boyrivent on 05/02/2024.
//

import Foundation
import UIKit

class VerificationKycSigningTVC: UITableViewCell {
    //MARK: - Variables
    var statusKyc: VerificationIndicator?
    var statusSigning: VerificationIndicator?
    var portolioHomeVC: PortfolioHomeVC?
    
    //MARK:- IB OUTLETS
    @IBOutlet var verificationKycVw: UIView!
    @IBOutlet var indicatorKycImgVw: UIImageView!
    @IBOutlet var rightArrowKycImgVw: UIImageView!
    @IBOutlet var kycLbl: UILabel!
    
    @IBOutlet var verificationSigningVw: UIView!
    @IBOutlet var indicatorSigningImgVw: UIImageView!
    @IBOutlet var rightArrowSigningImgVw: UIImageView!
    @IBOutlet var signingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


//Mark:- SetUpUI
extension VerificationKycSigningTVC{
    func setUpCell(){
        ProfileVM().getProfileDataApi(completion: {[]response in
            if response != nil{
                self.statusKyc = response?.data?.kycStatus?.decoderKycStatus ?? .notPerformed
                self.statusSigning = response?.data?.yousignStatus?.decoderSigningStatus ?? .notPerformed
                
                self.updateKycIndicators()
                self.updateSigningIndicators()
            }
        })
        
        CommonUI.setUpLbl(lbl: self.kycLbl, text: CommonFunctions.localisation(key: "VERIFICATION_IDENTITY"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.signingLbl, text: CommonFunctions.localisation(key: "CONTRACT_SIGNATURE"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        verificationKycVw.layer.cornerRadius = 16
        verificationKycVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        verificationSigningVw.layer.cornerRadius = 16
        verificationSigningVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        let kycLineTap = UITapGestureRecognizer(target: self, action: #selector(kycLineTapped))
        self.verificationKycVw.addGestureRecognizer(kycLineTap)
        
        let signingLineTap = UITapGestureRecognizer(target: self, action: #selector(signingLineTapped))
        self.verificationSigningVw.addGestureRecognizer(signingLineTap)
    
    }
    
    func updateSigningIndicators(){
        switch statusSigning {
        case .rejected:
            self.indicatorSigningImgVw.setImage(Assets.right_arrow_purple.image())
        case .notPerformed:
            if(statusKyc == .validated){
                self.indicatorSigningImgVw.setImage(Assets.right_arrow_purple.image())
            }else{
                self.indicatorSigningImgVw.setImage(Assets.not_performed_indicator.image())
            }
        case .pending:
            break
        case .validated:
            self.indicatorSigningImgVw.setImage(Assets.accepted_indicator.image())
            self.rightArrowSigningImgVw.isHidden = true
        case .none:
            break
        }
    }
    
    func updateKycIndicators(){
        switch self.statusKyc {
        case .rejected:
            self.indicatorKycImgVw.setImage(Assets.right_arrow_purple.image())
        case .notPerformed:
            self.indicatorKycImgVw.setImage(Assets.right_arrow_purple.image())
            self.launchTimer()
        case .pending:
            self.indicatorKycImgVw.setImage(Assets.pending_indicator.image())
            self.launchTimer()
        case .validated:
            self.indicatorKycImgVw.setImage(Assets.accepted_indicator.image())
            self.rightArrowKycImgVw.isHidden = true
        case .none:
            break
        }
    }
    
    func launchTimer(){
        if self.portolioHomeVC?.timerVerificationSigning == nil {
            self.portolioHomeVC?.timerVerificationSigning = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
        }
    }
}

//MARK: - objective functions
extension VerificationKycSigningTVC{
    @objc func kycLineTapped(){
        switch self.statusKyc {
        case .rejected, .notPerformed:
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
        case .pending:
            CommonFunctions.toster(CommonFunctions.localisation(key: "KYC_UNDER_VERIFICATION"))
        case .validated, .none:
            break
        }
    }
    
    @objc func signingLineTapped(){
        switch self.statusSigning {
        case .rejected, .notPerformed:
            if(self.statusKyc == .validated){
                let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                CommonFunctions.showLoader()
                KycWebVM().getSignUrlApi(completion:{ response in
                    if(response != nil){
                        CommonFunctions.hideLoader()
                        vc.kycUrl = response?.data?.url ?? ""
                        let navVC = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows[0].rootViewController = navVC
                        UIApplication.shared.windows[0].makeKeyAndVisible()
                        navVC.navigationController?.popToRootViewController(animated: true)
                        navVC.setNavigationBarHidden(true , animated: true)
                        
                    }
                })
            }
        case .pending, .validated, .none:
            break
        }
    }
    
    @objc func fireTimer(){
        ProfileVM().getProfileDataApi(completion: {[]response in
            if response != nil{
                if(response?.data?.kycStatus?.decoderKycStatus == .validated){
                    self.statusKyc = .validated
                    self.updateKycIndicators()
                    self.portolioHomeVC?.invalidateTimerVerificationKycSigning()
                }else if(response?.data?.kycStatus?.decoderKycStatus == .rejected){
                    self.statusKyc = .rejected
                    self.updateKycIndicators()
                    self.portolioHomeVC?.invalidateTimerVerificationKycSigning()
                }else if(response?.data?.kycStatus?.decoderKycStatus == .pending){
                    self.statusKyc = .pending
                    self.updateKycIndicators()
                }
            }
        })
    }
}
