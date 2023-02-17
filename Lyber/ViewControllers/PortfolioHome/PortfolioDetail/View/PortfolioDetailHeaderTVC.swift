//
//  PortfolioDetailHeaderTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class PortfolioDetailHeaderTVC: UITableViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var headerVw: UIView!
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

extension PortfolioDetailHeaderTVC{
    func setUpCell(data : String,section : Int){
        if section == 1{
            self.headerVw.layer.cornerRadius = 32
            self.headerVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            self.headerVw.backgroundColor = UIColor.whiteColor
        }else{
            self.headerVw.backgroundColor = UIColor.whiteColor
        }
        CommonUI.setUpLbl(lbl: headerLbl, text: data, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
    }
}
