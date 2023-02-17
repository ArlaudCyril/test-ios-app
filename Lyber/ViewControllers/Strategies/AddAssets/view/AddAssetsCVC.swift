//
//  addStrategyCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import UIKit

class AddAssetsCVC: UICollectionViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var assetsTypeBtn: UIButton!
    override var isSelected: Bool{
        
        didSet{
            if self.isSelected {
                self.assetsTypeBtn.backgroundColor = UIColor.LightPurple
                self.assetsTypeBtn.setTitleColor(UIColor.PurpleColor, for: .normal)
            }else {
                self.assetsTypeBtn.backgroundColor = UIColor.whiteColor
                self.assetsTypeBtn.setTitleColor(UIColor.grey877E95, for: .normal)
        }
    }
  }
}

//Mark:- SetUpUI
extension AddAssetsCVC{
    func configureWithData(data : String){
        CommonUI.setUpButton(btn: assetsTypeBtn, text: data, textcolor: UIColor.grey877E95, backgroundColor: UIColor.whiteColor, cornerRadius: self.assetsTypeBtn.layer.bounds.height/2, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
    }
}
