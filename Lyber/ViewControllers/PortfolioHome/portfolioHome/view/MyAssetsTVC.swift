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
    func setUpCell(data : Asset?,index : Int,lastIndex: Int){
        self.coinImgView.sd_setImage(with: URL(string: data?.coinDetail?.image ?? ""), completed: nil)
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: data?.name ?? "Bitcoin", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunctions.formattedCurrency(from: ((data?.totalBalance ?? 0.0)*(data?.euroAmount ?? 0.0))))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(CommonFunctions.formattedCurrency(from: data?.totalBalance ?? 0.0)) \(data?.assetID ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: CommonFunctions.localisation(key: "FIAT_WALLET"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        
        
        

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
            assetsView.layer.cornerRadius = 16
        }
        
        let singleAssetTap = UITapGestureRecognizer(target: self, action: #selector(singleAssetTapped))
        self.singleAssetVw.addGestureRecognizer(singleAssetTap)
        
        let flatWalletVwTap = UITapGestureRecognizer(target: self, action: #selector(flatWalletVwTapped))
        self.flatWalletVw.addGestureRecognizer(flatWalletVwTap)
        
        assetCallback = {() in
            let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//            vc.assetName = data?.assetName ?? ""
            self.controller?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setEuroAmount(totalAmount : Double){
        self.euroImg.image = Assets.euro.image()
        CommonUI.setUpLbl(lbl: self.euroWalletLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroInWalletLbl, text: "\(CommonFunctions.formattedCurrency(from: totalAmount))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        let singleAssetTap = UITapGestureRecognizer(target: self, action: #selector(singleAssetTapped))
        self.singleAssetVw.addGestureRecognizer(singleAssetTap)
        
        let flatWalletVwTap = UITapGestureRecognizer(target: self, action: #selector(flatWalletVwTapped))
        self.flatWalletVw.addGestureRecognizer(flatWalletVwTap)
        
        assetCallback = {() in
            let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            vc.assetName = "btc"
            self.controller?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - objective functions
extension MyAssetsTVC{
    @objc func singleAssetTapped(){
        assetCallback?()
        
    }
    
    @objc func flatWalletVwTapped(){
        let vc = PaymentFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.controller?.present(nav, animated: true, completion: nil)
    }
}
