//
//  PortfolioHomeTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class MyAssetsTVC: UITableViewCell {
    //MARK: - Variables
    var controller : PortfolioHomeVC?
    var assetCallback : (()->())?
    //MARK:- IB OUTLETS
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
    @IBOutlet var coinsInWalletLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}




//Mark:- SetUpUI
extension MyAssetsTVC{
	func setUpCell(data : Balance?,index : Int, lastIndex : Int){
		
		let currency = CommonFunctions.getCurrency(id: data?.id ?? "")
		let priceCoin = (Double(data?.balanceData.euroBalance ?? "") ?? 0)/(Double(data?.balanceData.balance ?? "") ?? 1)
		
		self.coinImgView.sd_setImage(with: URL(string:currency.imageUrl ?? ""), completed: nil)
		
		CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: currency.fullName ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLblBalance(lbl: self.euroLbl, text: "\((Double(data?.balanceData.euroBalance ?? "0") ?? 0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: CommonFunctions.formattedAssetBinance(value: data?.balanceData.balance ?? "", numberOfDecimals: currency.decimals ?? 0), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))


		flatVw.isHidden = true
		flatWalletVw.isHidden = true
		if index == lastIndex && index == 0{
            assetsView.layer.cornerRadius = 16
            assetsView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
            flatVw.isHidden = false
            flatWalletVw.isHidden = false
		}else if index == lastIndex{
			assetsView.layer.cornerRadius = 16
			assetsView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
			flatVw.isHidden = false
			flatWalletVw.isHidden = false
		}else if index == 0{
			assetsView.layer.cornerRadius = 16
			assetsView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
		}else{
			assetsView.layer.maskedCorners = []
		}
        
        let singleAssetTap = UITapGestureRecognizer(target: self, action: #selector(singleAssetTapped))
        self.singleAssetVw.addGestureRecognizer(singleAssetTap)
        
		//hide euros
		self.flatVw.isHidden = true
		self.flatWalletVw.isHidden = true
		
        
        assetCallback = {() in
            let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			vc.assetId = data?.id ?? ""
			self.controller?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setEuroAmount(totalAmount : Double){
		CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: CommonFunctions.localisation(key: "FIAT_WALLET"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        self.euroImg.image = Assets.euro.image()
        CommonUI.setUpLbl(lbl: self.euroWalletLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroInWalletLbl, text: "\(CommonFunctions.getTwoDecimalValue(number: totalAmount))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        let flatWalletVwTap = UITapGestureRecognizer(target: self, action: #selector(flatWalletVwTapped))
        self.flatWalletVw.addGestureRecognizer(flatWalletVwTap)
        
    }
}

//MARK: - objective functions
extension MyAssetsTVC{
    @objc func singleAssetTapped(){
        assetCallback?()
        
    }
    
    @objc func flatWalletVwTapped(){
        let vc = PaymentFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
		self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
