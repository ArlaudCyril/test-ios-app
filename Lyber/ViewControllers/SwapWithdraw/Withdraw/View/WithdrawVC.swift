//
//  WithdrawAddress.swift
//  Lyber
//
//  Created by Lyber on 01/06/2023.
//


import Foundation
import UIKit

class WithdrawVC: ViewController, UITextFieldDelegate {
	
	//MARK: - Variables
    var typeWithdraw : WithdrawType = .addresses
    
    //Adresses
	var networksArray : [NetworkAsset] = []
	var asset : AssetBaseData?
    
    //Ribs
    var ribsArray : [RibData] = []
	
	//MARK:- IB OUTLETS
    @IBOutlet var backBtn: UIButton!
	@IBOutlet var addRibBtn: UIButton!
	@IBOutlet var withdrawAddressLbl: UILabel!
	@IBOutlet var tblView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		self.backBtn.layer.cornerRadius = 12
		
		self.tblView.delegate = self
		self.tblView.dataSource = self
		
        if(typeWithdraw == .addresses){
            CommonUI.setUpLbl(lbl: self.withdrawAddressLbl, text: CommonFunctions.localisation(key: "WITHDRAW_ON"), textColor: UIColor.Grey423D33, font: UIFont.MabryProBold(Size.Large.sizeValue()))
            self.getNetworks()
            self.addRibBtn.isHidden = true
        }else{
            CommonUI.setUpLbl(lbl: self.withdrawAddressLbl, text: CommonFunctions.localisation(key: "CHOOSE_RIB_WANT_WITHDRAW"), textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
            
            self.addRibBtn.setTitle(CommonFunctions.localisation(key: "ADD_RIB"), for: .normal)
            
            self.addRibBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
        }
        self.withdrawAddressLbl.numberOfLines = 0
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        
	}
}

//MARK: - table view delegates and dataSource
extension WithdrawVC: UITableViewDelegate , UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(typeWithdraw == .addresses){
            return networksArray.count
        }else{
            return ribsArray.count
        }
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(typeWithdraw == .addresses){
            let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawAddressTVC", for: indexPath as IndexPath) as! WithdrawAddressTVC
            cell.configureWithData(data : networksArray[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WithdrawRibTVC", for: indexPath as IndexPath) as! WithdrawRibTVC
            cell.configureWithData(data : ribsArray[indexPath.row])
            return cell
        }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(typeWithdraw == .addresses){
            let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.strategyType = .withdraw
            vc.minimumWithdrawal = self.networksArray[indexPath.row].withdrawMin
            vc.feeWithdrawal = self.networksArray[indexPath.row].withdrawFee
            vc.fromAssetId = self.asset?.id ?? ""
            vc.network = networksArray[indexPath.row]
            vc.numberOfDecimals = self.networksArray[indexPath.row].decimals ?? -1
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.controller = self
            vc.type = .ribSelected
            vc.ribSelected = ribsArray[indexPath.row]
            vc.indexSelected = indexPath.row
            self.present(vc, animated: true, completion: nil)
            vc.deleteCallback = {[] in
                self.getRibs()
            }
        }
	}
}

//MARK: - objective function
extension WithdrawVC{
	@objc func backBtnAct(){
        if(typeWithdraw == .ribs){
            if(!(self.navigationController?.popToViewController(ofClass: ExchangeFromVC.self) ?? false)){
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addBtnAct(){
        let vc = AddNewRIBVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        self.navigationController?.pushViewController(vc, animated: true)
	}
}

//MARK: - Other functions
extension WithdrawVC{
	func getNetworks(){
        PortfolioDetailVM().getCoinInfoApi(AssetId: self.asset?.id ?? "", isNetwork: true, completion: {[self]response in
            if(response != nil){
                self.networksArray = []
                for network in response?.data?.networks ?? []{
                    if(network.isWithdrawalActive == true){
                        self.networksArray.append(network)
                    }
                }
                self.tblView.reloadData()
            }
        })
    }
    
    func getRibs(){
		AddNewRIBVM().getRibsApi(completion: {[self]response in
            if(response != nil){
                self.ribsArray = response?.data ?? []
                self.tblView.reloadData()
            }
        })
	}
}
