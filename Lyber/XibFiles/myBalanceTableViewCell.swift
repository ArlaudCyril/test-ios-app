//
//  myBalanceTableViewCell.swift
//  Lyber
//
//  Created by Lyber on 04/09/2023.
//

import UIKit
import DropDown

class myBalanceTableViewCell: DropDownCell {
	
	@IBOutlet var euroLbl: UILabel!
	@IBOutlet var nbOfCoinLbl: UILabel!
	@IBOutlet var coinImgVw: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
