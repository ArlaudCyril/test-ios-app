//
//  ExchangeFromVC.swift
//  Lyber
//
//  Created by sonam's Mac on 20/06/22.
//

import UIKit

class ExchangeFromVC: UIViewController {
    //MARK: - Variables
    var screenType : ExchangeEnum = .exchange
//    var assetsData : [coinsStruct] = [
//        coinsStruct(coinImg: Assets.ether.image(), coinName: L10n.Ether.description, euro: "966.8€", totalCoin: "0.001234 ETH",coin: L10n.ETH.description),
//        coinsStruct(coinImg: Assets.usdc.image(), coinName: L10n.USDC.description, euro: "310€", totalCoin: "322.187 USDC",coin: L10n.USDC.description),
//        coinsStruct(coinImg: Assets.bitcoin.image(), coinName: L10n.Bitcoin.description, euro: "133.8€", totalCoin: "0.001234 BTC",coin: L10n.BTC.description)]
    var assetsData : [Asset] = []
    var walletData : [assetsModel] = [
        assetsModel(coinImg: Assets.euro.image(), coinName: "Euro", euro: "\(totalEuroAvailable ?? 0)€", totalCoin: "0.001234 BTC")]
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
//    @IBOutlet var cancelBtn: UIButton!
//    @IBOutlet var headerLbl: UILabel!
    @IBOutlet var allPortfolioVw: UIView!
    @IBOutlet var allPortfolioImg: UIImageView!
    @IBOutlet var allportfolioLbl: UILabel!
    @IBOutlet var totalEuroLbl: UILabel!
    
    @IBOutlet var lyberPortfolioVw: UIView!
    @IBOutlet var lyberPortfolioLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callMyAssetsApi()
    }

}

//MARK: - SetUpUI
extension ExchangeFromVC{
    func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        CommonUI.setUpLbl(lbl: self.headerView.headerLbl, text: L10n.ExchangeFrom.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.lyberPortfolioLbl, text: L10n.LyberPortfolio.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.allportfolioLbl, text: L10n.AllMyPortfolio.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalEuroLbl, text: "\(CommonFunctions.formattedCurrency(from: totalPortfolio))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if screenType == .exchange{
            self.allPortfolioVw.isHidden = true
        }else if screenType == .withdraw{
            self.allPortfolioVw.isHidden = false
            self.headerView.headerLbl.text = L10n.IWantToWithdraw.description
            self.lyberPortfolioLbl.text = L10n.APreciseAsset.description
        }
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let allPortfolioTap = UITapGestureRecognizer(target: self, action: #selector(WithdrawAllAct))
        self.allPortfolioVw.addGestureRecognizer(allPortfolioTap)
    }
}

//MARK: - table view delegates and dataSource
extension ExchangeFromVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
            return assetsData.count
//        }else{
//            return walletData.count
//        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeFromTVC")as! ExchangeFromTVC
        cell.setUpCell(data: assetsData[indexPath.row],index : indexPath.row,screenType : screenType, lastIndex: assetsData.count - 1)
        cell.controller = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - objective functions
extension ExchangeFromVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func WithdrawAllAct(){
        let vc = WithdrawAllVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Other functions
extension ExchangeFromVC{
    func callMyAssetsApi(){
        CommonFunctions.showLoader(self.view)
        PortfolioHomeVM().getMyAssetsApi(completion: {[weak self]response in
            CommonFunctions.hideLoader(self?.view ?? UIView())
            if let response = response{
                self?.assetsData = response.assets ?? []
                self?.tblView.reloadData()
            }
        })
    }
}
