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
		noAssetsBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "DEPOSIT_NOW")), for: .normal)
		noAssetsBtn.addTarget(self, action: #selector(noAssetsBtnAct), for: .touchUpInside)
		
	}
}

extension NoAssetsTVC{
	@objc func noAssetsBtnAct(){
		let vc = DepositAssetVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
		let nav = UINavigationController(rootViewController: vc)
		nav.modalPresentationStyle = .fullScreen
		nav.navigationBar.isHidden = true
		self.controller?.present(nav, animated: false, completion: nil)
	}
}
