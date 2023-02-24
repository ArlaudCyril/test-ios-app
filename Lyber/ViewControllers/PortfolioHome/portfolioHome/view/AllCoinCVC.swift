//
//  AllCoinCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class AllCoinCVC: UICollectionViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var coinVw: UIView!
    @IBOutlet var coinImgVw: UIImageView!
    @IBOutlet var coinNameLbl: UILabel!
    @IBOutlet var coinPercentageLbl: UILabel!
}

extension AllCoinCVC{
    func configureWithData(data : AllAssetsData?,assetDetail : AssetDetailData?){
        self.coinVw.layer.cornerRadius = 16
        self.coinImgVw.sd_setImage(with: URL(string: assetDetail?.image ?? ""), completed: nil)
        CommonUI.setUpLbl(lbl: coinNameLbl, text: data?.id?.uppercased() ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: coinPercentageLbl, text: "\(CommonFunctions.formattedCurrency(from: Double(data?.change ?? "")))%", textColor: (Double(data?.change ?? "") ?? 0)<0 ? UIColor.RedDF5A43 : UIColor.GreenColor, font: UIFont.MabryPro(Size.Medium.sizeValue()))
    }
}
