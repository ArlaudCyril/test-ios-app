//
//  InformationPopUpVC.swift
//  Lyber
//
//  Created by Elie Boyrivent on 01/10/2024.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import SwiftUI
import CountryPickerView

final class InformationPopUpVC: ViewController {
    //MARK: - Variables
    var typeInformation : String?
    var controller : ViewController?
    var countryCode = "+33"
    var totalCoinsInvested = Decimal()
    var totalEuroInvested = Double()
    var fromAssetId = String()
    var numberOfDecimals = Int()
    
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descLbl: UILabel!

    @IBOutlet var phoneView: UIView!
    @IBOutlet var phoneTF: UITextField!
    
    @IBOutlet var countryPickerVw: CountryPickerView!
    @IBOutlet var countryCodeBtn: UIButton!
    
    @IBOutlet var actionBtn: PurpleButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }


    //MARK: - SetUpUI
    override func setUpUI(){
        IQKeyboardManager.shared.enableAutoToolbar = false
        switch typeInformation {
        case "sendMoneyPhone":
            CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "VERIFICATION_TITLE_SEND_MONEY"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: descLbl, text: CommonFunctions.localisation(key: "VERIFICATION_DESC_SEND_MONEY"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        default:
            CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "VERIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        }
        containerView.layer.cornerRadius = 32;
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        containerView.layer.masksToBounds = true
        
        self.descLbl.numberOfLines = 0
     
        CommonUI.setUpButton(btn: countryCodeBtn, text: self.countryCode, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        
        self.actionBtn.setTitle(CommonFunctions.localisation(key: "VERIFICATION_BTN_SEND_MONEY"), for: .normal)
        self.actionBtn.addTarget(self, action: #selector(actionBtnAct), for: .touchUpInside)
        
        let tapGestureOuterView = UITapGestureRecognizer(target: self, action: #selector(backBtnAct))
        outerView.isUserInteractionEnabled = true
        outerView.addGestureRecognizer(tapGestureOuterView)
        
        self.phoneTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.phoneTF.delegate = self
        
        countryPickerVw.delegate = self
        countryPickerVw.dataSource = self
        countryPickerVw.customizeView()
        
    }
}

//MARK: - Text Field Delegates
extension InformationPopUpVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == phoneTF{
            CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneTF{
            CommonUI.setUpViewBorder(vw: self.phoneView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - COUNTRY PICKER DELEGATES
extension InformationPopUpVC: CountryPickerViewDelegate,CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.countryCodeBtn.setTitle(country.phoneCode, for: .normal)
        self.countryCode = country.phoneCode
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?{
        return "Select Country"
    }
}

//MARK: - Other functions
extension InformationPopUpVC{

    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func actionBtnAct(){
        switch typeInformation {
        case "sendMoneyPhone":
            self.dismiss(animated: true, completion: nil)
            let phone = String(self.countryPickerVw.selectedCountry.phoneCode.dropFirst() + (self.phoneTF.text ?? "").phoneFormat)
            InformationPopUpVM().getUserNameByPhoneApi(phone: phone, completion: {response in
                if response != nil{
                    let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.InvestmentType = .Send
                    vc.fromAssetId = self.fromAssetId
                    vc.totalCoinsInvested = self.totalCoinsInvested
                    vc.totalEuroInvested = self.totalEuroInvested
                    vc.friendInfo = response?.data
                    vc.numberOfDecimals = self.numberOfDecimals
                    self.controller?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        default:
            break
        }
    }

}

