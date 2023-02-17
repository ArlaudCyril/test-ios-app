//
//  InvestmentStrategyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit
import MultiProgressView

var strategyColor : [UIColor] = [UIColor(named: "purple_800") ?? UIColor(),UIColor(named: "purple_600") ?? UIColor(),UIColor(named: "purple_400") ?? UIColor(),UIColor(named: "purple_200") ?? UIColor(),UIColor(named: "purple_100") ?? UIColor(),UIColor(named: "purple_00") ?? UIColor(),UIColor.LightPurple,UIColor.LightPurple,UIColor.LightPurple,UIColor.LightPurple]

class InvestmentStrategyTVC: UITableViewCell {
    //MARK: - Variables
//    var coinsData : [DifferentCoinsModel] = [
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(1), coinName: "USDC", percentage: "40%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.8), coinName: "ETH", percentage: "30%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.5), coinName: "BTC", percentage: "20%"),
//        DifferentCoinsModel(coinColor: UIColor.PurpleColor.withAlphaComponent(0.2), coinName: "SOL", percentage: "10%"),]
    var investmentStrategyAssets : [InvestmentStrategyAsset] = []
    
    //MARK:- IB OUTLETS
    @IBOutlet var strategyVw: UIView!
    @IBOutlet var strategyTypeLbl: UILabel!
    @IBOutlet var selectStrategyBtn: UIButton!
    @IBOutlet var riskLbl: UILabel!
    @IBOutlet var progressVw: MultiProgressView!
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension InvestmentStrategyTVC{
    func setUpCell(data : Strategy?){
        investmentStrategyAssets = data?.bundle ?? []
        CommonUI.setUpViewBorder(vw: strategyVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        CommonUI.setUpLbl(lbl: self.strategyTypeLbl, text: data?.name ?? "", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
         
        
        /*CommonUI.setUpLbl(lbl: self.riskLbl, text: L10n.RiskLow.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))*/
        /*self.riskLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.RiskLow.description, secondStr: data?.risk ?? "", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)*/
        collView.delegate = self
        collView.dataSource = self
        progressVw.delegate = self
        progressVw.dataSource = self
        setLayout()
        self.collView.reloadData()
        
        self.progressVw.cornerRadius = 4
        self.progressVw.lineCap = .round
        for i in 0...((investmentStrategyAssets.count) - 1){
//            DispatchQueue.main.async {
                self.progressVw.setProgress(section: i, to: (Float(data?.bundle?[i].share ?? 0))/100)
//            }
        }
        
        
        if data?.isSelected == true{
            strategyVw.layer.backgroundColor = UIColor.LightPurple.cgColor
            strategyVw.layer.borderColor = UIColor.PurpleColor.cgColor
            selectStrategyBtn.setImage(Assets.radio_select.image(), for: .normal)
        }else{
            strategyVw.layer.backgroundColor = UIColor.whiteColor.cgColor
            strategyVw.layer.borderColor = UIColor.greyColor.cgColor
            selectStrategyBtn.setImage(Assets.radio_unselect.image(), for: .normal)
        }
        
    }
}

//MARK:- TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension InvestmentStrategyTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return investmentStrategyAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestmentStrategyCVC", for: indexPath as IndexPath) as! InvestmentStrategyCVC
        cell.configureWithData(data : investmentStrategyAssets[indexPath.row],strategyColor : strategyColor[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: ((collView.layer.bounds.width)/2) , height: (collView.layer.bounds.height))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - Progress View Delegate and DataSourec
extension InvestmentStrategyTVC : MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return investmentStrategyAssets.count
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        DispatchQueue.main.async {
            sectionView.backgroundColor = strategyColor[section]
        }
       
//        UIColor.PurpleColor.withAlphaComponent(CGFloat((investmentStrategyAssets[section].allocation ?? 0))/100)//coinsData[section].coinColor
        return sectionView
    }
    
}

//MARK: - Other functions
extension InvestmentStrategyTVC{
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 92) / 2, height: 20)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collView.collectionViewLayout = layout
        
//        let height = collViw.collectionViewLayout.collectionViewContentSize.height
        let height = CGFloat((20*((self.investmentStrategyAssets.count+1)/2)) + 12*(self.investmentStrategyAssets.count/2))
        collViewHeightConst.constant = height
    }
}
