//
//  WithdrawAllVC.swift
//  Lyber
//
//  Created by sonam's Mac on 21/06/22.
//

import UIKit

class WithdrawAllVC: ViewController {
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var withdrawAllLbl: UILabel!
    @IBOutlet var totalNoOfEuroLbl: UILabel!
    
    @IBOutlet var creditCardVw: UIView!
    @IBOutlet var creditCardImgVw: UIView!
    @IBOutlet var creditCardImg: UIImageView!
    @IBOutlet var creditCardNumberLbl: UILabel!
    @IBOutlet var creditCardLbl: UILabel!
    @IBOutlet var maximumBtnb: UIButton!
    @IBOutlet var withdraw: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


	//MARK: - SetUpUI
    override func setUpUI(){
        self.cancelBtn.layer.cornerRadius = 12
        self.creditCardVw.backgroundColor = UIColor.greyColor
        self.creditCardVw.layer.cornerRadius = 16
    
        self.creditCardImg.image = Assets.bank_outline.image()
        self.creditCardImgVw.layer.cornerRadius = self.creditCardImgVw.layer.bounds.height/2
        self.creditCardImgVw.backgroundColor = UIColor.borderColor
        CommonUI.setUpLbl(lbl: withdrawAllLbl, text: CommonFunctions.localisation(key: "WITHDRAW_ALL_MY_PORTFOLIO"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: totalNoOfEuroLbl, text: "\(totalPortfolio)€", textColor: UIColor.PurpleAC82F2, font: UIFont.AtypTextMedium(Size.sixty.sizeValue()))
        CommonUI.setUpLbl(lbl: creditCardNumberLbl, text: "Frida... MX12...3392", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: creditCardLbl, text: CommonFunctions.localisation(key: "BANK_ACCOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: maximumBtnb, text: "", textcolor: UIColor.grey877E95, backgroundColor: UIColor.greyColor, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.withdraw.setTitle(CommonFunctions.localisation(key: "WITHDRAW"), for: .normal)
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let creditTapped  = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        self.creditCardVw.addGestureRecognizer(creditTapped)
    }
}

//MARK: - objective functions
extension WithdrawAllVC{
    @objc func cancelBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func selectCard(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .withdrawAll
        self.present(vc, animated: true, completion: nil)
        vc.accountSelectedCallback = {[weak self] accountSelected in
//            self?.creditCardImg.image = accountSelected.icon
//            self?.creditCardImgVw.backgroundColor = accountSelected.iconBackgroundColor
//            self?.creditCardLbl.text = accountSelected.subName
//            self?.creditCardNumberLbl.text = accountSelected.name
        }
    }
}
