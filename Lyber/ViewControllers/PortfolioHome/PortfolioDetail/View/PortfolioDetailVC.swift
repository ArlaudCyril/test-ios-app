//
//  PortfolioDetailVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class PortfolioDetailVC: swipeGesture {
    //MARK: - VARIABLES
    var headerData : [String] = [L10n.MyBalance.description,L10n.MyBalance.description,L10n.Infos.description,L10n.About.description,L10n.Resources.description]
    var assetData : Trending?
    var assetDetailData : AssetDetailApi?
    var assetName : String = ""
    var infoData : [InfoModel] = [
        InfoModel(name: L10n.MarketCap.description, value: "72 083 593 181,6€"),
        InfoModel(name: L10n.Volume.description, value: "72 083 593 181,6€"),
        InfoModel(name: L10n.CirculatingSupply.description, value: "72 083 593 181,6€"),
        InfoModel(name: L10n.Popularity.description, value: "72"),]
    var portfolioDetailVM = PortfolioDetailVM()
    var chartData : chartData?
    var timer = Timer()
    var chartDurationTime = chartType.oneHour.rawValue
    var resoucesData : [newsData] = []
    var webSocket : URLSessionWebSocketTask?
    //MARK: - IB OUTLETS
    @IBOutlet var emptyView: UIView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        callCoinInfoApi()
        self.callChartApi(duration: self.chartDurationTime)
        callResoucesApi()
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webSocket?.cancel(with: .goingAway, reason: nil)
        self.timer.invalidate()
    }
}

//MARK: - SetUpUI
extension PortfolioDetailVC{
    func setUpUI(){
        PortfolioDetailTVC().controller = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
        CommonUI.setUpButton(btn: investMoneyBtn, text: "\(L10n.InvestIN.description)\(L10n.BTC.description)", textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.threeDotBtn.layer.cornerRadius = 16
        self.threeDotBtn.threeDotButtonShadow()
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self , selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
        self.investMoneyBtn.addTarget(self, action: #selector(investMoneyBtnAct), for: .touchUpInside)
        self.threeDotBtn.addTarget(self, action: #selector(threeDotBtnAct), for: .touchUpInside)
    }
    
    @objc func fireTimer(){
//        self.callChartApi(duration: self.chartDurationTime)
    }
}

//Mark: - table view delegates and dataSource
extension PortfolioDetailVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return infoData.count
        }else if section == 3{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioDetailTVC")as! PortfolioDetailTVC
            cell.controller = self
            cell.assetName = self.assetName
            cell.setUpCell(assetData : assetData,chartData : self.chartData)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBalanceTVC")as! MyBalanceTVC
            cell.setUpCell(assetData : assetData)
            cell.controller = self
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfosTVC")as! InfosTVC
            cell.setUpCell(data : infoData[indexPath.row],index: indexPath.row,lastIndex: (infoData.count - 1))
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutTVC")as! AboutTVC
            cell.controller = self
            cell.setUpCell(assetData : assetDetailData)
            return cell
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourcesTVC")as! ResourcesTVC
            cell.resourcesData = resoucesData
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PortfolioDetailHeaderTVC")as! PortfolioDetailHeaderTVC
        cell.setUpCell(data: headerData[section],section : section)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let vc = BalanceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//            vc.assetSymbol = assetData?.symbol ?? ""
//            vc.myAsset = assetData
//            vc.otherAsset = cryptoInfoValues
//            if myAssetsData != nil{
//                vc.myAssetPresent = true
//            }
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
}

//MARK: - objective functions
extension PortfolioDetailVC{
    @objc func threeDotBtnAct(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .AssetDetailPagePopUp
        vc.portfolioDetailScreen = true
//        vc.coinName = self.assetData?.name ?? ""
//        vc.assetsData = self.assetData
        vc.portfolioDetailController = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func investMoneyBtnAct(){
        let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
//        vc.assetsData = self.assetData
        vc.strategyType = .singleCoin
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Other functions
extension PortfolioDetailVC{
    func callCoinInfoApi(){
        CommonFunctions.showLoader(self.view)
        portfolioDetailVM.getCoinInfoApi(Asset: assetName, completion: {[self]response in
            
            self.emptyView.isHidden = true
            self.assetDetailData = response
            if((response) != nil)
            {
                self.infoData[0].value = "\(response?.data?.marketCap ?? "")€"
                self.infoData[1].value = "\(response?.data?.volume24H ?? "")€"
                self.infoData[2].value = "\(response?.data?.circulatingSupply ?? "") \(self.assetName.uppercased() )"
                self.infoData[3].value = "#\(response?.data?.marketRank ?? 0)"
            }
            
            
            DispatchQueue.main.async() {
                self.tblView.reloadData()
            }
            
        })
    }
    
    func callChartApi(duration : String){
        self.portfolioDetailVM.getChartDataApi(AssetId: self.assetName, timeFrame: duration , completion: {[ self]response in
//            if self.chartData?.stats != response?.stats {
            self.chartData = response?.data
            self.tblView.reloadData()
//            }
            CommonFunctions.hideLoader(self.view )
        })
    }
    
    func callResoucesApi(){
        CommonFunctions.showLoader(self.view)
        portfolioDetailVM.getAssetsNewsApi(id: self.assetName, completion: {[self]response in
            CommonFunctions.hideLoader(self.view)
            self.resoucesData = response?.data ?? []
            self.tblView.reloadData()
        })
    }
}
