//
//  ConfirmExecutionVC.swift
//  Lyber
//
//  Created by Lyber on 07/09/2023.
//

import Foundation
import UIKit
import MultiProgressView
import StripeApplePay
import PassKit
import SwiftUI
import AppsFlyerLib

class ConfirmExecutionVC: ViewController {
	
	//MARK: - Variables
	var toAmountToObtain = Double(),fromAmountInvested = Double()
	var InvestmentType : InvestStrategyModel = .activateStrategy
	var validTimeStamp : Int?
	var fees : Double?
	var detailViews : [UIView] = []
	
	//exchange
	var timeLimit : Int?
	var ratioCoin : String?
	var amountFrom : String?
	var amountFromDeductedFees : String?
	var amountTo : String?
	var exchangeTo = String()
    var orderId: String?
	var paymentIntentId: String?
	var coinFromPrice: Double?
	var coinToPrice: Decimal?
	var fromAssetId : String?
    var numberOfDecimal : Int?
    
    //singleCoin / exchange
    var timer: Timer?
    var endTime: Date?
    
	//singleCoin
	var asset : PriceServiceResume?
	let applePayButton: PKPaymentButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
	var clientSecret: String?
    var quoteIsCanceled = false
	
	//MARK: - IB OUTLETS
	@IBOutlet var backBtn: UIButton!
	@IBOutlet var confirmExecutionLbl: UILabel!
	
	@IBOutlet var fromAmountExecution: UILabel!
	@IBOutlet var arrowExecution: UILabel!
	@IBOutlet var toAmountExecution: UILabel!
	
	@IBOutlet var stackVw: UIStackView!
	
	@IBOutlet var moreDetailsVw: UIView!
	@IBOutlet var moreDetailsLbl: UILabel!
	
	@IBOutlet var toAssetPriceVw: UIView!
	@IBOutlet var toAssetPriceTitleLbl: UILabel!
	@IBOutlet var toAssetPriceValueLbl: UILabel!
	
	@IBOutlet var amountVw: UIView!
	@IBOutlet var amountTitleLbl: UILabel!
	@IBOutlet var amountValueLbl: UILabel!
	
	@IBOutlet var lyberFeesVw: UIView!
	@IBOutlet var lyberFeesTitleLbl: UILabel!
	@IBOutlet var lyberFeesValueLbl: UILabel!
	
	@IBOutlet var totalVw: UIView!
	@IBOutlet var totalTitleLbl: UILabel!
	@IBOutlet var totalValueLbl: UILabel!
	
	@IBOutlet var topVw: UIView!
	@IBOutlet var bottomVw: UIView!
	@IBOutlet var confirmExecutionBtn: PurpleButton!
	@IBOutlet var timeToConfirmPurchaseLbl: UILabel!
	@IBOutlet var volatilePriceLbl: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
		checkInvestmentType()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		timer?.invalidate()
        timer = nil
	}
	
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		self.backBtn.layer.cornerRadius = 12
		CommonUI.setUpLbl(lbl: self.confirmExecutionLbl, text: CommonFunctions.localisation(key: "CONFIRM_PURCHASE"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: self.fromAmountExecution, text: "\(CommonFunctions.formattedCurrency(from: fromAmountInvested))€", textColor: UIColor.PurpleColor, font: UIFont.MabryProMedium(Size.XVLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: self.arrowExecution, text: "↓", textColor: UIColor.PurpleColor, font: UIFont.MabryProMedium(Size.XVLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: self.toAmountExecution, text: "\(CommonFunctions.formattedCurrency(from: toAmountToObtain)) \(self.asset?.id.uppercased() ?? "")", textColor: UIColor.PurpleColor, font: UIFont.MabryProMedium(Size.XVLarge.sizeValue()))
		
		self.stackVw.layer.cornerRadius = 16
		
		//Title
		CommonUI.setUpLbl(lbl: self.moreDetailsLbl, text: "> \(CommonFunctions.localisation(key: "MORE_DETAILS"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.toAssetPriceTitleLbl, text: "\(asset?.id.uppercased() ?? "") \(CommonFunctions.localisation(key: "PRICE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.amountTitleLbl, text: CommonFunctions.localisation(key: "AMOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.lyberFeesTitleLbl, text: CommonFunctions.localisation(key: "FEES"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.totalTitleLbl, text: CommonFunctions.localisation(key: "TOTAL"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))

		//Values
		CommonUI.setUpLbl(lbl: self.toAssetPriceValueLbl, text: "\(self.asset?.priceServiceResumeData.lastPrice ?? "0.0")€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.amountValueLbl, text: "\(CommonFunctions.formattedCurrency(from: fromAmountInvested - (self.fees ?? 0)))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.lyberFeesValueLbl, text: "\(self.fees ?? 0.08)€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.totalValueLbl, text:
							"\(CommonFunctions.formattedCurrency(from: (fromAmountInvested)))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		self.confirmExecutionBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_INVESTMENT"), for: .normal)
		CommonUI.setUpLbl(lbl: timeToConfirmPurchaseLbl, text: "", textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Small.sizeValue()))
		CommonUI.setUpLbl(lbl: volatilePriceLbl, text: CommonFunctions.localisation(key: "PRICE_CRYPTOCURRENCY_VOLATILE"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
		
		backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		confirmExecutionBtn.addTarget(self, action: #selector(confirmExecutionBtnAct), for: .touchUpInside)
		
		self.toAssetPriceVw.isHidden = true
		self.amountVw.isHidden = true
		self.lyberFeesVw.isHidden = true
		self.totalVw.isHidden = true
		
		let moreDetailsTap = UITapGestureRecognizer(target: self, action: #selector(onClickDetails))
		self.moreDetailsVw.addGestureRecognizer(moreDetailsTap)
	}
	
	func checkInvestmentType(){
		if InvestmentType == .singleCoin || InvestmentType == .singleCoinWithFrequence{
			self.view.addSubview(applePayButton)
			applePayButton.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				applePayButton.leadingAnchor.constraint(equalTo: confirmExecutionBtn.leadingAnchor),
				applePayButton.trailingAnchor.constraint(equalTo: confirmExecutionBtn.trailingAnchor),
				applePayButton.topAnchor.constraint(equalTo: confirmExecutionBtn.topAnchor),
				applePayButton.bottomAnchor.constraint(equalTo: confirmExecutionBtn.bottomAnchor)
			])
			self.confirmExecutionBtn.isHidden = true
			
			applePayButton.isHidden = !StripeAPI.deviceSupportsApplePay()
			applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)
			
			self.detailViews = [self.toAssetPriceVw, self.amountVw, self.lyberFeesVw, self.totalVw]
            
            let fees = self.fromAmountInvested - (Double(self.amountFromDeductedFees ?? "0") ?? 0)
            self.amountValueLbl.text = "\(self.amountFromDeductedFees ?? "0")€"
            self.lyberFeesValueLbl.text = "~\(CommonFunctions.formattedAssetBinance(value: fees.description, numberOfDecimals: self.numberOfDecimal ?? 2))€"
            
            //timerApplePay
            if let validTimeStamp = self.validTimeStamp {
                let endDate = Date(timeIntervalSince1970: TimeInterval(validTimeStamp / 1000))
                self.endTime = endDate
                
                updateCountdownApplePay()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownApplePay), userInfo: nil, repeats: true)
            }
			
		}else if InvestmentType == .Exchange{
            self.confirmExecutionLbl.text = CommonFunctions.localisation(key: "CONFIRM_EXCHANGE")
            
            self.toAssetPriceTitleLbl.text = CommonFunctions.localisation(key: "RATIO")
            self.toAssetPriceValueLbl.text = "1 : \(self.ratioCoin ?? "")"
            
            self.amountTitleLbl.text = CommonFunctions.localisation(key: "EXCHANGE_FROM")
            self.amountValueLbl.text = "~\(self.amountFromDeductedFees ?? "0") \(self.fromAssetId?.uppercased() ?? "")"
            
            self.lyberFeesValueLbl.text = "~\(CommonFunctions.formattedAssetBinance(value: self.fees?.description ?? "", numberOfDecimals: self.numberOfDecimal ?? 2)) \(self.fromAssetId?.uppercased() ?? "")"
        
            self.totalValueLbl.text = "\(CommonFunctions.formattedAssetBinance(value: amountFrom ?? "0", numberOfDecimals: self.numberOfDecimal ?? 2)) \(self.fromAssetId?.uppercased() ?? "")"
            
            self.fromAmountExecution.text = self.totalValueLbl.text
            
            let finalAmount = Decimal(string: self.amountTo ?? "0") ?? 0
            
            self.toAmountExecution.text = "\(CommonFunctions.formattedAssetDecimal(from: finalAmount, price: self.coinToPrice)) \(self.exchangeTo.uppercased())"
            
            //timerExchange
            if let validTimeStamp = self.timeLimit {
                let endDate = Date(timeIntervalSince1970: TimeInterval(validTimeStamp / 1000))
                self.endTime = endDate
                
                updateCountdownExchange()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdownExchange), userInfo: nil, repeats: true)
            }
            
            self.timeToConfirmPurchaseLbl.isHidden = true
            
            self.detailViews = [self.toAssetPriceVw, self.amountVw, self.lyberFeesVw, self.totalVw]
			
		}
	}
	
}


//MARK: - ApplePayContextDelegate
extension ConfirmExecutionVC: ApplePayContextDelegate{
	
	func applePayContext(_ context: StripeApplePay.STPApplePayContext, didCreatePaymentMethod paymentMethod: StripeCore.StripeAPI.PaymentMethod, paymentInformation: PKPayment, completion: @escaping StripeApplePay.STPIntentClientSecretCompletionBlock) {
		completion(self.clientSecret ?? "", nil)
	}
	
	func applePayContext(_ context: StripeApplePay.STPApplePayContext, didCompleteWith status: StripeApplePay.STPApplePayContext.PaymentStatus, error: Error?) {
		switch status {
			case .success:
                AppsFlyerLib.shared().logEvent(AFEventPurchase, withValues: [
                    AFEventParamContentId: self.orderId ?? "",
                    AFEventParamContentType: "CcOrder"
                ]);
                sleep(2)
				// Payment succeeded, show a receipt view
				let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				vc.assetId = self.asset?.id ?? ""
				vc.orderId = self.orderId ?? ""
				self.navigationController?.pushViewController(vc, animated: true)
				break
			case .error:
				// Payment failed, show the error
				if let errDescription = error?.localizedDescription {
					print("Description de l'erreur: \(errDescription)")
				}
				break
			case .userCancellation:
				// User canceled the payment
				break
			@unknown default:
				fatalError()
		}
	}
}

//MARK: - objective functions
extension ConfirmExecutionVC{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func confirmExecutionBtnAct(){
		if InvestmentType == .Exchange{
			ConfirmInvestmentVM().ordersAcceptQuoteAPI(orderId: self.orderId ?? "", completion: {response in
				if response != nil{
					let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					vc.assetId = self.exchangeTo
					vc.orderId = self.orderId ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
				}
			})
		}
	}
	
	@objc func handleApplePayButtonTapped() {
		let merchantIdentifier = "merchant.com.lyber"
		let paymentRequest = StripeAPI.paymentRequest(withMerchantIdentifier: merchantIdentifier, country: "FR", currency: "EUR")
		
		// Configure the line items on the payment request
		paymentRequest.paymentSummaryItems = [
			// The final line should represent your company;
			// it'll be prepended with the word "Pay" (that is, "Pay iHats, Inc $50")
			// Ajouter cette ligne pour inclure le nom de ta société
			
			PKPaymentSummaryItem(label: "\(self.asset?.id.uppercased() ?? "")", amount: NSDecimalNumber(value: fromAmountInvested)),
			PKPaymentSummaryItem(label: "Lyber", amount: NSDecimalNumber(value: fromAmountInvested))
		]
		// Initialize an STPApplePayContext instance
		if let applePayContext = STPApplePayContext(paymentRequest: paymentRequest, delegate: self) {
			// Present Apple Pay payment sheet
			applePayContext.presentApplePay(on: self)
		} else {
			// There is a problem with your Apple Pay configuration
		}
	}
	
	@objc func onClickDetails(){
		if toAssetPriceVw.isHidden {
			animationDropDown(toogle: true)
		} else {
			animationDropDown(toogle: false)
		}
	}
}

//MARK: - Other functions
extension ConfirmExecutionVC{
	
	
	func animationDropDown(toogle: Bool){
		
		if(toogle == true){
			// Fade in + Spring animation
			UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
				for detailVw in self.detailViews{
					detailVw.alpha = 1
					detailVw.isHidden = false
				}
			}, completion: nil)
			UIView.transition(with: self.moreDetailsLbl, duration: 0.1, options: .transitionCrossDissolve, animations: {
				self.moreDetailsLbl.text = "∨ \(CommonFunctions.localisation(key: "MORE_DETAILS"))"
			}, completion: nil)
			
		}else{
			// Fade out animation
			UIView.animate(withDuration: 0.5, animations: {
				for detailVw in self.detailViews{
					detailVw.alpha = 0
				}
			}) { _ in
				for detailVw in self.detailViews{
					detailVw.isHidden = true
				}
			}
			UIView.transition(with: self.moreDetailsLbl, duration: 0.1, options: .transitionCrossDissolve, animations: {
				self.moreDetailsLbl.text = "> \(CommonFunctions.localisation(key: "MORE_DETAILS"))"
			}, completion: nil)
		}
	}
	
    @objc func updateCountdownApplePay() {
        guard let endTime = endTime else { return }
        let now = Date()
        let remainingSeconds = Calendar.current.dateComponents([.second], from: now, to: endTime).second ?? 0
            
        if remainingSeconds <= 0 {
            self.timer?.invalidate()
            self.timer = nil
            
            if(!self.quoteIsCanceled){
                ConfirmExecutionVM().cancelQuoteApi(userUuid: userData.shared.userUuid, orderId: self.orderId ?? "", paymentIntentId: self.paymentIntentId ?? "", completion: {_ in })
            }
            
            applePayButton.isUserInteractionEnabled = false
            
            let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
            vc.asset = self.asset
            vc.fees = self.fees
            vc.toAmountToObtain = self.toAmountToObtain
            vc.fromAmountInvested = self.fromAmountInvested
            vc.InvestmentType = self.InvestmentType
            vc.confirmationType = .buyFailure
            vc.previousViewController = self
            self.present(vc, animated: true)
        }else {
            if(remainingSeconds == 1){
                ConfirmExecutionVM().cancelQuoteApi(userUuid: userData.shared.userUuid, orderId: self.orderId ?? "", paymentIntentId: self.paymentIntentId ?? "", completion: {_ in })
            }
            DispatchQueue.main.async {
                self.timeToConfirmPurchaseLbl.text = CommonFunctions.localisation(key: "CONFIRM_PURCHASE_TIME", parameter: String(remainingSeconds))
            }
        }
    }
    
    @objc func updateCountdownExchange() {
        guard let endTime = endTime else { return }
        let now = Date()
        let remainingSeconds = Calendar.current.dateComponents([.second], from: now, to: endTime).second ?? 0
            
        if remainingSeconds <= 0 {
            self.timer?.invalidate()
            self.timer = nil
            
            //update UI
            confirmExecutionBtn.isEnabled = false
            confirmExecutionBtn.backgroundColor = .gray
            confirmExecutionBtn.setTitle("\(CommonFunctions.localisation(key: "CONFIRM_EXCHANGE")) (0 sec)", for: .normal)
        }else{
            confirmExecutionBtn.setTitle("\(CommonFunctions.localisation(key: "CONFIRM_EXCHANGE")) (\(remainingSeconds) sec)", for: .normal)
        }
    }
}
