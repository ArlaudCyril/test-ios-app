//
//  ConfirmInvestmentVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/06/22.
//

import UIKit
import MultiProgressView

class ConfirmInvestmentVC: UIViewController {
    //MARK: - Variables
    var confirmInvestmentVM = ConfirmInvestmentVM()
    var assetData : Trending?,strategyData : Strategy?
    var totalCoinsInvested = Double(),totalEuroInvested = Double(),exchangeFrom = String(),exchangeTo = String()
    var frequency = String()
    var InvestmentType : InvestStrategyModel = .activateStrategy
    var coinsData : [InvestmentStrategyAsset] = []
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var confirmInvestmentLbl: UILabel!
    @IBOutlet var noOfEuroInvested: UILabel!
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var stackVw: UIStackView!
    
    @IBOutlet var coinPriceVw: UIView!
    @IBOutlet var coinPriceLbl: UILabel!
    @IBOutlet var euroCoinPriceLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var euroAmountLbl: UILabel!
    @IBOutlet var frequencyVw: UIView!
    @IBOutlet var frequencyLbl: UILabel!
    @IBOutlet var frequencyNameLbl: UILabel!
    @IBOutlet var paymentLbl: UILabel!
    @IBOutlet var paymentCardLbl: UILabel!
    @IBOutlet var buyLbl: UILabel!
    @IBOutlet var euroBuyLbl: UILabel!
    @IBOutlet var lyberFeeLbl: UILabel!
    @IBOutlet var euroLyberFeeLBl: UILabel!
    @IBOutlet var totalLbl: UILabel!
    @IBOutlet var totalEuroLbl: UILabel!
    @IBOutlet var allocationView: UIView!
    @IBOutlet var allocationLbl: UILabel!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressBar: MultiProgressView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeight: NSLayoutConstraint!
    
    @IBOutlet var bottomVw: UIView!
    @IBOutlet var confirmInvestmentBtn: PurpleButton!
    @IBOutlet var volatilePriceLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        checkInvestmentType()
    }

}

//MARK: - SetUpUI
extension ConfirmInvestmentVC{
    func setUpUI(){
        self.coinsData = strategyData?.bundle ?? []
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.confirmInvestmentLbl, text: L10n.ConfirmInvestment.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfEuroInvested, text: "100€", textColor: UIColor.PurpleColor, font: UIFont.MabryProMedium(Size.XVLarge.sizeValue()))
        self.stackVw.layer.cornerRadius = 16
        
        CommonUI.setUpLbl(lbl: self.coinPriceLbl, text: "\(assetData?.name ?? "") \(L10n.price.description)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.amountLbl, text: L10n.Amount.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: L10n.Frequency.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.paymentLbl, text: L10n.Payment.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.buyLbl, text: L10n.Buy.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.lyberFeeLbl, text: L10n.LyberFees.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalLbl, text: L10n.Total.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.allocationLbl, text: L10n.Allocation.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.euroCoinPriceLbl, text: "\(CommonFunctions.formattedCurrency(from : self.assetData?.currentPrice ?? 0.0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroAmountLbl, text: "\(CommonFunctions.formattedCurrency(from: totalEuroInvested))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.frequencyNameLbl, text: frequency, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.paymentCardLbl, text: "Mastercard ···· 0103", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroBuyLbl, text: "99,92€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLyberFeeLBl, text: "0.08€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalEuroLbl, text: "\(CommonFunctions.formattedCurrency(from: (totalEuroInvested)+(0.08)))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: bottomVw, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        self.bottomVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.confirmInvestmentBtn.setTitle(L10n.ConfirmInvestment.description, for: .normal)
        CommonUI.setUpLbl(lbl: volatilePriceLbl, text: L10n.priceOfCryptoCurrencyIsvolatile.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: volatilePriceLbl, text: L10n.priceOfCryptoCurrencyIsvolatile.description, lineSpacing: 6, textAlignment: .center)
        
        self.progressBar.delegate = self
        self.progressBar.dataSource = self
        self.progressBar.cornerRadius = 4
        self.progressBar.lineCap = .round
        
        
        collView.delegate = self
        collView.dataSource = self
        setLayout()
        self.collView.reloadData()
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        confirmInvestmentBtn.addTarget(self, action: #selector(confirmInvestmentBtnAct), for: .touchUpInside)
    }
    
    func checkInvestmentType(){
        if InvestmentType == .singleCoin{
            self.coinPriceVw.isHidden = false
            self.allocationView.isHidden = true
            self.progressView.isHidden = true
            self.noOfEuroInvested.text = "\(CommonFunctions.formattedCurrency(from: totalCoinsInvested))"
            self.coinImg.yy_setImage(with: URL(string: self.assetData?.image ?? ""), options: .progressiveBlur)
            if frequency == ""{
                self.frequencyVw.isHidden = true
            }else{
                self.frequencyVw.isHidden = false
            }
        }else if (InvestmentType == .activateStrategy || InvestmentType == .editActiveStrategy){
            self.coinPriceVw.isHidden = true
            self.allocationView.isHidden = false
            for i in 0...(coinsData.count - 1){
                DispatchQueue.main.async {
                    self.progressBar.setProgress(section: i, to: (Float(self.coinsData[i].share ?? 0))/100)
                }
            }
            self.noOfEuroInvested.text = "\(CommonFunctions.formattedCurrency(from: totalEuroInvested))€"
        }else if InvestmentType == .deposit{
            self.coinPriceVw.isHidden = true
            self.allocationView.isHidden = true
            self.progressView.isHidden = true
            self.frequencyVw.isHidden = true
            self.buyLbl.text = L10n.Deposit.description
            self.lyberFeeLbl.text = L10n.DepositFees.description
            self.confirmInvestmentLbl.text = L10n.ConfirmMyDeposit.description
            confirmInvestmentBtn.setTitle(L10n.ConfirmDeposit.description, for: .normal)
        }else if InvestmentType == .Exchange{
            self.noOfEuroInvested.text = "\(totalCoinsInvested) \(exchangeTo)"
            self.confirmInvestmentLbl.text = L10n.ConfirmExchange.description
            self.confirmInvestmentBtn.setTitle(L10n.ConfirmExchange.description, for: .normal)
            self.amountLbl.text = "Exchange From"
            self.euroAmountLbl.text = "\(totalEuroInvested) \(exchangeFrom)"
            self.frequencyLbl.text = "Exchange To"
            self.frequencyNameLbl.text = "\(totalCoinsInvested) \(exchangeTo)"
            self.totalEuroLbl.text = "\(totalCoinsInvested + (0.08)) \(exchangeTo)"
            self.allocationView.isHidden = true
            self.progressView.isHidden = true
        }
    }
}

//MARK: - COLL VIEW DELEGATE AND DATA SOURCE METHODS
extension ConfirmInvestmentVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestMoneyCVC", for: indexPath as IndexPath) as! InvestMoneyCVC
        cell.configureWithData(data : coinsData[indexPath.row], strategyColor: strategyColor[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - objective functions
extension ConfirmInvestmentVC{
    @objc func cancelBtnAct(){
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmInvestmentBtnAct(){
        if InvestmentType == .Exchange{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.exchangeCryptoApi(exchangeFrom: exchangeFrom, exchangeTo: exchangeTo, exchangeFromAmount: totalEuroInvested, exchangeToAmount: totalCoinsInvested, completion: {[weak self]response in
                    self?.confirmInvestmentBtn.hideLoading()
                    if let response = response{
                        print(response)
                        
                        
                        let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        nav.navigationBar.isHidden = true
                        self?.present(nav, animated: true, completion: nil)
                    }
            })
        }else if InvestmentType == .singleCoin{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.InvestOnAssetApi(assetId: assetData?.symbol?.uppercased() ?? "", assetName: assetData?.id ?? "", amount: totalEuroInvested,assetAmount: totalCoinsInvested, frequency: frequency, completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
                if let response = response{
                    print(response)
//                    let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
//                    vc.confirmationType = .Buy
//                    vc.coinInvest = self?.noOfEuroInvested.text
//                    self?.present(vc, animated: true, completion: nil)
//
                    let vc = BuySellPopUpVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    vc.popUpType = .Buy
                    vc.assetData = self?.assetData
                    vc.coinInvest = self?.noOfEuroInvested.text
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        }else if InvestmentType == .activateStrategy{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.activateStrategyApi(strategyName: strategyData?.name ?? "", amount: totalEuroInvested, frequency: frequency, ownerUuid: strategyData?.ownerUuid ?? "",completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
                if let response = response{
                    print(response)
                    let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.isHidden = true
                    self?.present(nav, animated: true, completion: nil)
                }
            })
        }else if InvestmentType == .editActiveStrategy{
            self.confirmInvestmentBtn.showLoading()
            confirmInvestmentVM.editActiveStrategyApi(strategyName: strategyData?.name ?? "", amount: totalEuroInvested, frequency: frequency, ownerUuid: strategyData?.ownerUuid ?? "",completion: {[weak self]response in
                self?.confirmInvestmentBtn.hideLoading()
                if let response = response{
                    print(response)
                    let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.isHidden = true
                    self?.present(nav, animated: true, completion: nil)
                }
            })
        }
    }
}

//MARK: - Other functions
extension ConfirmInvestmentVC{
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 92) / 2, height: 20)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collView.collectionViewLayout = layout
        
//        let height = collViw.collectionViewLayout.collectionViewContentSize.height
        let height = CGFloat((20*((self.coinsData.count+1)/2)) + 12*(self.coinsData.count/2))
        collViewHeight.constant = height
    }
}

//MARK: - Progress View Delegate and DataSourec
extension ConfirmInvestmentVC : MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return coinsData.count
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        sectionView.backgroundColor = strategyColor[section]
//        UIColor.PurpleColor.withAlphaComponent(CGFloat((coinsData[section].allocation ?? 0))/100)
        return sectionView
    }
    
    
}
