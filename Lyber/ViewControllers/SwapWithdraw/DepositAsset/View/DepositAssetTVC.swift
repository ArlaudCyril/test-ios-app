//
//  DepositAssetTVC.swift
//  Lyber
//
//  Created by Lyber on 18/04/2023.
//

import UIKit

class DepositAssetTVC: UITableViewCell {
	//MARK:- IB OUTLETS
	@IBOutlet var coinImg: UIImageView!
	@IBOutlet var coinFullNameLbl: UILabel!
	@IBOutlet var deactivatedLbl: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	
}

//Mark:- SetUpUI
extension DepositAssetTVC{
	func configureWithData(data : AssetBaseData?){
		
		CommonUI.setUpLbl(lbl: self.coinFullNameLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))

		if(data?.isDepositActive == true){
			self.deactivatedLbl.isHidden = true
		}else{
			self.deactivatedLbl.isHidden = false
			CommonUI.setUpLbl(lbl: self.deactivatedLbl, text:" \(CommonFunctions.localisation(key: "DEACTIVATED"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
	
		}
		
		
		for coin in coinDetailData{
			if data?.id == coin.id{
				self.coinImg.sd_setImage(with: URL(string: coin.imageUrl ?? ""))
				self.coinFullNameLbl.text = coin.fullName ?? ""
			}
		}
	}
}
