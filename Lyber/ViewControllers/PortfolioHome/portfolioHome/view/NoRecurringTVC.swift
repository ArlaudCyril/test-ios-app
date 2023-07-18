//
//  NoRecurringTVC.swift
//  Lyber
//
//  Created by Lyber on 15/06/2023.
//

import UIKit

class NoRecurringTVC: UITableViewCell {
	
	@IBOutlet var noRecurringVw: UIView!
	@IBOutlet var noRecurringLbl: UILabel!
	@IBOutlet var noRecurringBtn: UIButton!
	
}

extension NoRecurringTVC{
	func setUpCell(){
		self.noRecurringVw.layer.cornerRadius = 16
		CommonUI.setUpLbl(lbl: self.noRecurringLbl, text: CommonFunctions.localisation(key: "NO_ACTIVE_STRATEGIE"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpButton(btn: noRecurringBtn, text: "", textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		noRecurringBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "ACTIVATE_CREATE_ONE")), for: .normal)
	}
}

