//
//  EnterWalletAddressVC.swift
//  Lyber
//
//  Created by sonam's Mac on 24/06/22.
//

import UIKit
import IQKeyboardManagerSwift

class EnterWalletAddressVC: ViewController {
    //MARK: - Variables
    var fromCoinsData : Asset?
    var assetData : Trending?
    var enterWalletAddressVM = EnterWalletAddressVM(),totalEuroInvested = Double(),noOfCoinsinvested = Double()
    //MARK:- IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var enterWalletAddressLbl: UILabel!
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressTF: UITextField!
    @IBOutlet var withdrawBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: enterWalletAddressLbl, text: "Wallet Address", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpViewBorder(vw: self.addressView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpTextField(textfield: addressTF, placeholder: "Enter Wallet Address", font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        self.withdrawBtn.setTitle(CommonFunctions.localisation(key: "WITHDRAW"), for: .normal)
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.withdrawBtn.addTarget(self, action: #selector(withdrawBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension EnterWalletAddressVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func withdrawBtnAct(){
        withdrawBtn.showLoading()
        let assetID = fromCoinsData?.assetID == nil ? self.assetData?.symbol?.uppercased() ?? "" : self.fromCoinsData?.assetID ?? ""
        
        enterWalletAddressVM.withdrawApi(assetId: assetID, amount: totalEuroInvested, assetAmount: noOfCoinsinvested, walletAddress: addressTF.text ?? "", completion: {[weak self]response in
            self?.withdrawBtn.hideLoading()
            if let response = response{
                print(response)
                self?.GoToConfirmation()
            }
        })
    }
    
    func GoToConfirmation(){
        let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        vc.confirmationType = .Withdraw
        self.present(vc, animated: true, completion: nil)
    }
}
