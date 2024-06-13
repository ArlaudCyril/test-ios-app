//
//  OneTimeInvestmentTVC.swift
//  Lyber
//
//  Created by Lyber on 20/07/2023.
//

import UIKit

class OneTimeInvestmentTVC: UITableViewCell {
	//MARK:- IB OUTLETS
	@IBOutlet var singleAssetVw: UIView!
	@IBOutlet var coinImgView: UIImageView!
	@IBOutlet var statusImgVw: UIImageView!
	@IBOutlet var coinTypeLbl: UILabel!
	
	@IBOutlet var amountVw: UIView!
	@IBOutlet var euroLbl: UILabel!
	@IBOutlet var noOfCoinLbl: UILabel!
	
}

//Mark:- SetUpUI
extension OneTimeInvestmentTVC{
	func setUpCell(data : BundleOneInvestment?){
		let currency = CommonFunctions.getCurrency(id: data?.asset ?? "")
		singleAssetVw.isUserInteractionEnabled = false
		
		self.coinImgView.sd_setImage(with: URL(string: currency.imageUrl ?? ""), completed: nil)
		CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: currency.fullName ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		if(data?.status == "FAILURE"){
			self.statusImgVw.image = UIImage(asset: Assets.red_failure)
			self.amountVw.isHidden = true
		}else{
			self.statusImgVw.image = UIImage(asset: Assets.green_large_tick)
			CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(String(Double(data?.stableAmount ?? "0") ?? 0)) USDC", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(data?.assetAmount ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		}
		
		
		
	}
}

//MARK: - objective functions
extension OneTimeInvestmentTVC{
}
