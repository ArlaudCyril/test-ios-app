//
//  OneTimeInvestmentVC.swift
//  Lyber
//
//  Created by Lyber on 20/07/2023.
//

import UIKit
import MultiProgressView

class OneTimeInvestmentVC: ViewController {
	//MARK: - Variables
	var oneInvestment : OneInvestment? = nil
	
	//MARK: - IB OUTLETS
	@IBOutlet var oneTimeInvestmentLbl: UILabel!
	@IBOutlet var statusImg: UIImageView!
	@IBOutlet var tblView: UITableView!
	
	@IBOutlet var thanksBtn: PurpleButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		self.tblView.delegate = self
		self.tblView.dataSource = self
		
		if(oneInvestment?.status == "FAILURE"){
			
			CommonUI.setUpLbl(lbl: self.oneTimeInvestmentLbl, text: CommonFunctions.localisation(key: "INVESTMENT_FAILED"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
			self.statusImg.image = UIImage(asset: Assets.red_failure)
			
		}else if(oneInvestment?.status == "PARTIAL_SUCCESS"){
			
			CommonUI.setUpLbl(lbl: self.oneTimeInvestmentLbl, text: CommonFunctions.localisation(key: "INVESTMENT_PARTIALLY_VALIDATED"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
			self.statusImg.image = UIImage(asset: Assets.orange_alert)
			
		}else{
			
			CommonUI.setUpLbl(lbl: self.oneTimeInvestmentLbl, text: CommonFunctions.localisation(key: "INVESTMENT_VALIDATED"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
			self.statusImg.image = UIImage(asset: Assets.green_large_tick)
		}
		
		self.thanksBtn.setTitle(CommonFunctions.localisation(key: "THANKS"), for: .normal)
		
		self.thanksBtn.addTarget(self, action: #selector(thanksBtnAct), for: .touchUpInside)
	}
}

//MARK: - table view delegates and dataSource
extension OneTimeInvestmentVC : UITableViewDelegate,UITableViewDataSource{
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if(oneInvestment?.status == "FAILURE")
		{
			return oneInvestment?.failedBundleEntries?.count ?? 0
		}else{
			return oneInvestment?.successfulBundleEntries?.count ?? 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "OneTimeInvestmentTVC")as! OneTimeInvestmentTVC
		if(oneInvestment?.status == "FAILURE"){
			cell.setUpCell(data: oneInvestment?.failedBundleEntries?[indexPath.row], status: "FAILURE")
		}else{
			cell.setUpCell(data: oneInvestment?.successfulBundleEntries?[indexPath.row], status: "SUCCESS")
		}
		
		return cell
		
	}
}

//MARK: - objective functions
extension OneTimeInvestmentVC{
	@objc func thanksBtnAct(){
		self.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self)
	}
}

