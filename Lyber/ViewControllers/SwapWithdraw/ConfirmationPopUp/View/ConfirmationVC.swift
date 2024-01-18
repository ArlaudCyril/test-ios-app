//
//  ConfirmationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class ConfirmationVC: ViewController {
    var addStrategyController : AddStrategyVC?
    var confirmationType : confirmationPopUp?
    var coinInvest : String?
	var previousViewController : ViewController?
	
	var strategy : Strategy?
	var requiredAmount : Decimal = 0
	
	//buyFailure
	var asset : PriceServiceResume?
	var fees : Double?
	var toAmountToObtain = Double()
	var fromAmountInvested = Double()
	var InvestmentType : InvestStrategyModel = .activateStrategy
    //MARK:- IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var confirmationLbl: UILabel!
    
    @IBOutlet var confirmImgView: UIImageView!
    @IBOutlet var headingLbl: UILabel!
    @IBOutlet var subHeadingLbl: UILabel!
    @IBOutlet var ThanksBtn: UIButton!
    @IBOutlet var YesBtn: LoadingButton!
    
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
		CommonUI.setUpLbl(lbl: self.headingLbl, text: CommonFunctions.localisation(key: "DEPOSIT_TAKEN_ACCOUNT"), textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.subHeadingLbl, text: CommonFunctions.localisation(key: "SEE_EFFECTS_PORTFOLIO"), textColor: UIColor.whiteColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.subHeadingLbl.numberOfLines = 0
		CommonUI.setUpButton(btn: self.ThanksBtn, text: CommonFunctions.localisation(key: "THANKS"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
		CommonUI.setUpButton(btn: self.YesBtn, text: CommonFunctions.localisation(key: "YES"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
		self.checkConfirmationType()
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.ThanksBtn.addTarget(self, action: #selector(ThanksBtnAct), for: .touchUpInside)
		self.YesBtn.addTarget(self, action: #selector(YesBtnAct), for: .touchUpInside)
    }
	
	func checkConfirmationType(){
		self.YesBtn.isHidden = true
		if confirmationType == .Buy{
			self.headingLbl.text = "You have successfully bought \(coinInvest ?? "")."
		}else if confirmationType == .Sell{
			self.headingLbl.text = "You have successfully sold \(coinInvest ?? "")."
		}else if confirmationType == .Withdraw{
			self.headingLbl.text = CommonFunctions.localisation(key: "AMOUNT_WITHDRAW_ACCOUNT")
			self.headingLbl.textAlignment = .center
			self.subHeadingLbl.textAlignment = .center
		}else if confirmationType == .LinkSent{
			self.headingLbl.isHidden = true
			self.subHeadingLbl.text = CommonFunctions.localisation(key: "SENT_EMAIL_CONTAINING_RESET_LINK")
			self.subHeadingLbl.textAlignment = .center
			
		}else if confirmationType == .exportSuccess{
			self.confirmationLbl.text = CommonFunctions.localisation(key: "SUCCESSFUL")
			self.headingLbl.isHidden = true
			self.subHeadingLbl.text = CommonFunctions.localisation(key: "REQUEST_BEEN_RECEIVED")
			self.subHeadingLbl.textAlignment = .center
			
		}else if confirmationType == .exportFailure{
			self.bottomView.backgroundColor = UIColor.Red_500
			self.headerView.backgroundColor = UIColor.Red_500
			self.confirmationLbl.text = CommonFunctions.localisation(key: "ERROR")
			self.headingLbl.isHidden = true
			self.subHeadingLbl.text = CommonFunctions.localisation(key: "SOMETHING_WENT_WRONG")
			self.subHeadingLbl.textAlignment = .center
			self.ThanksBtn.setTitle(CommonFunctions.localisation(key: "TRY_AGAIN"), for: .normal)
			self.confirmImgView.image = Assets.red_failure_light.image()
			
		}else if confirmationType == .buyFailure{
			self.bottomView.backgroundColor = UIColor.Red_500
			self.headerView.backgroundColor = UIColor.Red_500
			self.confirmationLbl.text = CommonFunctions.localisation(key: "OOPS")
			self.headingLbl.isHidden = true
			self.subHeadingLbl.text = CommonFunctions.localisation(key: "DEADLINE_CONFIRMING_PURCHASE_PASSED")
			self.subHeadingLbl.textAlignment = .center
			self.YesBtn.isHidden = false
			self.ThanksBtn.setTitle(CommonFunctions.localisation(key: "CANCEL"), for: .normal)
			self.confirmImgView.image = Assets.red_failure_light.image()
			
		}else if(self.confirmationType == .Tailoring){
			self.bottomView.backgroundColor = UIColor.orange
			self.headerView.backgroundColor = UIColor.orange
			self.confirmImgView.image = Assets.sad_smiley.image()
			
			CommonUI.setUpLbl(lbl: self.confirmationLbl, text: CommonFunctions.localisation(key: "OH_MY"), textColor: UIColor.whiteColor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
			
			self.headingLbl.text = ""
			self.subHeadingLbl.text = "\(CommonFunctions.localisation(key: "AMOUNT_STRATEGY_INSUFFICIENT")) \(CommonFunctions.localisation(key: "TAILOR_STRATEGY_RAISE_AMOUNT")) (\(self.strategy?.activeStrategy?.amount ?? 0) USDT) \(CommonFunctions.localisation(key: "TO_2")) \(CommonFunctions.getFormatedPriceDecimal(number: self.requiredAmount)) USDT.\n \(CommonFunctions.localisation(key: "AGREE_INCREASE_INVESTMENT"))"
			
			self.YesBtn.isHidden = false
			CommonUI.setUpButton(btn: self.ThanksBtn, text: CommonFunctions.localisation(key: "NO"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
		}
	}
}
//MARK: - objective functions
extension ConfirmationVC{
    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func ThanksBtnAct(){
		if(confirmationType == .Tailoring || confirmationType == .exportFailure || confirmationType == .exportSuccess){
			self.dismiss(animated: false)
		}else if(confirmationType == .LinkSent){
			self.dismiss(animated: false)
			self.previousViewController?.navigationController?.popToViewController(ofClass: LoginVC.self)
		}else if(confirmationType == .buyFailure){
			self.dismiss(animated: false)
			self.previousViewController?.navigationController?.popToPortfolioHomeOrPortfolioDetail()
		}else{
			CommonFunctions.callWalletGetBalance()
			self.dismiss(animated: true, completion: nil)
			let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
			vc.screenType = .withdraw
			self.previousViewController?.navigationController?.pushViewController(vc, animated: true)
		}
		
    }
	
	@objc func YesBtnAct(){
		if (confirmationType == .Tailoring){
			if(Decimal(totalEuroAvailable ?? 0) > self.requiredAmount)
			{
				ConfirmInvestmentVM().editActiveStrategyApi(strategyName: self.strategy?.name ?? "", amount: NSDecimalNumber(decimal: self.requiredAmount).doubleValue, frequency: self.strategy?.activeStrategy?.frequency ?? "", ownerUuid: self.strategy?.ownerUuid ?? "",completion: {response in
					if response != nil{
						//update number assets
						AddStrategyVM().tailorStrategyApi(newStrategy: self.strategy ?? Strategy(), completion: {[]response in
							if response != nil{
								self.dismiss(animated: true, completion: nil)
								
								self.addStrategyController?.dismiss(animated: true, completion: nil)
								for i in 0...((self.addStrategyController?.investmentStrategyController?.invstStrategyData.count ?? 0) - 1) {
									if(self.addStrategyController?.investmentStrategyController?.invstStrategyData[i].name == self.strategy?.name)
									{
										self.addStrategyController?.investmentStrategyController?.invstStrategyData[i] = self.strategy ?? Strategy()
									}
								}
								self.addStrategyController?.investmentStrategyController?.tblView.reloadData()
							}
						})
					}
				})
			}else{
				self.dismiss(animated: true)
				CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_USDT"))
			}
		}else if(confirmationType == .buyFailure){
			self.YesBtn.showLoading(color: .purple)
			InvestInMyStrategyVM().ordersGetQuoteApi(fromAssetId: "eur", toAssetId: asset?.id ?? "", exchangeFromAmount: Decimal(fromAmountInvested), completion: {response in
				self.YesBtn.hideLoading()
				if response != nil{
					self.dismiss(animated: false)
					let vc = ConfirmExecutionVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
					vc.clientSecret = response?.data.clientSecret
					vc.asset = self.asset
					vc.validTimeStamp = response?.data.validTimestamp
                    vc.paymentIntentId = response?.data.paymentIntentId
					vc.fees = self.fees
					vc.fromAmountInvested = self.fromAmountInvested
					vc.toAmountToObtain = self.toAmountToObtain
					vc.InvestmentType = self.InvestmentType
					self.previousViewController?.navigationController?.pushViewController(vc, animated: false)
				}
			})
		}
		
    }
}
