//
//  ExchangeFromVC.swift
//  Lyber
//
//  Created by sonam's Mac on 20/06/22.
//

import UIKit

class ExchangeFromVC: ViewController {
    //MARK: - Variables
    var screenType : ExchangeEnum = .exchange
	var toAssetId : String?
	var toAssetPrice : String?
    var walletData : [assetsModel] = [
        assetsModel(coinImg: Assets.euro.image(), coinName: "Euro", euro: "\(totalEuroAvailablePrinting ?? 0)€", totalCoin: "0.001234 BTC")]
    var sendMean = ""
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var lyberPortfolioVw: UIView!
    @IBOutlet var noAssetsLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }



	//MARK: - SetUpUI
    override func setUpUI(){
        self.noAssetsLbl.isHidden = true
        CommonUI.setUpLbl(lbl: self.headerView.headerLbl, text: CommonFunctions.localisation(key: "EXCHANGE_FROM_TITLE"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if screenType == .withdraw{
            self.headerView.headerLbl.text = CommonFunctions.localisation(key: "WANT_WITHDRAW")
        }else if(screenType == .send){
            self.headerView.headerLbl.text = CommonFunctions.localisation(key: "EXCHANGE_FROM_TITLE_SEND")
        }
        
        if(totalPortfolio == 0){
            self.noAssetsLbl.isHidden = false
            self.tblView.isHidden = true
            
            CommonUI.setUpLbl(lbl: self.noAssetsLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            self.noAssetsLbl.attributedText = CommonFunctions.underlineStringInText(str: CommonFunctions.localisation(key: "CLICK_HERE"), text: CommonFunctions.localisation(key: "NO_ASSETS_YET_CLICK_HERE"))
            
            let noAssetsLblTap = UITapGestureRecognizer(target: self, action: #selector(linkTapped))
            self.noAssetsLbl.addGestureRecognizer(noAssetsLblTap)
            
            self.noAssetsLbl.numberOfLines = 0
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
    }
}

//MARK: - table view delegates and dataSource
extension ExchangeFromVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(screenType == .withdraw){
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioHeaderTVC")as! PortfolioHeaderTVC
            if(self.screenType == .exchange){
                cell.setUpCell(data: CommonFunctions.localisation(key: "LYBER_PORTFOLIO"),section : section)
            }else{
                cell.setUpCell(data: CommonFunctions.localisation(key: "MY_CRYPTO_WALLET"),section : section)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioHeaderTVC")as! PortfolioHeaderTVC
            cell.setUpCell(data: CommonFunctions.localisation(key: "MY_BANK_ACCOUNT"),section : section)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return Storage.balances.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeFromTVC")as! ExchangeFromTVC
            cell.setUpCell(data: Storage.balances[indexPath.row],index : indexPath.row,screenType : screenType, lastIndex: Storage.balances.count - 1)
            cell.controller = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeFromTVC")as! ExchangeFromTVC
            if let balance = Storage.balances.first(where: { $0?.id == "usdc" }) {
                cell.setUpCell(data: balance, index: 0, screenType: screenType, lastIndex: 0)
            } else {
                var balance = Balance()
                balance.id = "usdc"
                cell.setUpCell(data: balance, index: 0, screenType: screenType, lastIndex: 0)
            }
            cell.controller = self
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            if(self.screenType == .withdraw){
                let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                vc.asset = CommonFunctions.getCurrency(id: Storage.balances[indexPath.row]?.id ?? "")
                self.navigationController?.pushViewController(vc, animated: true)
            }else if(self.screenType == .withdraw){
                if(self.toAssetId != nil){
                    let balance = CommonFunctions.getBalance(id: Storage.balances[indexPath.row]?.id ?? "")
                    let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.strategyType = .Exchange
                    vc.fromAssetId = Storage.balances[indexPath.row]?.id
                    vc.fromAssetPrice = ((Decimal(string: balance?.balanceData.euroBalance ?? "") ?? 0)/(Decimal(string: balance?.balanceData.balance ?? "") ?? 1)).description
                    vc.toAssetId = self.toAssetId
                    vc.toAssetPrice = self.toAssetPrice
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else{
                    let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                    vc.screenType = .exchange
                    vc.fromAssetId = Storage.balances[indexPath.row]?.id ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else if(self.screenType == .send){
                let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyType = .Send
                vc.sendMean = self.sendMean
                PortfolioDetailVM().getResumeByIdApi(assetId: Storage.balances[indexPath.row]?.id ?? "usdc", completion:{[] response in
                    let toAsset = PriceServiceResume(id: Storage.balances[indexPath.row]?.id ?? "usdc", priceServiceResumeData: response?.data ?? PriceServiceResumeData())
                    let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.strategyType = .Send
                    vc.asset = toAsset
                    vc.fromBalance = Storage.balances[indexPath.row]
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }else if(indexPath.section == 1){
            AddNewRIBVM().getRibsApi(completion: {response in
                if response != nil{
                    if(response?.data.count ?? 0 <= 0){
                        let vc = AddNewRIBVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                        vc.typeWithdraw = .ribs
                        vc.ribsArray = response?.data ?? []
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
}

//MARK: - objective functions
extension ExchangeFromVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func linkTapped(){
        PortfolioDetailVM().getResumeByIdApi(assetId: "usdc", completion:{[] response in
            let toAsset = PriceServiceResume(id: "usdc", priceServiceResumeData: response?.data ?? PriceServiceResumeData())
            let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.type = .buyUsdt
            vc.controller = self
            vc.toAsset = toAsset
            self.navigationController?.present(vc, animated: false)
        })
    }
}

//MARK: - Other functions
extension ExchangeFromVC{
  
}
