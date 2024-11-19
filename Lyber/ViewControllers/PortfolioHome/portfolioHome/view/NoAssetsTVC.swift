//
//  NoAssetsTVC.swift
//  Lyber
//
//  Created by Lyber on 07/07/2023.
//

import UIKit

class NoAssetsTVC: UITableViewCell {
	var controller: UIViewController?
	
	@IBOutlet var noAssetsVw: UIView!
	@IBOutlet var noAssetsLbl: UILabel!
	@IBOutlet var noAssetsBtn: UIButton!
	
}

extension NoAssetsTVC{
	func setUpCell(){
		self.noAssetsVw.layer.cornerRadius = 16
		CommonUI.setUpLbl(lbl: self.noAssetsLbl, text: CommonFunctions.localisation(key: "NO_ASSETS"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		CommonUI.setUpButton(btn: noAssetsBtn, text: "", textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		noAssetsBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "BUY_USDC")), for: .normal)
		noAssetsBtn.addTarget(self, action: #selector(noAssetsBtnAct), for: .touchUpInside)
		
	}
}

extension NoAssetsTVC{
	@objc func noAssetsBtnAct(){
        noAssetsBtn.isEnabled = false
		PortfolioDetailVM().getResumeByIdApi(assetId: "usdc", completion:{[] response in
            self.noAssetsBtn.isEnabled = true
			let toAsset = PriceServiceResume(id: "usdc", priceServiceResumeData: response?.data ?? PriceServiceResumeData())
			let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
			vc.strategyType = .singleCoin
            vc.asset = toAsset
			vc.fromAssetId = "eur"
            vc.toAssetId = toAsset.id
			self.controller?.navigationController?.pushViewController(vc, animated: true)
		})
	}
}
