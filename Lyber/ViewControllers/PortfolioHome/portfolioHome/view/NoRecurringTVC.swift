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
	
}

extension NoRecurringTVC{
	func setUpCell(){
		self.noRecurringVw.layer.cornerRadius = 16
		CommonUI.setUpLbl(lbl: self.noRecurringLbl, text: CommonFunctions.localisation(key: "NO_ACTIVE_STRATEGIES"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
	}
}

