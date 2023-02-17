//
//  NotificationTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import UIKit

class NotificationTVC: UITableViewCell {

    @IBOutlet var notificationLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NotificationTVC{
    func setupCell(text : String){
        CommonUI.setUpLbl(lbl: self.notificationLbl, text: "Lorem ipsum is simply dummy text of the printing and type setting industry ", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
    }
}
