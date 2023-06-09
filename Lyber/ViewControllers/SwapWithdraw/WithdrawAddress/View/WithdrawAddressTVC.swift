//
//  WithdrawAddressTVC.swift
//  Lyber
//
//  Created by Lyber on 01/06/2023.
//

import UIKit

class WithdrawAddressTVC: UITableViewCell {
	//MARK:- IB OUTLETS
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
	func configureWithData(withdrawChain: WithdrawalChain, data : String?){
		CommonUI.setUpLbl(lbl: self.withdrawAddressNameLbl, text:" \(CommonFunctions.localisation(key: "WITHDRAW_ON")) \(CommonFunctions.networkDecoder(network: data ?? ""))", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.withdrawAddressDeactivatedLbl, text:" \(CommonFunctions.localisation(key: "DEACTIVATED"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		
		if(withdrawChain.lyberEnabled == false){
			self.isUserInteractionEnabled = false
		}else{
			self.withdrawAddressDeactivatedLbl.isHidden = true
		}
		
	}
}

