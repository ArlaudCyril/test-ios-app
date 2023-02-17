//
//  TransactionVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class TransactionVC: UIViewController {
    //MARK: - Variables
    var transactionVM = TransactionVM()
    var sectionData = ["15 april 2022"]
//    var transactionData : [TransactionModel] = [
//        TransactionModel(coinImg: Assets.money_deposit.image(), transactionType: "\(L10n.Bought.description)BTC", date: "15/04/2022", euro: "+20€", noOfCoin: "0.0002 BTC"),
//        TransactionModel(coinImg: Assets.exchange.image(), transactionType: "\(L10n.Exch.description)BTC → ETH", date: "15/04/2022", euro: "-0.0002 BTC", noOfCoin: "0.0002 ETH"),
//        TransactionModel(coinImg: Assets.withdraw.image(), transactionType: "\(L10n.Withdrawal.description)", date: "12/04/2022", euro: "-100€", noOfCoin: "0.0002 BTC")]
    var transactionData : [Transaction] = []
    var totalSection = [String:[Transaction]]()
    var arrOfKeys: [String] = []
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
}

//MARK: - SetUpUI
extension TransactionVC{
    func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: transactionLbl, text: L10n.Transaction.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: transactionSubLbl, text: L10n.ListOfAllTransactions.description, textColor: UIColor.grey877E95 , font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        tblView.delegate = self
        tblView.dataSource = self
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
    }
}

//MARK: - table view delegates and dataSource
extension TransactionVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return totalSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
        return totalSection[arrOfKeys[section]]?.count ?? 0
//        }else if section == 1{
//            return 1
//        }else if section == 2{
//            return 2
//        }
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVC")as! TransactionTVC
        cell.setUpCell(data: totalSection[arrOfKeys[indexPath.section]]?[indexPath.row], section: indexPath.section,row: indexPath.row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionHeaderTVC")as! TransactionHeaderTVC
        cell.setUpCell(data: arrOfKeys[section],section : section)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//    }
    
}

//MARK: - objective functions
extension TransactionVC{
    @objc func cancelBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - objective functions
extension TransactionVC{
    func callTransactionApi(){
        CommonFunction.showLoader(self.view)
        transactionVM.getAllTransactionsApi(completion: {[]response in
            CommonFunction.hideLoader(self.view)
            if let response = response{
                print(response)
                self.transactionData = response.transactions ?? []
                
                let datesArray = self.transactionData.compactMap { CommonFunction.getDateFromUnixInterval(timeResult: Double($0.createdAt ?? "") ?? 0, requiredFormat: "dd MMM yyyy") } // return array of date
                print("datesArray",datesArray)
                var dic = [String:[Transaction]]() // Your required result
                datesArray.forEach {
                    let dateKey = $0
                    let filterArray = self.transactionData.filter { CommonFunction.getDateFromUnixInterval(timeResult: Double($0.createdAt ?? "") ?? 0, requiredFormat: "dd MMM yyyy") == dateKey }
                    dic[$0] = filterArray
                }
                print("dic is ",dic)
                self.totalSection = dic
                self.arrOfKeys = Array(dic.keys)
                print("arrOfkeys", self.arrOfKeys)
                
                
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
