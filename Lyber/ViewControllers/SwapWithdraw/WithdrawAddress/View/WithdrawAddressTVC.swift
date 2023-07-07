//
//  WithdrawAddressTVC.swift
//  Lyber
//
//  Created by Lyber on 01/06/2023.
//

import UIKit

class WithdrawAddressTVC: UITableViewCell {
	//MARK:- IB OUTLETS
	@IBOutlet var withdrawAddressImg: UIImageView!
	@IBOutlet var withdrawAddressNameLbl: UILabel!
	@IBOutlet var withdrawAddressDeactivatedLbl: UILabel!
	@IBOutlet var witdrawAddressView: UIView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	
}

//Mark:- SetUpUI
extension WithdrawAddressTVC{//TODO: Verify this
	func configureWithData(data : NetworkAsset?){
		CommonUI.setUpLbl(lbl: self.withdrawAddressNameLbl, text:" \(CommonFunctions.localisation(key: "WITHDRAW_ON")) \(data?.fullName ?? "")", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.withdrawAddressDeactivatedLbl, text:" \(CommonFunctions.localisation(key: "DEACTIVATED"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		self.withdrawAddressImg.sd_setImage(with: URL(string: data?.imageUrl ?? ""), completed: nil)
		
		if(!(data?.isWithdrawalActive ?? false)){
			self.isUserInteractionEnabled = false
		}else{
			self.withdrawAddressDeactivatedLbl.isHidden = true
		}
		
	}
}

