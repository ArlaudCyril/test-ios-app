//
//  FrequencyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import UIKit

class FrequencyTVC: UITableViewCell {
    //MARK: - Variables
    var controller : FrequencyVC?
    //MARK: - IB OUTLETS
    @IBOutlet var mainLbl: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var rightArrowbtn: UIButton!
    @IBOutlet var recommendedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FrequencyTVC{
    func setUpCellData(data : buyDepositeModel,index : Int){
        CommonUI.setUpLbl(lbl: self.mainLbl, text: data.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.subLabel, text: data.subName, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.rightArrowbtn, text: data.rightBtnName, textcolor: UIColor.grey877E95, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.recommendedBtn, text: CommonFunctions.localisation(key: "RECOMMENDED") , textcolor: UIColor.PurpleColor, backgroundColor: UIColor.LightPurple, cornerRadius: self.recommendedBtn.layer.bounds.height/2, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        self.recommendedBtn.isHidden = true
        
        if controller?.popUpType == .changeProfile{
            self.subLabel.isHidden = true
        }
    }
}
