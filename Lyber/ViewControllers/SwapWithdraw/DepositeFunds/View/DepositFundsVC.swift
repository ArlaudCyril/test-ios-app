//
//  DepositFundsVC.swift
//  Lyber
//
//  Created by sonam's Mac on 19/07/22.
//

import UIKit

class DepositFundsVC: ViewController {
//MARK: - Variables
    var portfolioDetailController : PortfolioDetailVC?
    var depositeWallet = false
    var coinName : String = ""
    //MARK: - IB OUTLETS
    @IBOutlet var depositeFundsVw: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var bankAccountDetailLbl: UILabel!
    @IBOutlet var plzDepositeMoneyLbl: UILabel!
    @IBOutlet var accountView: UIView!
    @IBOutlet var ibanNumberLbl: UILabel!
    @IBOutlet var ibanNoLbl: UILabel!
    @IBOutlet var BICNumberLbl: UILabel!
    @IBOutlet var BICNoLbl: UILabel!
    @IBOutlet var amountWillBeReflectLbl: UILabel!
    
    @IBOutlet var depositeWalletvw: UIView!
    @IBOutlet var myWalletAddressLbl: UILabel!
    @IBOutlet var walletAdrressLbl: UILabel!
    @IBOutlet var pleaseDepositeLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        CommonUI.setUpLbl(lbl: self.headerLbl, text: CommonFunctions.localisation(key: "DEPOSIT_FUNDS"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.bankAccountDetailLbl, text: CommonFunctions.localisation(key: "BANK_ACCOUNT_DETAILS"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.XXlarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.plzDepositeMoneyLbl, text: CommonFunctions.localisation(key: "PLEASE_DEPOSIT_MONEY_MENTIONED"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.plzDepositeMoneyLbl, text: CommonFunctions.localisation(key: "PLEASE_DEPOSIT_MONEY_MENTIONED"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpViewBorder(vw: self.accountView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.ibanNumberLbl, text: CommonFunctions.localisation(key: "IBAN_NUMBER"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.ibanNoLbl, text: "1234-5678-654-3298", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.BICNumberLbl, text: CommonFunctions.localisation(key: "BIC_NUMBER"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.BICNoLbl, text: "9345345345", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.amountWillBeReflectLbl, text: CommonFunctions.localisation(key: "AMOUNT_REFLECTED"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.amountWillBeReflectLbl, text: CommonFunctions.localisation(key: "AMOUNT_REFLECTED"), lineSpacing: 6, textAlignment: .left)
        
        
        CommonUI.setUpLbl(lbl: self.myWalletAddressLbl, text: "My Wallet Address", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.walletAdrressLbl, text: "1234-5678-654-3298", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.pleaseDepositeLbl, text: "Please deposit \(coinName) in the above mentioned wallet address", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        
        if depositeWallet{
            self.headerLbl.text = "\(CommonFunctions.localisation(key: "DEPOSIT")) \(coinName)"
            self.depositeFundsVw.isHidden = true
            depositeWalletvw.isHidden = false
        }else{
            
            self.depositeFundsVw.isHidden = false
            depositeWalletvw.isHidden = true
        }
    }
}

//MARK: - objective functions
extension DepositFundsVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
}
