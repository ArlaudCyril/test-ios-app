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
        buyDepositeModel(icon: Assets.withdraw.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "WITHDRAW"), subName: CommonFunctions.localisation(key: "YOUR_ASSETS_YOUR_BANK_ACCOUNT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.exchange.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "EXCHANGE"), subName: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DEPOSIT"), subName: CommonFunctions.localisation(key: "MONEY_LYBER"), rightBtnName: ""),
//        buyDepositeModel(icon: Assets.sell.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "SELL"), subName: "\(CommonFunctions.localisation(key: "SELL")) \(CommonFunctions.localisation(key: "ASSETS"))", rightBtnName: "")
    ]
    var withdrawToAccountData : [buyDepositeModel] = []
    var connectedAccountAddress : [Address] = []
    
    var withdrawAllData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: "Frida... MX12...3392", subName: CommonFunctions.localisation(key: "BANK_ACCOUNT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""),
    ]
    
    var investInStrategyOrAssetData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "INVEST_IN_STRATEGIES"), subName: CommonFunctions.localisation(key: "BUILD_YOUR_OWN_STRATEGY"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "INVEST_IN_SINGLE_ASSET"), subName: CommonFunctions.localisation(key: "CHOOSE_AMONG_80_DIFFERENT_ASSETS"), rightBtnName: "")
    ]
    
    var investWithStrategiesActiveData: [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.flash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ONE_TIME_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_SINGLETIME"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.pencil.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ADJUST_INVESTMENT"), subName: CommonFunctions.localisation(key: "CHANGE_FREQUENCY_AMOUNT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.coins.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "TAILOR_STRATEGY"), subName: CommonFunctions.localisation(key: "CHANGE_ASSET_REPARTITION"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.pause.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "PAUSE_STRATEGY"), subName: "", rightBtnName: "")
    ]
    
    var investWithStrategiesInactiveData: [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.flash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ONE_TIME_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_SINGLETIME"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.recurrent.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "RECURRENT_INVESTMENT"), subName: CommonFunctions.localisation(key: "EXECUTE_STRATEGY_REGULAR_BASIS"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.coins.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "TAILOR_STRATEGY"), subName: CommonFunctions.localisation(key: "CHANGE_ASSET_REPARTITION"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.trash.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DELETE_STRATEGY"), subName: "", rightBtnName: "")
    ]
    
    var strategy : Strategy = Strategy()
    var assetPagePopUpData : [buyDepositeModel] = []
    var popupType  : bottomPopUp = .DepositeBuy
    var depositeCallback : ((_ index : Int)->())?
    var accountSelectedCallback : ((buyDepositeModel)->())?
    var controller : InvestMoneyVC?, portfolioHomeController : PortfolioHomeVC?,allAssetsController : AllAssetsVC?,portfolioDetailController : PortfolioDetailVC?,investStrategyController : InvestInMyStrategyVC?, investmentStrategyController : InvestmentStrategyVC?
    var portfolioDetailScreen = false
    var specificAssetsArr = ["btc","eth","sol","matic","bnb","usdc","usdt","euroc"]
    var specificAssets = false
	//PortfolioDetailVC
	var previousController = UIViewController()
	var idAsset : String = ""
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
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_EXCHANGE")
        }else if popupType == .withdrawTo{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_TO")
            if self.connectedAccountAddress.count > 0{
                for i in 0...((self.connectedAccountAddress.count) - 1){
                    self.withdrawToAccountData.append(buyDepositeModel(icon: UIImage(),svgUrl: self.connectedAccountAddress[i].logo ?? "", iconBackgroundColor: UIColor.clear, name: self.connectedAccountAddress[i].name , subName: self.connectedAccountAddress[i].address ?? "", rightBtnName: ""))
                }
            }
            self.withdrawToAccountData.insert(buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "ADD")) \(self.assetsData?.name ?? "") \(CommonFunctions.localisation(key: "ADDRESS"))", subName: "Unlimited withdrawal", rightBtnName: ""), at: self.connectedAccountAddress.count )
            self.withdrawToAccountData.insert(buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""), at: ((self.connectedAccountAddress.count ) + 1))
        }else if popupType == .InvestInStrategiesOrAsset{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "INVEST_IN_STRATEGIES_OR_SINGLE_ASSET")
        }else if(popupType == .investWithStrategiesActive || popupType == .investWithStrategiesInactive){
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "INVEST_WITH_STRATEGIES")
        }else if popupType == .withdrawAll{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_TO")
        }else if popupType == .AssetDetailPagePopUp{
            self.depositeOrSingularBuyLbl.text = CommonFunctions.localisation(key: "WITHDRAW_EXCHANGE")
            
            //check for the specific 8 coins
            if specificAssetsArr.contains(self.assetsData?.symbol ?? ""){
                specificAssets = true
                self.assetPagePopUpData  = [
                    buyDepositeModel(icon: Assets.withdraw.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "WITHDRAW")) \(self.assetsData?.symbol?.uppercased() ?? "")", subName: "To your personal wallet", rightBtnName: ""),
                    buyDepositeModel(icon: Assets.exchange.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "EXCHANGE"), subName: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), rightBtnName: ""),
                    buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "DEPOSIT")) \(self.assetsData?.symbol?.uppercased() ?? "")", subName: "To your Lyber wallet", rightBtnName: ""),
                    buyDepositeModel(icon: Assets.sell.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "SELL")) \(self.assetsData?.symbol?.uppercased() ?? "")", subName: "For fiat currency", rightBtnName: ""),]
            }else{
                self.assetPagePopUpData  = [
                    buyDepositeModel(icon: Assets.exchange.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "EXCHANGE"), subName: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), rightBtnName: ""),
                    buyDepositeModel(icon: Assets.sell.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "SELL")) \(self.assetsData?.symbol?.uppercased() ?? "")", subName: "", rightBtnName: ""),
					buyDepositeModel(icon: Assets.money_deposit.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DEPOSIT"), subName: "\(CommonFunctions.localisation(key: "ASSET_LYBER_PART1")) \(self.idAsset.uppercased()) \(CommonFunctions.localisation(key: "ASSET_LYBER_PART2"))", rightBtnName: ""),]
            }
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
        }else if popupType == .withdrawTo{
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
        }else if popupType == .withdrawTo{
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
                vc.screenType = .singleAssets
                self.controller?.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                let vc = DepositFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                self.controller?.navigationController?.pushViewController(vc, animated: true)
            }
        case .withdrawExchange:                                                          //withdraw exchange
            if indexPath.row == 0 || indexPath.row == 1{
                let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                if indexPath.row == 0{
                    vc.screenType = .withdraw
                }else if indexPath.row == 1{
					Storage.previousControllerPortfolioDetailObject = PortfolioHomeVC.self
                    vc.screenType = .exchange
                }
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
            }else if indexPath.row == 2{
                let vc = DepositAssetVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
            }
        case .investWithStrategiesActive:
            if indexPath.row == 0{
                self.dismiss(animated: true, completion: nil)
                let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                if indexPath.row == 0{
                    vc.screenType = .withdraw
                }else if indexPath.row == 1{
                    vc.screenType = .exchange
                }
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
            }else if indexPath.row == 1{
                let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyData = self.strategy
                vc.strategyType = .editActiveStrategy
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
                self.dismiss(animated: true, completion: nil)
                let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                if indexPath.row == 0{
                    vc.screenType = .withdraw
                }else if indexPath.row == 1{
                    vc.screenType = .exchange
                }
                self.portfolioHomeController?.present(nav, animated: true, completion: nil)
                
            }else if indexPath.row == 1{
                let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyData = self.strategy
                vc.strategyType = .activateStrategy
                self.dismiss(animated: true, completion: nil)
                self.investmentStrategyController?.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2{
                self.investmentStrategyController?.tailorStrategy(strategy: self.strategy)
                self.dismiss(animated: true, completion: nil)
            }
            else if indexPath.row == 3{
                self.investmentStrategyController?.deleteStrategy(strategy: self.strategy)
                self.dismiss(animated: true, completion: nil)
            }
        case .withdrawTo:                                                                   //Withdraw to
            if indexPath.row == (self.withdrawToAccountData.count - 2){
                let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.addSelectedCoinAddress = true
                vc.assetData = self.assetsData
                self.investStrategyController?.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == (self.withdrawToAccountData.count - 1){
                let vc = AddBankAccountVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self.investStrategyController?.navigationController?.pushViewController(vc, animated: true)
            }else{
                accountSelectedCallback?(withdrawToAccountData[indexPath.row])
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
                vc.screenType = .singleAssets
                self.portfolioHomeController?.navigationController?.pushViewController(vc, animated: true)
                
            }
        case .AssetDetailPagePopUp:                                                         //Detail Page
            if specificAssets == true{
                if indexPath.row == 0 || indexPath.row == 1{
                    let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    if indexPath.row == 0{
                        vc.strategyType = .withdraw
                    }else if indexPath.row == 1{
                        vc.strategyType = .Exchange
						
                    }
//                    vc.fromCoinData?.totalBalance = assetsData?.total_balance ?? 0
                    vc.assetsData = assetsData
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row == 2{
                    let vc = CryptoDepositeVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row == 3{
                    let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.strategyType = .sell
                    vc.assetsData = assetsData
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if indexPath.row == 0{
					let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					vc.screenType = .exchange
					vc.fromAssetId = self.coinId ?? ""
					Storage.previousControllerPortfolioDetailObject = type(of: self.previousController)
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
                }else if indexPath.row == 1{
                    let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.strategyType = .sell
                    vc.assetsData = assetsData
                    self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
				}else if indexPath.row == 2{
					let vc = CryptoDepositeVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
					vc.selectedAsset = CommonFunctions.getCurrency(id: self.idAsset)
					self.portfolioDetailController?.navigationController?.pushViewController(vc, animated: true)
				}
            }
        default:
            break
        }
    }
}

//MARK: - objective functions
extension DepositeOrBuyVC{
    @objc func cancelBtnAct(){
        if(self.popupType == .investWithStrategiesActive || self.popupType == .investWithStrategiesInactive)
        {
            self.investmentStrategyController?.deselectAllStrategies()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissBottomView(){
        if(self.popupType == .investWithStrategiesActive || self.popupType == .investWithStrategiesInactive)
        {
            self.investmentStrategyController?.deselectAllStrategies()
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Other functions



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
