//
//  RecurringTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class RecurringTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var recurringVw: UIView!
    @IBOutlet var strategyImgVw: UIImageView!
    @IBOutlet var strategyLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecurringTVC{
    func setUpCell(data : Investment?,index : Int,lastIndex : Int){
        if data?.logo != nil{
            self.strategyImgVw.yy_setImage(with: URL(string: data?.logo ?? ""), options: .progressiveBlur)
        }else{
            self.strategyImgVw.image = Assets.intermediate_strategy.image()
        }
        
        let strategyName = data?.userInvestmentStrategyID == nil ? data?.assetID ?? "" : data?.userInvestmentStrategyID?.strategyName ?? ""
        CommonUI.setUpLbl(lbl: self.strategyLbl, text: strategyName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.timeLbl, text: data?.frequency?.rawValue ?? "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.paymentLbl, text: "Upcoming payment: 29 July", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        let euroAmount = data?.userInvestmentStrategyID != nil ? data?.amount ?? 0 : data?.assetAmount ?? 0
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunctions.formattedCurrency(from: (euroAmount)))€", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        if index == 0{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if index == lastIndex{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
            recurringVw.layer.cornerRadius = 0
        }
        
        if lastIndex == 0{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
}
