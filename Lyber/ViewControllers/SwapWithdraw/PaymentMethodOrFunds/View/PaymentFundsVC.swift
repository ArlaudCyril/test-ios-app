//
//  PaymentFundsVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/08/22.
//

import UIKit

class PaymentFundsVC: ViewController {
    //MARK:- IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var addPaymentLbl: UILabel!
    
    @IBOutlet var fundAccountView: UIView!
    @IBOutlet var fundAccountImgView: UIView!
    @IBOutlet var fundAccountImg: UIImageView!
    @IBOutlet var fundAccountLbl: UILabel!
    @IBOutlet var fromyourbankAccLbl: UILabel!
    
    @IBOutlet var creditCardVw: UIView!
    @IBOutlet var creditCardImgView: UIView!
    @IBOutlet var creditCardImg: UIImageView!
    @IBOutlet var creditCardlbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
  
	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        CommonUI.setUpLbl(lbl: addPaymentLbl, text: CommonFunctions.localisation(key: "ADD_PAYMENT_METHOD_FUND_LYBER_ACCOUNT"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        
        self.fundAccountImgView.layer.cornerRadius = self.fundAccountImgView.bounds.height/2
        CommonUI.setUpLbl(lbl: fundAccountLbl, text: CommonFunctions.localisation(key: "FUND_ACCOUNT"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: fromyourbankAccLbl, text: CommonFunctions.localisation(key: "FROM_BANK_ACCOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.creditCardImgView.layer.cornerRadius = self.creditCardImgView.bounds.height/2
        CommonUI.setUpLbl(lbl: creditCardlbl, text: CommonFunctions.localisation(key: "ADD_CREDIT_DEBIT_CARD"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        let accountTap = UITapGestureRecognizer(target: self, action: #selector(accountTapped))
        self.fundAccountView.addGestureRecognizer(accountTap)
        
        let creditTap = UITapGestureRecognizer(target: self, action: #selector(creditTapped))
        self.creditCardVw.addGestureRecognizer(creditTap)
    }
}

//MARK: - objective functions
extension PaymentFundsVC{
    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func accountTapped(){
        let vc = FundAccountVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func creditTapped(){
        let vc = AddCreditCardVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
