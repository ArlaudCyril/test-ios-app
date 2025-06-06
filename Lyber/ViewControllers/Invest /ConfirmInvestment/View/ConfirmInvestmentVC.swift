//
//  ConfirmInvestmentVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/06/22.
//

import UIKit
import MultiProgressView
import StripeApplePay
import PassKit

class ConfirmInvestmentVC: ViewController {
	
    //MARK: - Variables
    var confirmInvestmentVM = ConfirmInvestmentVM()
    var assetData : Trending?,strategyData : Strategy?
    var totalCoinsInvested = Decimal(),totalEuroInvested = Double(),assetId = String()
    var frequency = String()
    var InvestmentType : InvestStrategyModel = .activateStrategy
    var coinsData : [InvestmentStrategyAsset] = []
	
	//withdraw
	var address : String?
	var network : NetworkAsset?
	var fees : Double?
	var coinPrice: Double?
    
    var minimumWithdraw : Double?
    
    //withdrawEuro
    var ribSelected : RibData?
	
	var asset : PriceServiceResume?
    
    //Send
    var friendInfo: UserInfoAPI?
    var numberOfDecimals : Int?
	
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var confirmInvestmentLbl: UILabel!
    @IBOutlet var noOfEuroInvested: UILabel!
    @IBOutlet var stackVw: UIStackView!
    
    @IBOutlet var coinPriceVw: UIView!
    @IBOutlet var coinPriceLbl: UILabel!
    @IBOutlet var euroCoinPriceLbl: UILabel!
	
    @IBOutlet var amountVw: UIView!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var euroAmountLbl: UILabel!
	
    @IBOutlet var frequencyVw: UIView!
    @IBOutlet var frequencyLbl: UILabel!
    @IBOutlet var frequencyNameLbl: UILabel!
	
    @IBOutlet var paymentVw: UIView!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var paymentNameLbl: UILabel!
	
	@IBOutlet var networkVw: UIView!
    @IBOutlet var networkTitleLbl: UILabel!
    @IBOutlet var networkLbl: UILabel!
	
    @IBOutlet var lyberFeeLbl: UILabel!
    @IBOutlet var euroLyberFeeLBl: UILabel!
    @IBOutlet var totalLbl: UILabel!
    @IBOutlet var totalEuroLbl: UILabel!
    @IBOutlet var allocationView: UIView!
    @IBOutlet var allocationLbl: UILabel!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressBar: MultiProgressView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeight: NSLayoutConstraint!
    
    @IBOutlet var bottomVw: UIView!
    @IBOutlet var confirmInvestmentBtn: PurpleButton!
    @IBOutlet var volatilePriceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        checkInvestmentType()
    }



	//MARK: - SetUpUI

    override func setUpUI(){
        self.coinsData = strategyData?.bundle ?? []
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.confirmInvestmentLbl, text: CommonFunctions.localisation(key: "CONFIRM_INVESTMENT"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfEuroInvested, text: "", textColor: UIColor.PurpleColor, font: UIFont.MabryProMedium(Size.XVLarge.sizeValue()))
        self.stackVw.layer.cornerRadius = 16
        
		CommonUI.setUpLbl(lbl: self.coinPriceLbl, text: "\(asset?.id.uppercased() ?? "") \(CommonFunctions.localisation(key: "PRICE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.amountLbl, text: CommonFunctions.localisation(key: "AMOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: CommonFunctions.localisation(key: "FREQUENCY"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.paymentLbl, text: CommonFunctions.localisation(key: "PAYMENT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkTitleLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.lyberFeeLbl, text: CommonFunctions.localisation(key: "FEES"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalLbl, text: CommonFunctions.localisation(key: "TOTAL"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.allocationLbl, text: CommonFunctions.localisation(key: "ALLOCATION"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: self.euroCoinPriceLbl, text: "\(self.asset?.priceServiceResumeData.lastPrice ?? "0.0")€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
        CommonUI.setUpLbl(lbl: self.euroAmountLbl, text: "\(CommonFunctions.formattedCurrency(from: totalEuroInvested))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
        CommonUI.setUpLbl(lbl: self.frequencyNameLbl, text: frequency, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: self.paymentNameLbl, text: "Apple Pay", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: self.euroLyberFeeLBl, text: "\(self.fees ?? 0.08)€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalEuroLbl, text:
							"\(CommonFunctions.formattedCurrency(from: (totalEuroInvested)))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.confirmInvestmentBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_INVESTMENT"), for: .normal)
        CommonUI.setUpLbl(lbl: volatilePriceLbl, text: CommonFunctions.localisation(key: "PRICE_CRYPTOCURRENCY_VOLATILE"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: volatilePriceLbl, text: CommonFunctions.localisation(key: "PRICE_CRYPTOCURRENCY_VOLATILE"), lineSpacing: 6, textAlignment: .center)
        
        self.progressBar.delegate = self
        self.progressBar.dataSource = self
        self.progressBar.cornerRadius = 4
        self.progressBar.lineCap = .round
        
		self.paymentVw.isHidden = true
        
        collView.delegate = self
        collView.dataSource = self
        setLayout()
        self.collView.reloadData()
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        confirmInvestmentBtn.addTarget(self, action: #selector(confirmInvestmentBtnAct), for: .touchUpInside)
    }
    
    func checkInvestmentType(){
		if (InvestmentType == .activateStrategy || InvestmentType == .editActiveStrategy || InvestmentType == .oneTimeInvestment){
			if(InvestmentType == .oneTimeInvestment){
				self.amountLbl.text = CommonFunctions.localisation(key: "INVEST")
				self.frequencyNameLbl.text = CommonFunctions.localisation(key: "IMMEDIATE")
			}
            self.coinPriceVw.isHidden = true
            self.allocationView.isHidden = false
            for i in 0...(coinsData.count - 1){
                DispatchQueue.main.async {
					self.progressBar.setProgress(section: i, to: (Float(self.coinsData[i].share ))/100)
                }
            }
			let feeEuros = totalEuroInvested/200
            self.noOfEuroInvested.text = "\(CommonFunctions.formattedCurrency(from: totalEuroInvested)) USDC"
			self.euroAmountLbl.text = "\(CommonFunctions.formattedCurrency(from: totalEuroInvested-feeEuros)) USDC"
			self.euroLyberFeeLBl.text = "~\(feeEuros) USDC"
			self.totalEuroLbl.text = "\(CommonFunctions.formattedCurrency(from: totalEuroInvested)) USDC"
			
        }else if InvestmentType == .deposit{
            self.coinPriceVw.isHidden = true
            self.allocationView.isHidden = true
            self.progressView.isHidden = true
            self.frequencyVw.isHidden = true
            self.lyberFeeLbl.text = CommonFunctions.localisation(key: "DEPOSIT_FEES")
            self.confirmInvestmentLbl.text = CommonFunctions.localisation(key: "CONFIRM_MY_DEPOSIT")
            confirmInvestmentBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_DEPOSIT"), for: .normal)
			
        }else if InvestmentType == .withdraw{
			
			self.confirmInvestmentLbl.text = CommonFunctions.localisation(key: "CONFIRM_WITHDRAWAL")
			self.confirmInvestmentBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_WITHDRAWAL"), for: .normal)
			
            let amountInvestedFormated = "\(CommonFunctions.formattedAssetBinance(value: self.totalCoinsInvested.description, numberOfDecimals: CommonFunctions.getDecimal(id: self.assetId))) \(self.assetId.symboleTranslation.uppercased())"
            
            self.noOfEuroInvested.text = amountInvestedFormated
			
			self.coinPriceVw.isHidden = true
			
			let finalAmount = self.totalCoinsInvested - Decimal(self.fees ?? 0.0)
            self.amountLbl.text = CommonFunctions.localisation(key: "AMOUNT")
            self.euroAmountLbl.text = "~\(CommonFunctions.formattedAssetBinance(value: finalAmount.description, numberOfDecimals: CommonFunctions.getDecimal(id: assetId))) \(assetId.uppercased())"
			
            self.frequencyLbl.text = CommonFunctions.localisation(key: "ADDRESS")
			
			
			self.frequencyNameLbl.text = "\(self.address?.addressFormat ?? "")"
			
			self.networkVw.isHidden = false
			CommonUI.setUpLbl(lbl: self.networkLbl, text: self.network?.fullName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
			self.lyberFeeLbl.text = CommonFunctions.localisation(key: "FEES")
            self.euroLyberFeeLBl.text = "~\(CommonFunctions.formattedAssetBinance(value: self.fees?.description ?? "", numberOfDecimals: CommonFunctions.getDecimal(id: self.assetId))) \(assetId.uppercased())"
			
			self.totalEuroLbl.text = amountInvestedFormated

			self.allocationView.isHidden = true
            self.progressView.isHidden = true
			self.volatilePriceLbl.isHidden = true
        }else if InvestmentType == .withdrawEuro{
            let fees = 0.66
            
            self.confirmInvestmentLbl.text = CommonFunctions.localisation(key: "CONFIRM_WITHDRAWAL")
            self.confirmInvestmentBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_WITHDRAWAL"), for: .normal)
            
            self.noOfEuroInvested.text = "\(self.totalEuroInvested) EUR"
            
            self.coinPriceVw.isHidden = true
            
            let finalAmountEuros = Decimal(self.totalEuroInvested) - Decimal(fees)
            
            self.amountLbl.text = CommonFunctions.localisation(key: "IBAN")
            self.euroAmountLbl.text = "\(self.ribSelected?.iban.addressFormat ?? "")"
            
            self.frequencyLbl.text = CommonFunctions.localisation(key: "BIC")
            self.frequencyNameLbl.text = "\(self.ribSelected?.bic ?? "")"
            
            self.paymentVw.isHidden = false
            
            self.paymentLbl.text = CommonFunctions.localisation(key: "SELL")
            CommonUI.setUpLbl(lbl: self.paymentNameLbl, text: "\(self.totalCoinsInvested.description) \(assetId.uppercased())", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
            self.networkVw.isHidden = false
            
            self.networkTitleLbl.text = CommonFunctions.localisation(key: "FEES")
            CommonUI.setUpLbl(lbl: self.networkLbl, text: "\(fees) EUR", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
            self.lyberFeeLbl.text = CommonFunctions.localisation(key: "RECEIVE")
            self.euroLyberFeeLBl.text = "~\(finalAmountEuros) EUR"
            
            self.totalEuroLbl.text = "\(totalEuroInvested) EUR"

            self.allocationView.isHidden = true
            self.progressView.isHidden = true
            self.volatilePriceLbl.isHidden = true
        }else if(InvestmentType == .Send){
            self.confirmInvestmentLbl.text = CommonFunctions.localisation(key: "CONFIRM_INVESTMENT_TITLE_SEND")
            self.confirmInvestmentBtn.setTitle(CommonFunctions.localisation(key: "CONFIRM_INVESTMENT_BTN_SEND"), for: .normal)
            
            self.noOfEuroInvested.text = "\(self.totalEuroInvested) €"
            
            //First Row
            self.coinPriceLbl.text = CommonFunctions.localisation(key: "CONFIRM_INVESTMENT_SURNAME")
            self.euroCoinPriceLbl.text = self.friendInfo?.lastName
            
            //Second Row
            self.amountLbl.text = CommonFunctions.localisation(key: "CONFIRM_INVESTMENT_FIRSTNAME")
            self.euroAmountLbl.text = self.friendInfo?.firstName

            //Third Row
            self.lyberFeeLbl.text = CommonFunctions.localisation(key: "CONFIRM_INVESTMENT_TOTAL_ASSET", parameter: [self.assetId.uppercased()])
            self.euroLyberFeeLBl.text = "\(CommonFunctions.formattedAssetBinance(value: self.totalCoinsInvested.description, numberOfDecimals: numberOfDecimals ?? 0)) \(self.assetId.uppercased())"
            
            //Total row
            self.totalEuroLbl.text = "\(totalEuroInvested.description.euroFormat ?? "0") €"

            self.frequencyVw.isHidden = true
            self.networkVw.isHidden = true
            self.allocationView.isHidden = true
            self.progressView.isHidden = true
            self.volatilePriceLbl.isHidden = true
        }
    }
	
}

//MARK: - COLL VIEW DELEGATE AND DATA SOURCE METHODS
extension ConfirmInvestmentVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestMoneyCVC", for: indexPath as IndexPath) as! InvestMoneyCVC
        cell.configureWithData(data : coinsData[indexPath.row], strategyColor: CommonFunctions.selectorStrategyColor(position : indexPath.row, totalNumber : coinsData.count))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - objective functions
extension ConfirmInvestmentVC{
    @objc func cancelBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmInvestmentBtnAct(){
        if InvestmentType == .activateStrategy{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.activateStrategyApi(strategyName: strategyData?.name ?? "", amount: totalEuroInvested, frequency: frequency, ownerUuid: strategyData?.ownerUuid ?? "", minAmount: self.strategyData?.minAmount ?? 0, controller: self, completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
                if let response = response{
                    print(response)
                    let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.isHidden = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }else if InvestmentType == .oneTimeInvestment{
            self.confirmInvestmentBtn.showLoading()
			OneTimeInvestmentVM().executeStrategyApi(strategyName: strategyData?.name ?? "", amount: totalEuroInvested, ownerUuid: strategyData?.ownerUuid ?? "", controller: self, completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
				if response != nil{
                    let vc = LoadingInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
					vc.idInvestment = response?.data.id ?? ""
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }else if InvestmentType == .editActiveStrategy{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.editActiveStrategyApi(strategyName: strategyData?.name ?? "", amount: totalEuroInvested, frequency: CommonFunctions.frequenceEncoder(frequence: frequency), ownerUuid: strategyData?.ownerUuid ?? "",completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
                if let response = response{
                    print(response)
                    let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.isHidden = true
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }else if InvestmentType == .withdraw || InvestmentType == .withdrawEuro{
            self.confirmInvestmentBtn.showLoading()
			var actionVerification = ""
            var dataGetOtp = [:] as [String : Any]
            var dataWithdrawalRequest = [:] as [String : Any]
            if(InvestmentType == .withdraw){
                dataGetOtp = [
                    "asset": self.assetId,
                    "network": self.network?.id ?? "",
                    "amount": self.totalCoinsInvested,
                    "destination": self.address ?? ""
                ]
                
                dataWithdrawalRequest = [
                    "asset": self.assetId,
                    "network": self.network?.id ?? "",
                    "amount": self.totalCoinsInvested,
                    "destination": self.address ?? ""
                ]
                actionVerification = "withdraw"
            }else{
                dataGetOtp = [
                    "destination": self.ribSelected?.iban ?? "",
                    "asset":"usdc",
                    "amount": self.totalCoinsInvested
                ]
                
                dataWithdrawalRequest = [
                    "ribId": self.ribSelected?.ribId ?? "",
                    "iban": self.ribSelected?.iban ?? "",
                    "bic": self.ribSelected?.bic ?? "",
                    "amount": self.totalCoinsInvested
                ]
                actionVerification = "withdrawEuro"
            }
            
			if(userData.shared.scope2FAWithdrawal == true){
                if(userData.shared.type2FA == "google"){
                    let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                    vc.typeVerification = userData.shared.type2FA
                    vc.action = actionVerification
                    vc.minimumWithdraw = self.minimumWithdraw
                    vc.controller = self
                    vc.dataWithdrawal = dataWithdrawalRequest
                    self.present(vc, animated: true, completion: nil)
                }else{
                    self.confirmInvestmentVM.userGetOtpApi(action: actionVerification, data: dataGetOtp, completion: {[weak self]response in
                        self?.confirmInvestmentBtn.hideLoading()
                        if response != nil{
                            let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                            vc.typeVerification = userData.shared.type2FA
                            vc.action = actionVerification
                            vc.minimumWithdraw = self?.minimumWithdraw
                            vc.controller = self ?? ConfirmInvestmentVC()
                            vc.dataWithdrawal = dataWithdrawalRequest
                            vc.resendClosure = {[weak self] in
                                self?.confirmInvestmentVM.userGetOtpApi(action: actionVerification, data: dataGetOtp, completion: {_ in})
                            }
                            self?.present(vc, animated: true, completion: nil)
                        }
                    })
                }
            }else{
                VerificationVM().walletCreateWithdrawalRequest(action: actionVerification, data: dataWithdrawalRequest, controller: self, minimumWithdraw: self.minimumWithdraw?.description ?? "", onSuccess:{[]response in
					if response != nil{
						let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                        if(actionVerification == "withdraw"){
                            vc.confirmationType = .Withdraw
                        }else{
                            vc.confirmationType = .WithdrawEuro
                        }
						vc.previousViewController = self
						self.present(vc, animated: true)
						
					}
                }, onFailure: {[]response in})
			}
        }else if(InvestmentType == .Send){
            self.confirmInvestmentVM.transferToFriendApi(asset: self.assetId, amount: Decimal(string: CommonFunctions.formattedAssetBinance(value: self.totalCoinsInvested.description, numberOfDecimals: numberOfDecimals ?? 0)) ?? 0, phone: self.friendInfo?.phoneNo ?? "", completion: {response in
                if response != nil{
                    let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    vc.confirmationType = .Congratulations
                    vc.previousViewController = self
                    self.present(vc, animated: true)
                }
            })
        }
    }
}

//MARK: - Other functions
extension ConfirmInvestmentVC{
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 92) / 2, height: 20)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collView.collectionViewLayout = layout
        
//        let height = collViw.collectionViewLayout.collectionViewContentSize.height
        let height = CGFloat((20*((self.coinsData.count+1)/2)) + 12*(self.coinsData.count/2))
        collViewHeight.constant = height
    }
}

//MARK: - Progress View Delegate and DataSourec
extension ConfirmInvestmentVC : MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return coinsData.count
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        sectionView.backgroundColor = CommonFunctions.selectorStrategyColor(position : section, totalNumber : coinsData.count)
        return sectionView
    }
    
    
}
