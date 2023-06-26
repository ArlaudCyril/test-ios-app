//
//  WithdrawAddress.swift
//  Lyber
//
//  Created by Lyber on 01/06/2023.
//


import Foundation
import UIKit

class WithdrawAddressVC: ViewController, UITextFieldDelegate {
	
	//MARK: - Variables
	var networksArray : [NetworkAsset] = []
	var asset : AssetBaseData?
	
	//MARK:- IB OUTLETS
	@IBOutlet var backBtn: UIButton!
	@IBOutlet var withdrawAddressLbl: UILabel!
	@IBOutlet var tblView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		
		CommonUI.setUpLbl(lbl: self.withdrawAddressLbl, text: CommonFunctions.localisation(key: "WITHDRAW_ON"), textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.backBtn.layer.cornerRadius = 12
		
		self.tblView.delegate = self
		self.tblView.dataSource = self
		
		self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		
		self.getNetworks()
		
		
	}
}

//MARK: - table view delegates and dataSource
extension WithdrawAddressVC: UITableViewDelegate , UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return networksArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawAddressTVC", for: indexPath as IndexPath) as! WithdrawAddressTVC
		cell.configureWithData(data : networksArray[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
		vc.strategyType = .withdraw
		vc.minimumWithdrawal = self.networksArray[indexPath.row].withdrawMin
		vc.feeWithdrawal = self.networksArray[indexPath.row].withdrawFee
		vc.fromAssetId = self.asset?.id ?? ""
		vc.network = networksArray[indexPath.row]
		self.navigationController?.pushViewController(vc, animated: true)
		
	}
}

//MARK: - objective function
extension WithdrawAddressVC{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: true)
	}
	
}

//MARK: - Other functions
extension WithdrawAddressVC{
	func getNetworks(){
		PortfolioDetailVM().getCoinInfoApi(Asset: self.asset?.id ?? "", isNetwork: true, completion: {[self]response in
			if(response != nil){
				self.networksArray = response?.data?.networks ?? []
				self.tblView.reloadData()
			}
			
		})
	}
	
	
}
