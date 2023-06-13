//
//  ConfirmationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class ConfirmationVC: ViewController {
    var controller : EnterWalletAddressVC?
    var confirmationType : confirmationPopUp?
    var coinInvest : String?
	var confirmInvesmtentController : ViewController?
    //MARK:- IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var confirmationLbl: UILabel!
    
    @IBOutlet var confirmImgView: UIImageView!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var subHeadingLbl: UILabel!
    @IBOutlet var ThanksBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.headerView.headerLbl.isHidden = true
        self.headerView.backBtn.setImage(Assets.cancel_white.image(), for: .normal)
        
        CommonUI.setUpLbl(lbl: self.confirmationLbl, text: "Confirmation", textColor: UIColor.whiteColor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.headingLbl, text: "Your deposit has been taken into account", textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.subHeadingLbl, text: "You can now see its effect on your portfolio.", textColor: UIColor.whiteColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpButton(btn: self.ThanksBtn, text: "Thanks", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        if confirmationType == .Buy{
            self.headingLbl.text = "You have successfully bought \(coinInvest ?? "")."
        }else if confirmationType == .Sell{
            self.headingLbl.text = "You have successfully sold \(coinInvest ?? "")."
        }else if confirmationType == .Withdraw{
            self.headingLbl.text = "Amount has been withdrawn from your account."
        }else{
            
        }
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.ThanksBtn.addTarget(self, action: #selector(ThanksBtnAct), for: .touchUpInside)
    }
}
//MARK: - objective functions
extension ConfirmationVC{
    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func ThanksBtnAct(){
		CommonFunctions.callWalletGetBalance()
        self.dismiss(animated: true, completion: nil)
		let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
		vc.screenType = .withdraw
		self.confirmInvesmtentController?.navigationController?.pushViewController(vc, animated: true)
    }
}
