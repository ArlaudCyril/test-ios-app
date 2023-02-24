//
//  InvestMoneyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 09/06/22.
//

import UIKit
import MultiProgressView

class InvestMoneyVC: UIViewController {
    //MARK: - Variables
//    var coinsData : [DifferentCoinsModel] = [
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(1), coinName: "USDC", percentage: "40%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.8), coinName: "ETH", percentage: "30%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.5), coinName: "BTC", percentage: "20%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.2), coinName: "SOL", percentage: "10%"),]
    var coinsData : [InvestmentStrategyAsset] = []
    var strategyData : Strategy?
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var investMoneyLbl: UILabel!
    @IBOutlet var usingMyStrategy: UILabel!
    
    @IBOutlet var strategyVw: UIView!
    @IBOutlet var strategyNameLbl: UILabel!
    @IBOutlet var riskLbl: UILabel!
    @IBOutlet var progressVw: MultiProgressView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet var investUsingMyStrategy: PurpleButton!
    @IBOutlet var pickAnotherStrategy: UIButton!
    @IBOutlet var depositBuyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

}

//MARK: - SetUpUI
extension InvestMoneyVC{
    func setUpUI(){
        coinsData = strategyData?.bundle ?? []
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.investMoneyLbl, text: L10n.InvestMoney.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.usingMyStrategy, text: L10n.UsingMyStrategy.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.Header.sizeValue()))
        CommonUI.setUpViewBorder(vw: strategyVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        /*CommonUI.setUpLbl(lbl: self.strategyNameLbl, text: strategyData?.status, textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))*/
        CommonUI.setUpLbl(lbl: self.riskLbl, text: L10n.Risk.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        /*self.riskLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.RiskLow.description, secondStr: strategyData?.risk ?? "", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)*/
        
        self.investUsingMyStrategy.setTitle(L10n.MakeInvestment.description, for: .normal)
        CommonUI.setUpButton(btn: self.pickAnotherStrategy, text: L10n.PickAnotherStrategy.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.borderColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: self.depositBuyBtn, text: L10n.DepositSingularBuy.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.depositBuyBtn.setAttributedTitle(CommonFunctions.underlineString(str: L10n.DepositSingularBuy.description), for: .normal)
        
        self.progressVw.delegate = self
        self.progressVw.dataSource = self
        self.progressVw.cornerRadius = 4
        self.progressVw.lineCap = .round
        for i in 0...(coinsData.count - 1){
//            DispatchQueue.main.async {
            self.progressVw.setProgress(section: i, to: (Float(coinsData[i].share ?? 0))/100)
//            }
        }
        
        
        collView.delegate = self
        collView.dataSource = self
        setLayout()
        self.collView.reloadData()
        
        cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.investUsingMyStrategy.addTarget(self, action: #selector(investUSingStrategyAct), for: .touchUpInside)
        self.pickAnotherStrategy.addTarget(self, action: #selector(pickAnotherStrategyAct), for: .touchUpInside)
        self.depositBuyBtn.addTarget(self, action: #selector(depositBuyBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension InvestMoneyVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func investUSingStrategyAct(){
        let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.strategyCoinsData = coinsData
        vc.strategyData = strategyData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func pickAnotherStrategyAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func depositBuyBtnAct(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .DepositeBuy
        vc.controller = self
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension InvestMoneyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestMoneyCVC", for: indexPath as IndexPath) as! InvestMoneyCVC
        cell.configureWithData(data : coinsData[indexPath.row],strategyColor : strategyColor[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - Other functions
extension InvestMoneyVC{
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 92) / 2, height: 20)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collView.collectionViewLayout = layout
        
//        let height = collViw.collectionViewLayout.collectionViewContentSize.height
        let height = CGFloat((20*((self.coinsData.count+1)/2)) + 12*(self.coinsData.count/2))//CGFloat((20*(self.coinsData.count/2)) + 12)
        collViewHeightConst.constant = height
    }
}

//MARK: - Progress View Delegate and DataSourec
extension InvestMoneyVC : MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return coinsData.count
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        sectionView.backgroundColor = strategyColor[section]
//        UIColor.PurpleColor.withAlphaComponent(CGFloat((coinsData[section].allocation ?? 0))/100)//coinsData[section].coinColor
        return sectionView
    }
}
