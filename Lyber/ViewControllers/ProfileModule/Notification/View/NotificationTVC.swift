//
//  NotificationTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import UIKit

class NotificationTVC: UITableViewCell {
	
	var controller : NotificationVC?
	var notification : NotificationData?
	
	@IBOutlet var dateLbl: UILabel!
	@IBOutlet var bodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension NotificationTVC{
    func setupCell(notification : NotificationData){
		self.notification = notification
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		
		let date = formatter.date(from: notification.date) ?? Date()
		let dateString = dateFormatter.string(from: date)
				
		CommonUI.setUpLbl(lbl: self.dateLbl, text: dateString, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: self.bodyLbl, text: notification.log, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.bodyLbl.numberOfLines = 0
    }
}





