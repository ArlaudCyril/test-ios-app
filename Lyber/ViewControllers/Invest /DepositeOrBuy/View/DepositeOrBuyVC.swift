//
//  DepositeOrBuyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import UIKit

class DepositeOrBuyVC: ViewController {
    //MARK: - Variables
    var assetsData : Trending?, coinId : String?
    var buyDepositeData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "INVEST_ON_SINGLE_ASSET"), subName: CommonFunctions.localisation(key: "WITHOUT_GOING_THROUGH_STRATEGY"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "MONEY_DEPOSIT"), subName: CommonFunctions.localisation(key: "EUROS_BANK_ACCOUNT"), rightBtnName: "")
    ]
    var paymentMethodData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "CREDIT_CARD"), subName: "***0103", rightBtnName: "1000\(CommonFunctions.localisation(key: "MAX"))"),
        buyDepositeModel(icon: Assets.apple_pay.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "APPLE_PAY"), subName: "***0103", rightBtnName: "750\(CommonFunctions.localisation(key: "MAX"))"),
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "BANK_ACCOUNT"), subName: "Frida... MX12...3392", rightBtnName: "25 000\(CommonFunctions.localisation(key: "MAX"))"),
        buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.credit_card.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_CREDIT_CARD"), subName: CommonFunctions.localisation(key: "LIMITED_25000€_WEEK"), rightBtnName: ""),
    ]
    var withdrawExchangedata : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.withdraw.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "WITHDRAW"), subName: CommonFunctions.localisation(key: "SEND_ASSETS_ANOTHER_ACCOUNT"), rightBtnName: ""),
		buyDepositeModel(icon: Assets.buy.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "BUY_VERB"), subName: CommonFunctions.localisation(key: "BUY_ASSETS_USDC"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.exchange.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "EXCHANGE"), subName: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DEPOSIT_VERB"), subName: CommonFunctions.localisation(key: "MONEY_LYBER"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.send_money.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "SEND_MONEY_TITLE"), subName: (CommonFunctions.localisation(key: "SEND_MONEY_DESC")), rightBtnName: "")
    ]
    var withdrawToAccountData : [buyDepositeModel] = []
    
    var withdrawAllData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: "Frida... MX12...3392", subName: CommonFunctions.localisation(key: "BANK_ACCOUNT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""),
    ]
    
    var investInStrategyOrAssetData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "INVEST_IN_STRATEGIES"), subName: CommonFunctions.localisation(key: "BUILD_YOUR_OWN_STRATEGY"), rightBtnName: ""),
		buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "INVEST_IN_SINGLE_ASSET"), subName: CommonFunctions.localisation(key: "CHOOSE_AMONG_N_DIFFERENT_ASSETS", parameter: [Storage.currencies.count.description]), rightBtnName: "")
    ]
    
    var investWithStrategiesActiveData: [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.flash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ONE_TIME_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_SINGLETIME"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.pencil.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ADJUST_INVESTMENT"), subName: CommonFunctions.localisation(key: "CHANGE_FREQUENCY_AMOUNT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.coins.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "TAILOR_STRATEGY"), subName: CommonFunctions.localisation(key: "CHANGE_ASSET_REPARTITION"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.pause.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "PAUSE_STRATEGY"), subName: "", rightBtnName: "")
    ]
    
    var investWithStrategiesInactiveData: [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.flash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ONE_TIME_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_SINGLETIME"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.recurrent.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "RECURRING_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_REGULAR_BASIS"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.coins.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "TAILOR_STRATEGY"), subName: CommonFunctions.localisation(key: "CHANGE_ASSET_REPARTITION"), rightBtnName: "")
    ]
    
    var strategy : Strategy = Strategy()
    var assetPagePopUpData : [buyDepositeModel] = []
    var popupType  : bottomPopUp = .DepositeBuy
    var depositeCallback : ((_ index : Int)->())?
    var accountSelectedCallback : ((buyDepositeModel, Int)->())?
    var controller : ViewController?, portfolioHomeController : PortfolioHomeVC?,allAssetsController : AllAssetsVC?,portfolioDetailController : PortfolioDetailVC?,investStrategyController : InvestInMyStrategyVC?, investmentStrategyController : InvestmentStrategyVC?
	//PortfolioDetailVC
	var idAsset : String = ""
	var asset: PriceServiceResume?
	
	//withdraw
	var network: String?
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var depositeOrSingularBuyLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.depositeOrSingularBuyLbl, text: CommonFunctions.localisation(key: "DEPOSIT_SINGULAR_BUY"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        if popupType == .DepositeBuy{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "DEPOSIT_SINGULAR_BUY")
        }else if popupType == .PayWith{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "PAY_WITH")
        }else if popupType == .withdrawExchange{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "CHOOSE_OPERATION")
        }else if popupType == .withdrawTo || popupType == .withdrawToEuro{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_TO")
            /*self.withdrawToAccountData.append(buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""))*/
        }else if popupType == .InvestInStrategiesOrAsset{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "INVEST_IN_STRATEGIES_OR_SINGLE_ASSET")
        }else if(popupType == .investWithStrategiesActive || popupType == .investWithStrategiesInactive){
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "INVEST_WITH_STRATEGIES")
        }else if popupType == .withdrawAll{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_TO")
        }else if popupType == .AssetDetailPagePopUp{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "CHOOSE_OPERATION")
			self.assetPagePopUpData  = [
				buyDepositeModel(icon: Assets.withdraw.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "WITHDRAW"), subName: CommonFunctions.localisation(key: "SEND_ASSETS_ANOTHER_ACCOUNT"), rightBtnName: ""),
				buyDepositeModel(icon: Assets.buy.image(), iconBackgroundColor: UIColor.LightPurple, name:"\(CommonFunctions.localisation(key: "BUY")) \(self.idAsset.uppercased())", subName: CommonFunctions.localisation(key: "BUY_SPECIFIC_ASSET_USDC", parameter: [self.idAsset.uppercased()]), rightBtnName: ""),
				buyDepositeModel(icon: Assets.exchange.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "EXCHANGE"), subName: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), rightBtnName: ""),
				buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DEPOSIT"), subName: "\(CommonFunctions.localisation(key: "ASSET_LYBER_PART1")) \(self.idAsset.uppercased()) \(CommonFunctions.localisation(key: "ASSET_LYBER_PART2"))", rightBtnName: ""),
                buyDepositeModel(icon: Assets.send_money.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "SEND_MONEY_DETAIL_TITLE", parameter: [self.idAsset.uppercased()]), subName: (CommonFunctions.localisation(key: "SEND_MONEY_DETAIL_DESC", parameter: [self.idAsset.uppercased()])), rightBtnName: "")
			]
            
        }
		if(self.idAsset == "usdc"){
			self.assetPagePopUpData[1] = buyDepositeModel(icon: Assets.buy.image(), iconBackgroundColor: UIColor.LightPurple, name:CommonFunctions.localisation(key: "BUY_USDC"), subName: CommonFunctions.localisation(key: "BUY_USDC_EUROS"), rightBtnName: "")
		}
		if(self.strategy.publicType != "lyber"){
			self.investWithStrategiesInactiveData.append(buyDepositeModel(icon: Assets.trash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DELETE_STRATEGY"), subName: "", rightBtnName: ""))
		}
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(dismissBottomView))
        tap.minimumPressDuration = 0.01
        self.outerView.addGestureRecognizer(tap)
    }
}

//MARK: - table view delegates and dataSource
extension DepositeOrBuyVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if popupType == .DepositeBuy{
            return buyDepositeData.count
        }else if popupType == .PayWith{
            return paymentMethodData.count
        }else if popupType == .withdrawExchange{
            return withdrawExchangedata.count
        }else if popupType == .investWithStrategiesActive{
            return investWithStrategiesActiveData.count
        }else if popupType == .investWithStrategiesInactive{
            return investWithStrategiesInactiveData.count
        }else if popupType == .withdrawTo || popupType == .withdrawToEuro{
            return withdrawToAccountData.count
        }else if popupType == .InvestInStrategiesOrAsset{
            return investInStrategyOrAssetData.count
        }else if popupType == .withdrawAll{
            return withdrawAllData.count
        }else if popupType == .AssetDetailPagePopUp{
            return assetPagePopUpData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepositeOrBuyTVC", for: indexPath)as! DepositeOrBuyTVC
        if popupType == .DepositeBuy{
            cell.setUpCellData(data: buyDepositeData[indexPath.row])
        }else if popupType == .PayWith{
            cell.setUpCellData(data: paymentMethodData[indexPath.row])
        }else if popupType == .withdrawExchange{
            cell.setUpCellData(data: withdrawExchangedata[indexPath.row])
        }else if popupType == .investWithStrategiesActive{
            cell.setUpCellData(data: investWithStrategiesActiveData[indexPath.row])
        }else if popupType == .investWithStrategiesInactive{
            cell.setUpCellData(data: investWithStrategiesInactiveData[indexPath.row])
        }else if popupType == .withdrawTo || popupType == .withdrawToEuro{
            cell.setUpCellData(data: withdrawToAccountData[indexPath.row])
        }else if popupType == .InvestInStrategiesOrAsset{
            cell.setUpCellData(data: investInStrategyOrAssetData[indexPath.row])
        }else if popupType == .withdrawAll{
            cell.setUpCellData(data: withdrawAllData[indexPath.row])
        }else if popupType == .AssetDetailPagePopUp{
            cell.setUpCellData(data: assetPagePopUpData[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        switch (popupType){
        case .DepositeBuy:                                                              //Deposite Buy
            if indexPath.row == 0{
                let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                vc.screenType = .singleAsset
                self.controller?.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                let vc = DepositFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                self.controller?.navigationController?.pushViewController(vc, animated: true)
            }
        case .withdrawExchange:                                                          //withdraw exchange
            if indexPath.row == 0 || indexPath.row == 2{
                let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                if indexPath.row == 0{
                    vc.screenType = .withdraw
                }else{
                    vc.screenType = .exchange
                }
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
			}else if indexPath.row == 1{
				self.dismiss(animated: true, completion: nil)
				let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				vc.screenType = .singleAsset
				self.portfolioHomeController?.navigationController?.pushViewController(vc, animated: true)
				
			}else if indexPath.row == 3{
                let vc = DepositAssetVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
            }else if indexPath.row == 4{
                let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                vc.typeWithdraw = .send
                
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
			}
        case .investWithStrategiesActive:
            if indexPath.row == 0{
				let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
				vc.strategyData = self.strategy
				vc.strategyType = .oneTimeInvestment
                vc.fromAssetId = "usdc"
                vc.toAssetId = "eur"
				self.dismiss(animated: true, completion: nil)
				self.investmentStrategyController?.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1{
                let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyData = self.strategy
                vc.strategyType = .editActiveStrategy
                vc.fromAssetId = "usdc"
                vc.toAssetId = "eur"
                self.dismiss(animated: true, completion: nil)
                self.investmentStrategyController?.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 2{
                self.investmentStrategyController?.tailorStrategy(strategy: self.strategy)
                self.dismiss(animated: true, completion: nil)
                
            }else if indexPath.row == 3{
                self.investmentStrategyController?.pauseStragegy(strategy: self.strategy)
                self.dismiss(animated: true, completion: nil)
            }
        case .investWithStrategiesInactive:
            if indexPath.row == 0{
				let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
				vc.strategyData = self.strategy
				vc.strategyType = .oneTimeInvestment
                vc.fromAssetId = "usdc"
                vc.toAssetId = "eur"
				self.dismiss(animated: true, completion: nil)
				self.investmentStrategyController?.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1{
                let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyData = self.strategy
                vc.strategyType = .activateStrategy
                vc.fromAssetId = "usdc"
                vc.toAssetId = "eur"
                self.dismiss(animated: true, completion: nil)
                self.investmentStrategyController?.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2{
                self.investmentStrategyController?.tailorStrategy(strategy: self.strategy)
                self.dismiss(animated: true, completion: nil)
            }
            else if indexPath.row == 3{
                let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.type = .deleteStrategy
                vc.investmentStrategyController = investmentStrategyController
                vc.strategy = self.strategy
                self.investmentStrategyController?.present(vc, animated: true)
                self.dismiss(animated: true, completion: nil)
                
            }
        case .withdrawTo:                                                        //Withdraw to
            if indexPath.row == (self.withdrawToAccountData.count - 1){
                let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.network = self.network ?? ""
                self.investStrategyController?.navigationController?.pushViewController(vc, animated: true)
            }else{
                accountSelectedCallback?(withdrawToAccountData[indexPath.row], indexPath.row)
            }
        case .withdrawToEuro:
            if indexPath.row == (self.withdrawToAccountData.count - 1){
                let vc = AddNewRIBVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                vc.isAddingFromWithdraw = true
                self.investStrategyController?.navigationController?.pushViewController(vc, animated: true)
            }else{
                accountSelectedCallback?(withdrawToAccountData[indexPath.row], indexPath.row)
            }
        case .InvestInStrategiesOrAsset:                                                  //Invest in Strategy Or Asset
            if indexPath.row == 0{
                let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
            }else if indexPath.row == 1{
                self.dismiss(animated: true, completion: nil)
                let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                vc.screenType = .singleAssetStrategy
                self.portfolioHomeController?.navigationController?.pushViewController(vc, animated: true)
                
            }
			case .AssetDetailPagePopUp:
				//Detail Page
				if indexPath.row == 0{
                    if (CommonFunctions.getBalance(id: self.coinId ?? "") != nil){
                        let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                        vc.asset = CommonFunctions.getCurrency(id: self.coinId ?? "")
                        self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        CommonFunctions.toster(CommonFunctions.localisation(key: "NO_BALANCE_WITHDRAW"))
                    }
				}else if indexPath.row == 1{
					self.dismiss(animated: true, completion: nil)
					
					PortfolioDetailVM().getResumeByIdApi(assetId: "usdc", completion:{[] response in
						let toAsset = PriceServiceResume(id: "usdc", priceServiceResumeData: response?.data ?? PriceServiceResumeData())
						if(self.idAsset == "usdc"){
							let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
							vc.strategyType = .singleCoin
							vc.asset = toAsset
                            vc.fromAssetId = "eur"
                            vc.toAssetId = toAsset.id
							self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
						}else{
							if(CommonFunctions.getBalance(id: "usdc") != nil){
								let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
								vc.fromAssetId = "usdc"
								vc.toAssetId = self.asset?.id
								vc.fromAssetPrice = response?.data.lastPrice
								vc.toAssetPrice = self.asset?.priceServiceResumeData.lastPrice
								vc.strategyType = .Exchange
								self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: false)
							}else{
								self.presentAlertBuyUsdt(toAsset: toAsset, controller: self.portfolioDetailController ?? UIViewController())
							}
						}
							
					})
					
				}else if indexPath.row == 2{
					let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					vc.screenType = .exchange
					vc.fromAssetId = self.coinId ?? ""
					self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)

				}else if indexPath.row == 3{
                    let vc = CryptoDepositeVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    vc.selectedAsset = CommonFunctions.getCurrency(id: self.idAsset)
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                    
                }else if indexPath.row == 4{
                    let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    vc.typeWithdraw = .send
                    vc.fromAsset = self.coinId ?? ""
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
				}
        default:
            break
        }
    }
}

//MARK: - objective functions
extension DepositeOrBuyVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissBottomView(){
        self.dismiss(animated: false, completion: nil)
    }
}

//MARK: - Other functions
extension DepositeOrBuyVC{
	func presentAlertBuyUsdt(toAsset : PriceServiceResume, controller: UIViewController){
        let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.type = .buyUsdt
        vc.controller = self
        vc.toAsset = toAsset
        controller.navigationController?.present(vc, animated: false)
	}

}

// MARK: - TABLE VIEW OBSERVER
extension DepositeOrBuyVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      self.tblView.reloadData()
    }
      
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.tblView.removeObserver(self, forKeyPath: "contentSize")
		if(self.popupType == .investWithStrategiesActive || self.popupType == .investWithStrategiesInactive)
		{
			self.investmentStrategyController?.deselectAllStrategies()
		}
    }
      
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if let obj = object as? UITableView {
          if obj == self.tblView && keyPath == "contentSize" {
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                print(newSize.height)
                if newSize.height > 500{
                    self.tblViewHeightConst.constant = 500
                }else{
                    self.tblViewHeightConst.constant = newSize.height
                }
            }
          }
      }
    }

}
