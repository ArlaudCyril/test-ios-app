//
//  VerificationEmailCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class VerificationEmailCVC: UICollectionViewCell {
    
    //MARK: - Variables
    var controller : PersonalDataVC?
    var personalDataVM = PersonalDataVM()
    var openAppleMailCallBack : (()->())?
    //MARK: - IB OUTLETS
    @IBOutlet var verificationEmailLbl: UILabel!
    @IBOutlet var verificationEmailDescLbl: UILabel!
    @IBOutlet var checkMailBoxLbl: UILabel!
    
    @IBOutlet var opemAppleMailVw: UIView!
    @IBOutlet var openAppleMailLbl: UILabel!
    
    @IBOutlet var openGmailVw: UIView!
    @IBOutlet var openGmailLbl: UILabel!
    @IBOutlet var resendEmailBtn: UIButton!
    
    override func awakeFromNib() {
        setUpCell()
    }
}

extension VerificationEmailCVC{
    func setUpCell(){
        print(self.controller?.email ?? "")
        CommonUI.setUpLbl(lbl: self.verificationEmailLbl, text: L10n.VérificationEmail.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        DispatchQueue.main.async {
            CommonUI.setUpLbl(lbl: self.verificationEmailDescLbl, text: "\(L10n.weHaveSentEmailTo.description)\(self.controller?.email ?? "")", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
            CommonUI.setTextWithLineSpacing(label: self.verificationEmailDescLbl, text: "\(L10n.weHaveSentEmailTo.description)\(self.controller?.email ?? "")", lineSpacing: 6, textAlignment: .left)
            
            self.verificationEmailDescLbl.attributedText = CommonUI.showAttributedString(firstStr: "\(L10n.weHaveSentEmailTo.description)", secondStr: self.controller?.email ?? "", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
        }
        CommonUI.setUpLbl(lbl: self.checkMailBoxLbl, text: "\(L10n.CheckYourMailbox.description)", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.checkMailBoxLbl, text: "\(L10n.CheckYourMailbox.description)", lineSpacing: 6, textAlignment: .left)
        
        
        CommonUI.setUpLbl(lbl: self.openAppleMailLbl, text: L10n.OpenAppleMail.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.openGmailLbl, text: L10n.OpenGmail.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: self.resendEmailBtn, text: L10n.ResendEmail.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.MabryPro(Size.Large.sizeValue()))
        self.resendEmailBtn.addTarget(self, action: #selector(resendBtnAct), for: .touchUpInside)
        self.resendEmailBtn.setAttributedTitle(CommonFunctions.underlineString(str: L10n.ResendEmail.description), for: .normal)
        
        
        let openAppleMailTap = UITapGestureRecognizer(target: self, action: #selector(openAppleMailTapped(sender:)))
        self.opemAppleMailVw.addGestureRecognizer(openAppleMailTap)
//
        let openGMailTap = UITapGestureRecognizer(target: self, action: #selector(openGMailTapped))
        self.openGmailVw.addGestureRecognizer(openGMailTap)
//        openAppleMailCallBack?()
    }
}

extension VerificationEmailCVC {
    @objc func openAppleMailTapped(sender : UITapGestureRecognizer){
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
//            UIApplication.shared.openURL(mailURL)
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }
    }
    @objc func openGMailTapped(){
        let googleUrlString = "googlegmail://"
        if let googleUrl = URL(string: googleUrlString) {
            if UIApplication.shared.canOpenURL(googleUrl) {
                UIApplication.shared.open(googleUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    @objc func resendBtnAct(){
        personalDataVM.sendVerificationEmailApi(email: self.controller?.email, password: self.controller?.emailPassword , completion: {[]response in
//            print(response?.message ?? "")
        })
    }
}

