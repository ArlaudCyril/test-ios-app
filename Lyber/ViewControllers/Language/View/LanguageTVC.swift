//
//  LanguageTVC.swift
//  Lyber
//
//  Created by Lyber on 28/03/2023.
//

import Foundation
import UIKit

class LanguageTVC: UITableViewCell {
	
	@IBOutlet var languageLbl: UILabel!
	@IBOutlet var languageImg: UIImageView!
	@IBOutlet var selectedImg: UIImageView!
	@IBOutlet var view: UIView!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

extension LanguageTVC{
	func setupCell(language : Language){
		self.view.backgroundColor = UIColor(named: "purpleGrey_50")
		self.selectedImg.image = UIImage(asset: Assets.checkmark_color)
		CommonUI.setUpLbl(lbl: self.languageLbl, text: language.name, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		self.languageImg.image = UIImage(asset: language.image)
		if(userData.shared.language == language.id){
			self.selectedImg.isHidden = false
		}else{
			self.selectedImg.isHidden = true
		}
	}
}
