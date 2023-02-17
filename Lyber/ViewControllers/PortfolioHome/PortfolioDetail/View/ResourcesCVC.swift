//
//  ResourcesCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class ResourcesCVC: UICollectionViewCell {
    @IBOutlet var resourceImg: UIImageView!
    @IBOutlet var resoucesLbl: UILabel!
}

//Mark:- SetUpUI
extension ResourcesCVC{
    func configureWithData(data : newsData?){
        self.resourceImg.layer.cornerRadius = 8
        self.resourceImg.yy_setImage(with: URL(string: data?.image_url ?? ""), options: .progressiveBlur)
        CommonUI.setUpLbl(lbl: self.resoucesLbl, text: data?.title ?? "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
    }
}
