//
//  StrongAuthVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit

class StrongAuthVC: UIViewController {
    //MARK: - Variables
    var strongAuthVM = StrongAuthVM()
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var strongAuthLbl: UILabel!
    @IBOutlet var strongAuthDescLbl: UILabel!
    
    @IBOutlet var bySMSView: UIView!
    @IBOutlet var bySmsLbl: UILabel!
    @IBOutlet var toNumberLbl: UILabel!
    @IBOutlet var smsSwitchBtn: UISwitch!
    
    @IBOutlet var smsAuthView: UIView!
    @IBOutlet var manageApplicationLbl: UILabel!
    @IBOutlet var validateWithdrawLbl: UILabel!
    @IBOutlet var validateWithdrawBtn: UISwitch!
    @IBOutlet var enableWhitelistingLbl: UILabel!
    @IBOutlet var enableWhitelistingBtn: UISwitch!
    @IBOutlet var editAccountLbl: UILabel!
    @IBOutlet var editAccountBtn: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
}

//MARK: - SetUpUI
extension StrongAuthVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.strongAuthLbl, text: L10n.StrongAuthentification.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.strongAuthDescLbl, text: L10n.forAddedSecurityOnLyberAccount.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.bySMSView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.bySmsLbl, text: L10n.BySMS.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.toNumberLbl, text: "\(L10n.To.description): \(userData.shared.phone_no)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.manageApplicationLbl, text: L10n.ManageApplicationCasesOfSMSAuthentication.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.validateWithdrawLbl, text: L10n.ValidateWithdrawal.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.enableWhitelistingLbl, text: L10n.EnableDisablewhitelisting.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.editAccountLbl, text: L10n.EditAccount.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        
        self.headerView.backBtn.addTarget(self, action: #selector(bcakBtnAct), for: .touchUpInside)
        self.smsSwitchBtn.addTarget(self, action: #selector(smsSwitchBtnAct), for: .touchUpInside)
        
        if userData.shared.strongAuthVerified{
            self.smsSwitchBtn.isOn = true
            self.smsAuthView.isHidden = false
        }else{
            self.smsSwitchBtn.isOn = false
            self.smsAuthView.isHidden = true
        }
//
//        if self.smsSwitchBtn.isOn == false{
//            self.smsAuthView.isHidden = true
//        }else{
//            self.smsAuthView.isHidden = false
//        }
    }
}

//MARK: - objective functions
extension StrongAuthVC{
    @objc func bcakBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func smsSwitchBtnAct(sender : UISwitch){
        if sender.isOn == true{
            print("on")
            CommonFunctions.showLoader(self.view)
            strongAuthVM.strongAuthApi(enable: sender.isOn, completion: {[weak self]response in
                CommonFunctions.hideLoader(self?.view ?? UIView())
                if let response = response{
                    let vc = StrongAuthOTPVerifyVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                    vc.strongAuthCallback = {
                        self?.smsSwitchBtn.isOn = true
                        self?.smsAuthView.isHidden = false
                    }
                    vc.cancelCallBack = {
                        self?.smsSwitchBtn.isOn = false
                    }
                    
                    self?.navigationController?.present(vc, animated: true, completion: nil)
                }
            })
        }else {
            print("off")
            strongAuthVM.strongAuthApi(enable: sender.isOn, completion: {[weak self]response in
                if let response = response{
                    self?.smsSwitchBtn.isOn = false
                    self?.smsAuthView.isHidden = true
                    userData.shared.strongAuthVerified = false
                    userData.shared.dataSave()
                }
            })
        }
    }
    
    
}
