//
//  MyBalanceTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import DropDown

class MyBalanceTVC: UITableViewCell {
    var assetId = String()
	var controller = PortfolioDetailVC()
    //MARK:- IB OUTLETS
    @IBOutlet var assetsView: UIView!
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    
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
extension MyBalanceTVC{
    func setUpCell(assetId : String?){
        let balance = CommonFunctions.getBalance(id: assetId ?? "")
        let priceCoin = (Double(balance?.balanceData.euroBalance ?? "" ) ?? 0)/(Double(balance?.balanceData.balance ?? "" ) ?? 1)
        let coin = CommonFunctions.getCurrency(id: assetId ?? "")
        self.assetsView.layer.cornerRadius = 16
        self.singleAssetVw.layer.cornerRadius = 16
        
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLblBalance(lbl: self.euroLbl, text: "\(Double(balance?.balanceData.euroBalance ?? "") ?? 0)€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: CommonFunctions.formattedAssetBinance(value: balance?.balanceData.balance ?? "0", numberOfDecimals: coin.decimals ?? 0), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.percentageLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.percentageLbl.isHidden = true
        self.coinTypeLbl.text = "\(coin.fullName ?? "")"
        self.coinImgView.sd_setImage(with: URL(string: coin.imageUrl ?? ""), completed: nil)
    }
}

//MARK: Other functions
extension MyBalanceTVC{
}
