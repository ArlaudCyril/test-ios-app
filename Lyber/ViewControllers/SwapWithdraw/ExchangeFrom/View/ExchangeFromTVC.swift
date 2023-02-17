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
    @IBOutlet var assetsView: UIView!
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
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
extension ExchangeFromTVC{
    func setUpCell(data : Asset?,index : Int,screenType : ExchangeEnum,lastIndex : Int){
        self.coinImgView.sd_setImage(with: URL(string: data?.coinDetail?.image ?? ""), completed: nil)
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: data?.name ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunction.formattedCurrency(from: ((data?.totalBalance ?? 0.0)*(data?.euroAmount ?? 0.0))))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(CommonFunction.formattedCurrency(from: (data?.totalBalance ?? 0.0)))\(data?.assetID ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.euroImgVw.image = Assets.euro.image()
        CommonUI.setUpLbl(lbl: self.flatEuroLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroInWalletLbl, text: "\(CommonFunction.formattedCurrency(from: totalEuroAvailable))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.flatWalletLbl, text: "FIAT Wallet", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
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
            let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.fromCoinData = data
            vc.assetsData = data?.coinDetail
            self.controller?.navigationController?.pushViewController(vc, animated: true)
            if screenType == .exchange{
                vc.strategyType = .Exchange
            }else if screenType == .withdraw{
                vc.strategyType = .withdraw
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
//        let vc = PaymentFundsVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .fullScreen
//        nav.navigationBar.isHidden = true
//        self.controller?.present(nav, animated: true, completion: nil)
        let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
//        vc.fromCoinData = data
//        vc.assetsData = data?.coinDetail
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        vc.strategyType = .withdrawEuro
    }
}
