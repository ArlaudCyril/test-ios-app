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
//    @IBOutlet var flatVw: UIView!
//    @IBOutlet var flatWalletLbl: UILabel!
//    @IBOutlet var anotherWalletVw: UIView!
//    @IBOutlet var anotherWalletBtn: UIButton!
    
    @IBOutlet var EuroVw: UIView!
    @IBOutlet var euroImgVw: UIImageView!
    @IBOutlet var flatEuroLbl: UILabel!
    @IBOutlet var euroInWalletLbl: UILabel!
    @IBOutlet var coinsInWalletLbl: UILabel!
    @IBOutlet var flatVw: UIView!
    @IBOutlet var flatWalletLbl: UILabel!
    
    
}

//Mark:- SetUpUI
extension ExchangeFromTVC{
    func setUpCell(data : Balance?,index : Int,screenType : ExchangeEnum,lastIndex : Int){
		let currency = CommonFunctions.getCurrency(id: data?.id ?? "")
		
		if(currency.isWithdrawalActive ?? true){
			self.deactivatedLbl.isHidden = true
		}else{
			singleAssetVw.isUserInteractionEnabled = false
			CommonUI.setUpLbl(lbl: self.deactivatedLbl, text:" \(CommonFunctions.localisation(key: "DEACTIVATED"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		}
		
        self.coinImgView.sd_setImage(with: URL(string: currency.imageUrl ?? ""), completed: nil)
		CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: currency.fullName ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		
		CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(String(Double(data?.balanceData.euroBalance ?? "0") ?? 0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(data?.balanceData.balance ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.euroImgVw.image = Assets.euro.image()
        CommonUI.setUpLbl(lbl: self.flatEuroLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroInWalletLbl, text: "\(CommonFunctions.formattedCurrency(from: totalEuroAvailablePrinting))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: CommonFunctions.localisation(key: "FIAT_WALLET"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        self.coinsInWalletLbl.isHidden = true
        
        
        flatVw.isHidden = true
        EuroVw.isHidden = true
        if index == lastIndex{
            flatVw.isHidden = false
            EuroVw.isHidden = false
        }
        
        let singleAssetTap = UITapGestureRecognizer(target: self, action: #selector(singleAssetTapped))
        self.singleAssetVw.addGestureRecognizer(singleAssetTap)
        
        let flatWalletVwTap = UITapGestureRecognizer(target: self, action: #selector(flatWalletVwTapped))
        self.EuroVw.addGestureRecognizer(flatWalletVwTap)
        
        assetCallback = {() in
			if(self.controller?.screenType == .exchange)
			{
				if(self.controller?.toAssetId != nil){
					let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
					vc.strategyType = .Exchange
					vc.fromAssetId = data?.id
					vc.toAssetId = self.controller?.toAssetId
					self.controller?.navigationController?.pushViewController(vc, animated: true)
				}
				else{
					let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					vc.screenType = .exchange
					vc.fromAssetId = data?.id ?? ""
					self.controller?.navigationController?.pushViewController(vc, animated: true)
				}
			}
			else if(self.controller?.screenType == .withdraw){
				let vc = WithdrawAddressVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
				vc.asset = CommonFunctions.getCurrency(id: data?.id ?? "") 
				self.controller?.navigationController?.pushViewController(vc, animated: true)
				
			}
        }
    }
}

//MARK: - objective functions
extension ExchangeFromTVC{
    @objc func singleAssetTapped(){
        assetCallback?()
        
    }
    
    @objc func flatWalletVwTapped(){
        let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        vc.strategyType = .withdrawEuro
    }
}
