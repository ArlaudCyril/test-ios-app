//
//  DepositeOrBuyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import UIKit

class DepositeOrBuyTVC: UITableViewCell {
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

extension DepositeOrBuyTVC{
    func setUpCellData(data : buyDepositeModel){
        if data.svgUrl == "" || data.svgUrl == nil{
            self.imgIcon.image = data.icon
        }else{
//            self.imgIcon.setSvgImage(from: URL(string: data.svgUrl ?? "") )
            self.imgIcon.sd_setImage(with: URL(string: data.svgUrl ?? ""))
        }
//
        self.iconView.backgroundColor = data.iconBackgroundColor
        self.iconView.layer.cornerRadius = self.iconView.layer.bounds.width/2
        CommonUI.setUpLbl(lbl: self.mainLbl, text: data.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.subLabel, text: data.subName, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.rightArrowbtn, text: data.rightBtnName, textcolor: UIColor.grey877E95, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
    }
}
