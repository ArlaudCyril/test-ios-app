//
//  PortfolioHomeCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class PortfolioHomeCVC: UICollectionViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var timeBtn: UIButton!
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.timeBtn.backgroundColor = UIColor.whiteColor
                self.timeBtn.setTitleColor(UIColor.ThirdTextColor, for: .normal)
            }else {
                self.timeBtn.backgroundColor = UIColor.clear
                self.timeBtn.setTitleColor(UIColor.grey36323C, for: .normal)
        }
    }
  }
}

extension PortfolioHomeCVC{
    func configureWithData(data : String){
        CommonUI.setUpButton(btn: timeBtn, text: data, textcolor: UIColor.grey36323C, backgroundColor: UIColor.clear, cornerRadius: 10, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
    }
}
