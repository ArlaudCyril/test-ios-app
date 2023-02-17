//
//  InvestMoneyCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 09/06/22.
//

import UIKit

class InvestMoneyCVC: UICollectionViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var coinView: UIView!
    @IBOutlet var coinNameLbl: UILabel!
    @IBOutlet var percentageBtn: UIButton!
}

extension InvestMoneyCVC{
    func configureWithData(data : InvestmentStrategyAsset,strategyColor : UIColor){
        self.coinView.layer.cornerRadius = 2
        self.coinView.backgroundColor = strategyColor
//        UIColor.PurpleColor.withAlphaComponent(CGFloat((data.allocation ?? 0))/100)
        CommonUI.setUpLbl(lbl: self.coinNameLbl, text: data.asset?.uppercased() ?? "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpButton(btn: percentageBtn, text: "\(data.share ?? 0)%", textcolor: UIColor.grey36323C, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
    }
    
    
//    func configureWithData2(data : DifferentCoinsModel){
//        self.coinView.layer.cornerRadius = 2
//        self.coinView.backgroundColor = data.coinColor
//        CommonUI.setUpLbl(lbl: self.coinNameLbl, text: data.coinName , textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
//        CommonUI.setUpButton(btn: percentageBtn, text: "\(data.percentage)", textcolor: UIColor.grey36323C, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
//    }
}
