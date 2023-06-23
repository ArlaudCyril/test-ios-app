//
//  PortfolioDetailVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import SwiftyJSON
import Charts

class PortfolioDetailVC: SwipeGesture {
    //MARK: - VARIABLES
    var headerData : [String] = [CommonFunctions.localisation(key: "MY_BALANCE"),CommonFunctions.localisation(key: "MY_BALANCE"),CommonFunctions.localisation(key: "INFOS"),CommonFunctions.localisation(key: "ABOUT"),CommonFunctions.localisation(key: "RESOURCES")]
    var assetData : Trending?
    var assetDetailData : AssetDetailApi?
    var assetId : String = ""
    var infoData : [InfoModel] = [
        InfoModel(name: CommonFunctions.localisation(key: "MARKETCAP"), value: "72 083 593 181,6€"),
        InfoModel(name: CommonFunctions.localisation(key: "VOLUME"), value: "72 083 593 181,6€"),
        InfoModel(name: CommonFunctions.localisation(key: "CIRCULATING_SUPPLY"), value: "72 083 593 181,6€"),
        InfoModel(name: CommonFunctions.localisation(key: "POPULARITY"), value: "72"),]
    var portfolioDetailVM = PortfolioDetailVM()
    var chartData : chartData?
    var chartDurationTime = chartType.oneHour.rawValue
    var resourcesData : [newsData] = []
	//Socket
    var webSocket : URLSessionWebSocketTask?
	var isOpened = false
	var portfolioDetailTVC : PortfolioDetailTVC?
	
	//navigation controller
	var previousController = UIViewController()
	static var view : UIView?
	static var staticTblView : UITableView?
	var timer = Timer()
	
	//ConfirmInvestmentVC
	var orderId : String = ""
    //MARK: - IB OUTLETS
    @IBOutlet var emptyView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.receiveMessage()
		}
		
		if(self.orderId != ""){
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				CommonFunctions.showLoaderCheckbox(self.view)
				PortfolioDetailVC.staticTblView = self.tblView
				PortfolioDetailVC.view = self.view
				if(userData.shared.is_push_enabled != 1)//notifications desactivated
				{
					self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
				}
				
			}
		}
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		callCoinInfoApi()
		self.callChartApi(duration: self.chartDurationTime)
		callResoucesApi()
		setUpUI()
	}
	
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
			if(self.previousController is ConfirmInvestmentVC){
				self.navigationController?.deleteToViewController(ofClass: Storage.previousControllerPortfolioDetailObject)
			}
		}
		return true
	}
	
	
	//MARK: - SetUpUI
    override func setUpUI(){
        PortfolioDetailTVC().controller = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
		CommonUI.setUpButton(btn: investMoneyBtn, text: "\(CommonFunctions.localisation(key: "INVEST_IN"))\(self.assetId.uppercased())", textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.threeDotBtn.layer.cornerRadius = 16
        self.threeDotBtn.threeDotButtonShadow()
        
        self.investMoneyBtn.addTarget(self, action: #selector(investMoneyBtnAct), for: .touchUpInside)
        self.threeDotBtn.addTarget(self, action: #selector(threeDotBtnAct), for: .touchUpInside)
		
		let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(moveToNextItem(_:)))
		//rightSwipe.direction = .right
		view.addGestureRecognizer(rightSwipe)
		
		
    }
    
}

//Mark: - table view delegates and dataSource
extension PortfolioDetailVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
		return headerData.count
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
			self.portfolioDetailTVC = cell
            cell.assetName = self.assetId
			cell.setUpCell(assetData : self.assetData,chartData : self.chartData)
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBalanceTVC")as! MyBalanceTVC
            cell.setUpCell(assetId : assetId)
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
            cell.resourcesData = resourcesData
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
    
    
    
}

//MARK: - objective functions
extension PortfolioDetailVC{
    @objc func threeDotBtnAct(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .AssetDetailPagePopUp
		vc.previousController = self.previousController
		vc.idAsset = self.assetId
        vc.portfolioDetailScreen = true
		vc.coinId = self.assetId
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
	
	@objc func fireTimer(){
		portfolioDetailVM.OrderGetOrderApi(orderId: self.orderId, completion: {[]response in
			if(response != nil){
				if(response?.data.orderStatus == "VALIDATED"){
					//success
					PortfolioDetailVC.transactionFinished(success: true)
					self.timer.invalidate()
					self.orderId = ""
				}else if(response?.data.orderStatus == "PENDING" || response?.data.orderStatus == "PROCESSED"){
					//waiting
				}else{
					//error
					CommonFunctions.toster(CommonFunctions.localisation(key: "ERROR_TRANSACTION"))
					PortfolioDetailVC.transactionFinished(success: false)
					self.timer.invalidate()
					self.orderId = ""
				}
			}
		})
	}
	
	@objc func moveToNextItem(_ sender:UISwipeGestureRecognizer) {
		if sender.direction == .right{
			if(self.previousController is ConfirmInvestmentVC){
				self.navigationController?.popToViewController(ofClass: Storage.previousControllerPortfolioDetailObject, animated: true)
			}else{
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
}

//MARK: URLSessionWebSocketDelegate
extension PortfolioDetailVC : URLSessionWebSocketDelegate{
	func receiveMessage() {
		if !isOpened {
			openWebSocket(assetId: assetId)
		}
		self.webSocket?.receive(completionHandler: { [weak self] result in
			switch result {
				case .failure(let error):
					print(error.localizedDescription)
				case .success(let message):
					switch message {
						case .string(let messageString):
							do{
								let data = messageString.data(using: .utf8)
								let jsondata = try JSON(data: data ?? Data())
								let price = (jsondata["Price"].rawValue) as? String
								let value = Double(price ?? "")
								DispatchQueue.main.async {
									if value  != 0{
										self?.portfolioDetailTVC?.euroLbl.text = "\(CommonFunctions.formattedCurrency(from: value ))€"
										self?.portfolioDetailTVC?.valueWebSocket = value ?? 0
										self?.portfolioDetailTVC?.updateValueLastPoint()
									}
								}
							}
							catch let error as NSError {
								print(error)
							}
						case .data(let data):
							print(data.description)
						default:
							print("Unknown type received from WebSocket")
					}
					self?.receiveMessage()
			}
			
		})
		
	}
	
	func openWebSocket(assetId : String) {
		let urlString = ApiEnvironment.socketBaseUrl + "\(assetId)eur"
		if let url = URL(string: urlString) {
			let request = URLRequest(url: url)
			let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
			self.webSocket = session.webSocketTask(with: request)
			self.webSocket?.resume()
		}
	}
	
	func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
		print("Web socket opened")
		isOpened = true
		self.portfolioDetailTVC?.entrySelected = self.portfolioDetailTVC?.graphValues.last ?? ChartDataEntry()
		self.portfolioDetailTVC?.setTimer(timeFrame: "1h")
		self.portfolioDetailTVC?.scaleYChartView = Double(self.portfolioDetailTVC?.chartView.data?.yMax ?? 0) - Double(self.portfolioDetailTVC?.chartView.data?.yMin ?? 0)
		
	}
	
	
	func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
		print("Web socket closed")
		self.timer.invalidate()
		isOpened = false
	}
	
}

//MARK: - Other functions
extension PortfolioDetailVC{
	func callCoinInfoApi(){
		CommonFunctions.showLoader(self.view)
		portfolioDetailVM.getCoinInfoApi(Asset: assetId, completion: {[self]response in
			
			self.emptyView.isHidden = true
			self.assetDetailData = response
			if((response) != nil)
			{
				self.infoData[0].value = "\(response?.data?.marketCap ?? "")€"
				self.infoData[1].value = "\(response?.data?.volume24H ?? "")€"
				self.infoData[2].value = "\(response?.data?.circulatingSupply ?? "") \(self.assetId.uppercased() )"
				self.infoData[3].value = "#\(response?.data?.marketRank ?? 0)"
			}
			
			
			DispatchQueue.main.async() {
				self.tblView.reloadData()
			}
			
		})
	}
	
	func callChartApi(duration : String){
		self.portfolioDetailVM.getChartDataApi(AssetId: self.assetId, timeFrame: duration , completion: {[ self]response in
			//            if self.chartData?.stats != response?.stats {
			self.chartData = response?.data
			self.tblView.reloadData()
			//            }
			CommonFunctions.hideLoader(self.view )
		})
	}
	
	func callResoucesApi(){
		CommonFunctions.showLoader(self.view)
		portfolioDetailVM.getAssetsNewsApi(id: self.assetId, completion: {[self]response in
			CommonFunctions.hideLoader(self.view)
			self.resourcesData = response?.data ?? []
			if(self.resourcesData.isEmpty){
				self.headerData.removeLast()
			}
			self.tblView.reloadData()
		})
	}
}
	
extension PortfolioDetailVC{
	//MARK: Static functions
	
	static func callWalletGetBalance(){
		PortfolioHomeVM().callWalletGetBalanceApi(completion: {[]response in
			if response != nil {
				CommonFunctions.setBalances(balances: response ?? [])
				PortfolioDetailVC.staticTblView?.reloadData()
			}
		})
	}
	
	static func transactionFinished(success: Bool){
		if success == true  {
			CommonFunctions.hideLoaderCheckbox(PortfolioDetailVC.view ?? UIView(), success: true)
			self.callWalletGetBalance()
			
		}else{
			CommonFunctions.hideLoaderCheckbox(PortfolioDetailVC.view ?? UIView(), success: false)
		}
	}
}
