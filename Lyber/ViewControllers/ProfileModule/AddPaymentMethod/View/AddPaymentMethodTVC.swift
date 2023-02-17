//
//  AddPaymentMethodTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit

class AddPaymentMethodTVC: UITableViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var iconView: UIView!
    @IBOutlet var imgIcon: UIImageView!
    @IBOutlet var mainLbl: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var rightArrowbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension AddPaymentMethodTVC{
    func setUpCellData(data : buyDepositeModel){
        self.imgIcon.image = data.icon
        self.iconView.backgroundColor = data.iconBackgroundColor
        self.iconView.layer.cornerRadius = self.iconView.layer.bounds.width/2
        CommonUI.setUpLbl(lbl: self.mainLbl, text: data.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.subLabel, text: data.subName, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.rightArrowbtn, text: data.rightBtnName, textcolor: UIColor.grey877E95, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
    }
}
