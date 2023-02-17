//
//  ExchAnotherWalletTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit

class ExchAnotherWalletTVC: UITableViewCell {
    var controller : ExchangeFromVC?
    //MARK:- IB OUTLETS
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    @IBOutlet var flatVw: UIView!
    @IBOutlet var flatWalletLbl: UILabel!
    
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
extension ExchAnotherWalletTVC{
    func setUpCell(data : assetsModel,index : Int,screenType : ExchangeEnum){
        self.coinImgView.image = data.coinImg
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: data.coinName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: data.euro, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: data.totalCoin, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: "FIAT Wallet", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        
        if screenType == .exchange{
            self.flatVw.isHidden = true
            singleAssetVw.isHidden = true
        }else{
            self.flatVw.isHidden = false
            self.noOfCoinLbl.isHidden = true
        }
    }
}

//MARK: - objective functions
extension ExchAnotherWalletTVC{
    @objc func viewAllBtnAction(){
        let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.strategyType = .anotherWallet
        self.controller?.navigationController?.pushViewController(vc, animated: true)
       
    }
}
