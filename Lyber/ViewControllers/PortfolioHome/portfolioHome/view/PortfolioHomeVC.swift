//
//  PortfolioHomeVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

var totalEuroAvailable : Double? = 0
var totalEuroAvailablePrinting : Double? = 0
var totalPortfolio : Double = 0
var coinDetailData : [AssetBaseData] = []
class PortfolioHomeVC: NotSwipeGesture {
    //MARK: - IB OUTLETS
    var headerData : [String] = []
    var assetsData : [Asset] = []
    var recurringInvestmentData : [RecurrentInvestmentStrategy] = []
    var allAvailableAssets : [PriceServiceResume] = []
    var hasToShowLoader = false
	var typeLoader = ""
    var timer = Timer()
    var timerVerificationSigning = Timer()
    
    //MARK: - IB OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
    @IBOutlet var threeDotBtnWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
		self.getTotalAvailableAssetsApi()
		GlobalVariables.isLogin = false
		if(self.hasToShowLoader == true){
            if(self.typeLoader == "kyc"){
                CommonFunctions.showLoader()
            }else{
                CommonFunctions.showLoaderSigning()
            }
			self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
		}
		
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
		self.callWalletGetBalance()
		self.getAllAssetsDetail()
		self.callActiveStrategies()
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		self.timer.invalidate()
        self.invalidateTimerVerificationKycSigning()
	}


	//MARK: - SetUpUI
    override func setUpUI(){
		self.headerData = [CommonFunctions.localisation(key: "MY_ASSETS"),CommonFunctions.localisation(key: "VERIFICATION"),CommonFunctions.localisation(key: "MY_ASSETS")/*,CommonFunctions.localisation(key: "ANALYTICS")*/,CommonFunctions.localisation(key: "RECURRING_INVESTMENT"),CommonFunctions.localisation(key: "ALL_ASSETS_AVAILABLE")]
		print(userData.shared.userSigned)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        CommonUI.setUpButton(btn: investMoneyBtn, text: CommonFunctions.localisation(key: "INVEST_MONEY"), textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.threeDotBtn.layer.cornerRadius = 16
        self.investMoneyBtn.addTarget(self, action: #selector(investMoneyBtnAct), for: .touchUpInside)
        self.threeDotBtn.addTarget(self, action: #selector(threeDotBtnAct), for: .touchUpInside)
        threeDotBtn.threeDotButtonShadow()
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
		
		tblView.es.addPullToRefresh {
			self.callWalletGetBalance()
            self.getTotalAvailableAssetsApi()
			self.tblView.es.stopPullToRefresh()
		}
    }
}

//Mark: - table view delegates and dataSource
extension PortfolioHomeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            if(userData.shared.userSigned == true){
                return 0
            }else{
                return 1
            }
        }else if section == 2{
			return Storage.balances.count == 0 ? 4: Storage.balances.count
        }else if section == 3{
            return 1
        }else if section == 4{
			return recurringInvestmentData.count == 0 ? 1: recurringInvestmentData.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioHomeTVC")as! PortfolioHomeTVC
            cell.setUpCell()
            cell.controller = self
            return cell
        }else if indexPath.section == 1{
            if(userData.shared.userSigned == true){
                return UITableViewCell()
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "VerificationKycSigningTVC")as! VerificationKycSigningTVC
                cell.setUpCell()
                cell.portolioHomeVC = self
                return cell
            }
        }else if indexPath.section == 2{
			if(Storage.balances.count > 0){
				let cell = tableView.dequeueReusableCell(withIdentifier: "MyAssetsTVC")as! MyAssetsTVC
				cell.setEuroAmount(totalAmount: totalEuroAvailablePrinting ?? 0)
				cell.controller = self
				cell.setUpCell(data: Storage.balances[indexPath.row],index : indexPath.row, lastIndex: Storage.balances.count - 1)
				return cell
			}else{
				if(indexPath.row == 0){
					let cell = tableView.dequeueReusableCell(withIdentifier: "NoAssetsTVC")as! NoAssetsTVC
					cell.controller = self
					cell.setUpCell()
					return cell
				}else if(indexPath.row == 1){
					let cell = tableView.dequeueReusableCell(withIdentifier: "MyAssetsTVC")as! MyAssetsTVC
					let balanceData = BalanceData(balance: "0", euroBalance: "0")
					let balance = Balance(id: "btc", balanceData: balanceData)
					cell.controller = self
					cell.setUpCell(data: balance,index : 0, lastIndex: 2)
					return cell
				}else if(indexPath.row == 2){
					let cell = tableView.dequeueReusableCell(withIdentifier: "MyAssetsTVC")as! MyAssetsTVC
					let balanceData = BalanceData(balance: "0", euroBalance: "0")
					let balance = Balance(id: "eth", balanceData: balanceData)
					cell.controller = self
					cell.setUpCell(data: balance,index : 1, lastIndex: 2)
					return cell
				}else{
					let cell = tableView.dequeueReusableCell(withIdentifier: "MyAssetsTVC")as! MyAssetsTVC
					let balanceData = BalanceData(balance: "0", euroBalance: "0")
					let balance = Balance(id: "usdt", balanceData: balanceData)
					cell.controller = self
					cell.setUpCell(data: balance,index : 2, lastIndex: 2)
					return cell
				}
			}
        }
//        else if indexPath.section == 2{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsTVC")as! AnalyticsTVC
//            cell.controller = self
//            cell.setUpCell()
//			cell.callWalletGetPerformance()
//            return cell
//        }
    else if indexPath.section == 3 {
			if(recurringInvestmentData.count != 0){
				let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringTVC")as! RecurringTVC
				cell.setUpCell(data: recurringInvestmentData[indexPath.row],index : indexPath.row,lastIndex: (recurringInvestmentData.count - 1))
				return cell
			}else{
				let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecurringTVC")as! NoRecurringTVC
				cell.setUpCell()
				cell.controller = self
				return cell
			}
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllAssetsAvailableTVC")as! AllAssetsAvailableTVC
            cell.controller = self
            cell.setUpCell()
            return cell
        }else{
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || (section == 1 && userData.shared.userSigned == true) {
            return UIView()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioHeaderTVC")as! PortfolioHeaderTVC
            cell.setUpCell(data: headerData[section],section : section)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || (section == 1 && userData.shared.userSigned == true) {
            return 0
        }else{
			return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 4:
				let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
				let nav = UINavigationController(rootViewController: vc)
				nav.modalPresentationStyle = .fullScreen
				nav.navigationBar.isHidden = true
				self.present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
}

//MARK: - objective functions
extension PortfolioHomeVC{
    @objc func threeDotBtnAct(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .withdrawExchange
        vc.portfolioHomeController = self
        self.present(vc, animated: true, completion: nil)
      
    }
    
    func animateBtn(){
        UIView.animate(withDuration: 0.3,delay: 0 , options: .curveEaseOut,animations: { () -> Void in
            self.threeDotBtn.alpha = 0.6
            self.threeDotBtnWidth.constant = 60
        },completion : {_ in
            UIView.animate(withDuration: 0.2,delay: 0, options: .curveEaseIn, animations: { () -> Void in
                self.threeDotBtn.alpha = 0.4
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.threeDotBtnWidth.constant = 64
//                })
            },completion: {_ in
                UIView.animate(withDuration: 0.2,delay: 0, animations: { () -> Void in
                    self.threeDotBtn.alpha = 0.2
                    self.threeDotBtnWidth.constant = 68
                },completion: {_ in
                    UIView.animate(withDuration: 0.2,delay: 0, animations: { () -> Void in
                        self.threeDotBtn.alpha = 1
                        self.threeDotBtnWidth.constant = 56
                    },completion: {_ in
                        self.animateBtn()
                    })
                })
            })
            
        })
    }
    
    func invalidateTimerVerificationKycSigning(){
        self.timerVerificationSigning.invalidate()
    }
    
    @objc func investMoneyBtnAct(){
            let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.popupType = .InvestInStrategiesOrAsset
            vc.portfolioHomeController = self
            self.present(vc, animated: true, completion: nil)
      
    }
	
	@objc func fireTimer(){
        
        ProfileVM().getProfileDataApi(completion: {[]response in
            if response != nil{
                if(self.typeLoader == "kyc"){
                    if(response?.data?.kycStatus?.decoderKycStatus == .pending || response?.data?.kycStatus?.decoderKycStatus == .rejected){
                        CommonFunctions.hideLoader()
                        self.timer.invalidate()
                    }
                }else{
                    if(response?.data?.yousignStatus == "SIGNED"){
                        CommonFunctions.hideLoaderSigning(success: true)
                        self.timer.invalidate()
                        
                        self.tblView.reloadData()
                    }
                }
            }
        })
	}
}

//MARK: - Other functions
extension PortfolioHomeVC{
    func callActiveStrategies(){
		CommonFunctions.showLoader(self.view)
        PortfolioHomeVM().getActiveStrategiesApi(completion: {[weak self]response in
            if let response = response{
				CommonFunctions.hideLoader(self?.view ?? UIView() )
                self?.recurringInvestmentData = response.data ?? []
				self?.tblView.reloadData()
            }
        })
    }
    
    func getTotalAvailableAssetsApi(){
        self.allAvailableAssets = []
        CommonFunctions.showLoader(self.view)
        AllAssetsVM().getAllAssetsApi(completion: {[]response in
            if let response = response {
                CommonFunctions.hideLoader(self.view )
                for i in 0..<6{
                    self.allAvailableAssets.append(response[i])
                }
                self.tblView.reloadData()
            }
		})
        
    }
    func getAllAssetsDetail(){
        AllAssetsVM().getAllAssetsDetailApi(completion: {[]response in
            
            if response != nil {
                Storage.currencies = coinDetailData
                
            }
        })
    }
	func callWalletGetBalance(){
		PortfolioHomeVM().callWalletGetBalanceApi(completion: {[]response in
            if response != nil {
				CommonFunctions.setBalances(balances: response ?? [])
				self.tblView.reloadData()
            }
        })
    }
}
