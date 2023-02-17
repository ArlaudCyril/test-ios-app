//
//  checkAccountCompletedTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit

class checkAccountCompletedTVC: UITableViewCell {
 //MARK: - IB OUTLETS
    @IBOutlet var cellview: UIView!
    @IBOutlet var numberBtn: UIButton!
    @IBOutlet var textLbl: UILabel!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet var strikeThroughLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Mark:- SetUpCells
extension checkAccountCompletedTVC{
    func setUpCell(data : AccountCompletedModel){
//       
        CommonUI.setUpLbl(lbl: textLbl, text: data.text, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: numberBtn, text: "\(data.index)", textcolor: UIColor.grey877E95, backgroundColor: UIColor.whiteColor, cornerRadius: self.numberBtn.layer.bounds.width/2, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
//        self.strikeThroughLine.isHidden = true
        if data.isCompleted{
            self.numberBtn.setImage(Assets.checkmark_color.image(), for: .normal)
            self.numberBtn.setTitle("", for: .normal)
            self.strikeThroughLine.isHidden = false
//            CommonUI.StrikeThroughLabel(lbl: textLbl, textcolor: UIColor.grey877E95)
        }else {
            self.numberBtn.setImage(UIImage(named: ""), for: .normal)
            self.numberBtn.setTitle("\(data.index)", for: .normal)
            self.strikeThroughLine.isHidden = true
//            CommonUI.removeStrikeThrough(lbl: textLbl, textcolor: UIColor.grey877E95)
//            textLbl.attributedText = nil
            textLbl.text = data.text
        }
        
        if data.isPending == true{
            self.rightArrowBtn.isHidden = false
            self.textLbl.textColor = UIColor.PurpleColor
            self.numberBtn.backgroundColor = UIColor.PurpleColor
            self.numberBtn.setTitleColor(UIColor.whiteColor, for: .normal)
            self.textLbl.font = UIFont.MabryProMedium(Size.Large.sizeValue())
        }else{
            self.rightArrowBtn.isHidden = true
            self.textLbl.textColor = UIColor.grey877E95
            self.numberBtn.backgroundColor = UIColor.whiteColor
            self.numberBtn.setTitleColor(UIColor.grey877E95, for: .normal)
            self.textLbl.font = UIFont.MabryPro(Size.Large.sizeValue())
        }
    }
}

