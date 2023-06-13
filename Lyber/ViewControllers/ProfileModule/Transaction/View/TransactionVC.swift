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
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.callTransactionApi()
        
    }


	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: transactionLbl, text: CommonFunctions.localisation(key: "OPERATIONS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: transactionSubLbl, text: CommonFunctions.localisation(key: "LIST_ALL_OPERATIONS"), textColor: UIColor.grey877E95 , font: UIFont.MabryPro(Size.Large.sizeValue()))
        
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
				
				for transaction in response.data ?? []{
					let date = CommonFunctions.getDateFormat(date:transaction.date ?? "", inputFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat:"dd MMMM yyyy")
					if(self.transactionDict.keys.contains(date)){
						self.transactionDict[date]?.append(transaction)
					}else{
						self.transactionDict[date] = [transaction]
					}
				}
				let dateFormatter = DateFormatter()
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
              self.tblViewHeightConst.constant = newSize.height
            }
          }
      }
    }
}
