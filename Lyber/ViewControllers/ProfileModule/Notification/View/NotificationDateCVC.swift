//
//  NotificationDateCVC.swift
//  Lyber
//
//  Created by Lyber on 26/07/2023.
//


import UIKit

class NotificationDateCVC: UICollectionViewCell {
	@IBOutlet var dateLbl: UILabel!
}

//Mark: - SetUpUI
extension NotificationDateCVC{
	func setUpUI(date: String){
		CommonUI.setUpLbl(lbl: self.dateLbl, text: date, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		
	}
	
}
//MARK: - objective functions
extension NotificationDateCVC{
	
	
}
