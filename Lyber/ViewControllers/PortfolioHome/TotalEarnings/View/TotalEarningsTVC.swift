//
//  TotalEarningsTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 17/06/22.
//

import UIKit

class TotalEarningsTVC: UITableViewCell {
    @IBOutlet var assetsView: UIView!
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    @IBOutlet var flatVw: UIView!
    @IBOutlet var flatWalletLbl: UILabel!
    
    @IBOutlet var flatWalletVw: UIView!
    @IBOutlet var euroImg: UIImageView!
    @IBOutlet var euroWalletLbl: UILabel!
    @IBOutlet var euroInWalletLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Mark:- SetUpUI
extension TotalEarningsTVC{
    func setUpCell(data : Asset?,index : Int,lastIndex: Int){
        self.coinImgView.sd_setImage(with: URL(string: data?.coinDetail?.image ?? ""), completed: nil)
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: data?.name ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunctions.formattedCurrency(from: ((data?.totalBalance ?? 0.0)*(data?.euroAmount ?? 0.0))))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(CommonFunctions.formattedCurrency(from: (data?.totalBalance ?? 0.0))) \(data?.assetID ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: CommonFunctions.localisation(key: "FIAT_WALLET"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        
        self.euroImg.image = Assets.euro.image()
        CommonUI.setUpLbl(lbl: self.euroWalletLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroInWalletLbl, text: "\((CommonFunctions.formattedCurrency(from: totalEuroAvailablePrinting)))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        flatVw.isHidden = true
        flatWalletVw.isHidden = true
        if index == 0{
            assetsView.layer.cornerRadius = 16
            assetsView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if index == lastIndex{
            assetsView.layer.cornerRadius = 16
            assetsView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            flatVw.isHidden = false
            flatWalletVw.isHidden = false
        }else {
            assetsView.layer.cornerRadius = 0
//            flatVw.isHidden = false
        }
    }
}
