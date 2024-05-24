//
//  ExchangeFromVM.swift
//  Lyber
//
//  Created by sonam's Mac on 20/06/22.
//

import UIKit

class ExchangeFromTVC: UITableViewCell {
    var assetCallback : (()->())?
    var controller : ExchangeFromVC?
    //MARK:- IB OUTLETS
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
    @IBOutlet var deactivatedLbl: UILabel!
	
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
}

//Mark:- SetUpUI
extension ExchangeFromTVC{
    func setUpCell(data : Balance?,index : Int,screenType : ExchangeEnum,lastIndex : Int){
		let currency = CommonFunctions.getCurrency(id: data?.id ?? "")
		
		if(currency.isTradeActive ?? true){
			self.deactivatedLbl.isHidden = true
		}else{
			singleAssetVw.isUserInteractionEnabled = false
			CommonUI.setUpLbl(lbl: self.deactivatedLbl, text:" \(CommonFunctions.localisation(key: "DEACTIVATED"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		}
		
        self.coinImgView.sd_setImage(with: URL(string: currency.imageUrl ?? ""), completed: nil)
		CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: currency.fullName ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		
		CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(String(Double(data?.balanceData.euroBalance ?? "0") ?? 0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: CommonFunctions.formattedAssetBinance(value: data?.balanceData.balance ?? "0", numberOfDecimals: currency.decimals ?? 0), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
    }
}

//MARK: - objective functions
extension ExchangeFromTVC{
}
