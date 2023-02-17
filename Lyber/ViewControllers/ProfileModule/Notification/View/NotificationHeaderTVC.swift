//
//  NotificationHeaderTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 18/07/22.
//

import UIKit

class NotificationHeaderTVC: UITableViewCell {

    @IBOutlet var headerLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension NotificationHeaderTVC{
    func setUpCell(data : String){
        CommonUI.setUpLbl(lbl: headerLbl, text: data, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Large.sizeValue()))
    }
}
