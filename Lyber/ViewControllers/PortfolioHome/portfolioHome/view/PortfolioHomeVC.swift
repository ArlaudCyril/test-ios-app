//
//  PortfolioHomeVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

var totalEuroAvailable : Double? = 100
var totalPortfolio : Double = 25.0
var coinDetailData : [AssetBaseData] = []
class PortfolioHomeVC: notSwipeGesture {
    //MARK: - IB OUTLETS
    var headerData : [String] = [L10n.MyAssets.description,L10n.MyAssets.description,L10n.Analytics.description,L10n.RecurringInvestment.description,L10n.AllAssetsAvailable.description]
    var assetsData : [Asset] = []
    var recurringInvestmentData : [Investment] = []
    var allAvailableAssets : [priceServiceResume] = []
    
    var noRecurringInvestment = false
    let group = DispatchGroup()
    var groupLeaved  = false
    //MARK: - IB OUTLETS
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
    @IBOutlet var threeDotBtnWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllAssetsDetail()
//        self.threeDotBtn.backgroundColor = .PurpleColor
//        self.callMyAssetsApi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
//        group.enter()
//        self.callMyAssetsApi()
//        group.enter()
//        self.callRecurringInvestmentApi()
//        group.enter()
        self.getTotalAvailableAssetsApi()
       
//        Activelabel
        
    }
}

//MARK: - SetUpUI
extension PortfolioHomeVC{
    func setUpUI(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        CommonUI.setUpButton(btn: investMoneyBtn, text: L10n.InvestMoney.description, textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.threeDotBtn.layer.cornerRadius = 16
        self.investMoneyBtn.addTarget(self, action: #selector(investMoneyBtnAct), for: .touchUpInside)
        self.threeDotBtn.addTarget(self, action: #selector(threeDotBtnAct), for: .touchUpInside)
        threeDotBtn.threeDotButtonShadow()
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
    }
}

//Mark: - table view delegates and dataSource
extension PortfolioHomeVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else if section == 3{
            return recurringInvestmentData.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAssetsTVC")as! MyAssetsTVC
            cell.coinImgView.image = Assets.bitcoin.image()
            CommonUI.setUpLbl(lbl: cell.coinTypeLbl, text: "Bitcoin", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: cell.euroLbl, text: "987€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: cell.noOfCoinLbl, text: "5 BTC", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
            CommonUI.setUpLbl(lbl: cell.flatWalletLbl, text: "FIAT Wallet", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
//            cell.setUpCell(data: assetsData[indexPath.row],index : indexPath.row,lastIndex: assetsData.count - 1)
            cell.setEuroAmount(totalAmount: totalEuroAvailable ?? 0)
            cell.controller = self
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnalyticsTVC")as! AnalyticsTVC
            cell.controller = self
            cell.setUpCell()
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringTVC")as! RecurringTVC
            cell.setUpCell(data: recurringInvestmentData[indexPath.row],index : indexPath.row,lastIndex: (recurringInvestmentData.count - 1))
            return cell
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
        if section == 0{
            return UIView()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioHeaderTVC")as! PortfolioHeaderTVC
            cell.setUpCell(data: headerData[section],section : section)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            if section == 3{
                return noRecurringInvestment ? 0 :80
            }else{
                return 80
            }
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
        case 0:
            break
        case 3:
            let vc = RecurringDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            vc.investmentId = recurringInvestmentData[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
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
//        self.threeDotBtn.backgroundColor = .PurpleColor
//        self.animateBtn()
      
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
    
    @objc func investMoneyBtnAct(){
            let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.popupType = .InvestInStrategiesOrAsset
            vc.portfolioHomeController = self
            self.present(vc, animated: true, completion: nil)
      
    }
}

//MARK: - Other functions
extension PortfolioHomeVC{
    func callMyAssetsApi(){
        CommonFunctions.showLoader(self.view)
        PortfolioHomeVM().getMyAssetsApi(completion: {[weak self]response in
            if let response = response{
                totalEuroAvailable = response.total_euros_available ?? 0
                self?.assetsData = response.assets ?? []
//                self?.tblView.reloadData()
//                self?.tblView.reloadSections(IndexSet(integer: 1), with: .automatic)
                for i in 0...((self?.assetsData.count ?? 0) - 1){
                    let str = ((self?.assetsData[i].totalBalance ?? 0.0)*(self?.assetsData[i].euroAmount ?? 0.0))
                    totalPortfolio = Double((totalPortfolio ) + Double(str))
                }
//                self?.callRecurringInvestmentApi()
                self?.group.leave()
            }
        })
    }
    
    func callRecurringInvestmentApi(){
        CommonFunctions.showLoader(self.view)
        PortfolioHomeVM().getRecurringInvestmentApi(completion: {[weak self]response in
            if let response = response{
                self?.recurringInvestmentData = response.investments ?? []
                if self?.recurringInvestmentData.count == 0 {
                    self?.noRecurringInvestment = true
                }
//                self?.tblView.reloadData()
//                self?.tblView.layoutIfNeeded()
//                self?.tblView.reloadSections(IndexSet(integer: 3), with: .automatic)
                self?.group.leave()
            }
        })
    }
    
    func getTotalAvailableAssetsApi(){
        self.allAvailableAssets = []
        CommonFunctions.showLoader(self.view)
        AllAssetsVM().getAllAssetsApi( keyword: "", completion: {[]response in
            if let response = response {
                CommonFunctions.hideLoader(self.view )
                for i in 0..<6{
                    self.allAvailableAssets.append(response.data[i])
                }
                self.tblView.reloadData()
            }
        })
        
//        CommonFunction.showLoader(self.view)
//        PortfolioHomeVM().getAllAvailableAssetsApi(order: "volume_desc", completion: {[weak self]response in
//            if let response = response{
//                self?.allAvailableAssets = response.data ?? []
////                self?.tblView.reloadData()
////                self?.tblView.reloadSections(IndexSet(integer: 4), with: .automatic)
//                self?.group.leave()
//            }
//            CommonFunction.hideLoader(self?.view ?? UIView())
//        })
    }
    func getAllAssetsDetail(){
        AllAssetsVM().getAllAssetsDetailApi(completion: {[]response in
            
            if response != nil {
                Storage.currencies = coinDetailData
                
            }
        })
    }

}
