//
//  InfosTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class InfosTVC: UITableViewCell {
//MARK:- IB OUTLETS
    
    @IBOutlet var infoVw: UIView!
    @IBOutlet var infoNameLbl: UILabel!
    @IBOutlet var valueLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//Mark:- SetUpUI
extension InfosTVC{
    func setUpCell(data : InfoModel,index : Int,lastIndex: Int){
        CommonUI.setUpLbl(lbl: self.infoNameLbl, text: data.name, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.valueLbl, text: data.value, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        if index == 0{
            infoVw.layer.cornerRadius = 16
            infoVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if index == lastIndex{
            infoVw.layer.cornerRadius = 16
            infoVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
            infoVw.layer.cornerRadius = 0
        }
    }
}
