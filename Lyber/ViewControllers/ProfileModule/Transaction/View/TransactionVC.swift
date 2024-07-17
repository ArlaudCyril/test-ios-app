//
//  TransactionVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class TransactionVC: SwipeGesture {
    //MARK: - Variables
    var transactionVM = TransactionVM()
    var transactionDict = [String:[Transaction]]()
    var transactionDictKeys = [String]()
	var totalRows = 0
	var numberOfTransactionsPerRequest = 50
	var bottomReached = false
    //MARK:- IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var transactionLbl: UILabel!
    @IBOutlet var transactionSubLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.callTransactionApi()
        
    }


	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        CommonUI.setUpLbl(lbl: transactionLbl, text: CommonFunctions.localisation(key: "OPERATIONS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: transactionSubLbl, text: CommonFunctions.localisation(key: "LIST_ALL_OPERATIONS"), textColor: UIColor.grey877E95 , font: UIFont.MabryPro(Size.Large.sizeValue()))
        
		tblView.es.addPullToRefresh {
			self.totalRows = 0
			self.numberOfTransactionsPerRequest = 50
			self.transactionDict = [:]
			self.transactionDictKeys = []
			self.callTransactionApi()
			self.tblView.es.stopPullToRefresh()
		}
		
        tblView.delegate = self
        tblView.dataSource = self
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
    }
}

//MARK: - table view delegates and dataSource
extension TransactionVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
		return self.transactionDict.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.transactionDict[transactionDictKeys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.section == tableView.numberOfSections-1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 && !self.bottomReached{
			callTransactionApi()
		}
		
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC", for: indexPath) as! TransactionTVC
		cell.setUpCell(data: self.transactionDict[transactionDictKeys[indexPath.section]]?[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHeaderTVC")as! TransactionHeaderTVC
        cell.setUpCell(data: transactionDictKeys[section])
        return cell
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		let transaction = self.transactionDict[transactionDictKeys[indexPath.section]]?[indexPath.row]
		
		if(transaction?.type == "order"){
			vc.type = .order
			vc.orderId = transaction?.id ?? ""
			vc.status = transaction?.status ?? ""
			vc.from = "\(transaction?.fromAmount ?? "") \(transaction?.fromAsset?.uppercased() ?? "")"
			vc.to = "\(transaction?.toAmount ?? "") \(transaction?.toAsset?.uppercased() ?? "")"
			vc.feesPaid = "\(transaction?.fees ?? "0") \(transaction?.fromAsset?.uppercased() ?? "")"
			vc.date = transaction?.date ?? ""
			
		}else if(transaction?.type == "strategy"){
			vc.type = .strategy
			vc.executionId = transaction?.id ?? ""
			vc.name = transaction?.strategyName ?? ""
            vc.totalStableAmountSpent = "\(transaction?.totalStableAmountSpent ?? "") \(transaction?.asset ?? "")"
            vc.totalFeeSpent = "\(transaction?.totalFeeSpent ?? "0") \(transaction?.fromAsset?.uppercased() ?? "")"
            vc.date = transaction?.date ?? ""
			if(transaction?.nextExecution != nil){
				vc.typeStrategy = CommonFunctions.localisation(key: "RECURRENT")
			}else{
				vc.typeStrategy = CommonFunctions.localisation(key: "SINGLE_EXECUTION")
			}
			
			
		}else if(transaction?.type == "deposit"){
			vc.type = .deposit
			vc.transactionId = transaction?.id ?? ""
			vc.status = transaction?.status ?? ""
			vc.from = transaction?.fromAddress ?? ""
			vc.amount = "\(transaction?.amount ?? "") \(transaction?.asset ?? "")"
			vc.network = transaction?.network ?? ""
            vc.transactionHash = transaction?.txId ?? ""
			vc.date = transaction?.date ?? ""
			
		}else if(transaction?.type == "withdraw"){
            vc.type = .withdraw
            vc.transactionId = transaction?.id ?? ""
            vc.status = transaction?.status ?? ""
            vc.to = transaction?.toAddress ?? ""
            vc.amount = "\(transaction?.amount ?? "") \(transaction?.asset ?? "")"
            vc.date = transaction?.date ?? ""
            
        }else if(transaction?.type == "withdraw_euro"){
			vc.type = .withdrawEuro
			vc.transactionId = transaction?.id ?? ""
			vc.status = transaction?.status ?? ""
			vc.iban = transaction?.iban ?? ""
            vc.amount = "\(transaction?.amount ?? "") \(transaction?.asset?.uppercased() ?? "")"
            vc.feesPaid = CommonFunctions.formattedAssetBinance(value: String((transaction?.eurAmount ?? 0) - (transaction?.eurAmountDeductedLyberFees ?? 0)), numberOfDecimals: 2)
			vc.date = transaction?.date ?? ""
			
		}
		self.present(vc, animated: true)
	}
}

//MARK: - objective functions
extension TransactionVC{
    @objc func cancelBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - other functions
extension TransactionVC{
    func callTransactionApi(){
		transactionVM.getTransactionsApi(limit: numberOfTransactionsPerRequest, offset: totalRows, completion: {[]response in
            if let response = response{
				if(response.data?.count ?? 0 < self.numberOfTransactionsPerRequest){
					//stop requesting
					self.bottomReached = true
				}
				self.totalRows += self.numberOfTransactionsPerRequest
                let validTypes = ["order", "deposit", "withdraw", "strategy", "withdraw_euro"] 
				for transaction in response.data ?? []{
                    if validTypes.contains(transaction.type ?? "") {
                        let date = CommonFunctions.getDateFormat(date:transaction.date ?? "", inputFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat:"dd MMMM yyyy")
                        if(self.transactionDict.keys.contains(date)){
                            self.transactionDict[date]?.append(transaction)
                        }else{
                            self.transactionDict[date] = [transaction]
                        }
                    }
				}
				let dateFormatter = DateFormatter()
				dateFormatter.configureLocale()
				dateFormatter.dateFormat = "dd MMMM yyyy"
				
				for date in Array(self.transactionDict.keys).sorted(by: { dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)! }){
					if(!self.transactionDictKeys.contains(date)){
						self.transactionDictKeys.append(date)
					}
				}
                self.tblView.reloadData()
				
					
            }
        })
    }
}

// MARK: - TABLE VIEW OBSERVER
extension TransactionVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.setUpUI()
    }
}
