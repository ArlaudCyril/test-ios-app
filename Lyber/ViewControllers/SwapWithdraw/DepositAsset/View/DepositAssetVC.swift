//
//  DepositAssetVC.swift
//  Lyber
//
//  Created by Lyber on 17/04/2023.
//

import Foundation
import UIKit

class DepositAssetVC: ViewController, UITextFieldDelegate {

	//MARK: - Variables
	var allAssetsVM = AllAssetsVM()
	var coinsData : [AssetBaseData] = []
	var originalData : [AssetBaseData] = []
	var filteredData : [AssetBaseData] = []
	var filterCoin : [AssetBaseData] = []
	
	//MARK:- IB OUTLETS
	@IBOutlet var closeBtn: UIButton!
	@IBOutlet var euroBtn: UIButton!
	@IBOutlet var depositAssetLbl: UILabel!
	@IBOutlet var searchView: UIView!
	@IBOutlet var searchTF: UITextField!
	@IBOutlet var tblView: UITableView!
	@IBOutlet var availbaleFlatLbl: UILabel!
	@IBOutlet var euroLbl: UILabel!
	@IBOutlet var euroDescriptionLbl: UILabel!
	@IBOutlet var euroImg: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		
		CommonUI.setUpLbl(lbl: self.depositAssetLbl, text: CommonFunctions.localisation(key: "ASSET_DEPOSIT"), textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.availbaleFlatLbl, text: CommonFunctions.localisation(key: "CRYPTO"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
		CommonUI.setUpLbl(lbl: self.euroLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.euroDescriptionLbl, text: CommonFunctions.localisation(key: "CREDIT_CARD_BANK_TRANSFER"), textColor: UIColor.PurpleGrey_500, font: UIFont.MabryProLight(Size.Medium.sizeValue()))
		CommonUI.setUpViewBorder(vw: searchView, radius: 12, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
		
		self.searchTF.placeholder = CommonFunctions.localisation(key: "SEARCH")
		
		self.filteredData = coinDetailData
		self.closeBtn.layer.cornerRadius = 12
		
		searchTF.delegate = self
		self.tblView.delegate = self
		self.tblView.dataSource = self
		
		searchTF.addTarget(self, action: #selector(searchTextChange), for: .editingChanged)
		self.closeBtn.addTarget(self, action: #selector(closeBtnAct), for: .touchUpInside)
		self.euroBtn.addTarget(self, action: #selector(euroBtnAct), for: .touchUpInside)
		
	
		self.callGetAssetsApi()
		
		
	}
}

//MARK: - table view delegates and dataSource
extension DepositAssetVC: UITableViewDelegate , UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filterCoin.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DepositAssetTVC", for: indexPath as IndexPath) as! DepositAssetTVC
		cell.configureWithData(data : filterCoin[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = CryptoDepositeVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
		vc.selectedAsset = filterCoin[indexPath.row]
		self.navigationController?.pushViewController(vc, animated: true)
		
	}
}

//MARK: - objective function
extension DepositAssetVC{
	@objc func closeBtnAct(){
		self.dismiss(animated: true)
	}
	
	@objc func euroBtnAct(){
		let vc = PaymentFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
}

//MARK: - Other functions
extension DepositAssetVC{
	func callGetAssetsApi(isEmpty : Bool = false){
		allAssetsVM.getAllAssetsDetailApi(completion: {[]response in
			if let response = response {
				print(response)
				self.originalData = response
				self.coinsData = response
			}
			self.filterCoin = self.coinsData
			/*self.tblView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tblView.bounds.width, height: CGFloat(0)))
			self.tblView.tableHeaderView?.isHidden = true
			self.tblView.es.stopPullToRefresh()
			self.tblView.tableFooterView?.isHidden = true
			CommonFunctions.hideLoader(self.view)*/
			
			self.tblView.reloadData()
			
		})
	}
	
	
	@objc func searchTextChange(){
		if searchTF.text == ""{
			self.filteredData = coinDetailData
			self.filterCoin = self.coinsData
		}else{
			self.filterCoin = []

			self.filteredData = coinDetailData.filter({
				($0.id?.hasPrefix(searchTF.text ?? "") ?? false) || ($0.fullName?.lowercased().hasPrefix(searchTF.text?.lowercased() ?? "") ?? false)
				
			})
			print(filteredData)
			for i in 0..<self.filteredData.count{
				print(self.filteredData[i].id ?? "")
				
				for k in 0..<self.coinsData.count{
					if self.coinsData[k].id == self.filteredData[i].id ?? ""{
						filterCoin.append(self.coinsData[k])
						print("filterCoin coins data",filterCoin)
					}
				}
			}
		}
		
		print("coins data",coinsData)
		self.tblView.reloadData()
		
	}
}
