//
//  InvestmentStrategyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit
import MultiProgressView

var strategyColor : [UIColor] = [UIColor.purple_800,UIColor.purple_600,UIColor.purple_400,UIColor.purple_200,UIColor.purple_100,UIColor.purple_00,UIColor.LightPurple,UIColor.LightPurple,UIColor.LightPurple,UIColor.LightPurple]

class InvestmentStrategyTVC: UITableViewCell {
    //MARK: - Variables
    var investmentStrategyAssets : [InvestmentStrategyAsset] = []
	var isLastElement = false
    
    //MARK: - IB OUTLETS
    @IBOutlet var strategyVw: UIView!
    @IBOutlet var strategyTypeLbl: UILabel!
    @IBOutlet var activatedLbl: UILabel!
	
    @IBOutlet var riskLbl: UILabel!
    @IBOutlet var riskIcon: UIImageView!
    @IBOutlet var yieldLbl: UILabel!
    @IBOutlet var yieldIcon: UIImageView!
	
	@IBOutlet var minInvestLbl: UILabel!
    @IBOutlet var minInvestIcon: UIImageView!
	
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountIcon: UIImageView!
    @IBOutlet var frequenceLbl: UILabel!
    @IBOutlet var frequenceIcon: UIImageView!
	
    @IBOutlet var informationsView: UIView!
    @IBOutlet var defaultStrategyView: UIView!
    @IBOutlet var activeStrategyView: UIView!
	
    @IBOutlet var viewBottomToInformationView: NSLayoutConstraint!
    @IBOutlet var viewBottomToActiveStrategyView: NSLayoutConstraint!
	
    @IBOutlet var progressVw: MultiProgressView!
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension InvestmentStrategyTVC{
	func setUpCell(data : Strategy?, isLastRow : Bool = false){
		self.isLastElement = isLastRow
        investmentStrategyAssets = data?.bundle ?? []
        
        defaultStrategyView.isHidden = true
        activeStrategyView.isHidden = true
		activatedLbl.isHidden = true
        
        CommonUI.setUpViewBorder(vw: strategyVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        CommonUI.setUpLbl(lbl: self.strategyTypeLbl, text: data?.name ?? "", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
		
		self.minInvestLbl.attributedText = CommonUI.showAttributedString(firstStr: "\(CommonFunctions.localisation(key: "MINIMUM_INVESTMENT")) : ", secondStr: "\(data?.minAmount ?? 0) USDT", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
         
        collView.delegate = self
        collView.dataSource = self
        progressVw.delegate = self
        progressVw.dataSource = self
        setLayout()
        self.collView.reloadData()
        
        self.progressVw.cornerRadius = 4
        self.progressVw.lineCap = .round
        for i in 0...((investmentStrategyAssets.count) - 1){
            DispatchQueue.main.async {
                self.progressVw.setProgress(section: i, to: (Float(data?.bundle[i].share ?? 0))/100)
            }
        }
        
        if data?.isSelected == true{
            strategyVw.layer.backgroundColor = UIColor.LightPurple.cgColor
            strategyVw.layer.borderColor = UIColor.PurpleColor.cgColor
        }
		if data?.activeStrategy != nil{
			activatedLbl.isHidden = false
			CommonUI.setUpLbl(lbl: self.activatedLbl, text: CommonFunctions.localisation(key: "ENABLED"), textColor: UIColor.Green_500, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
		}
		
		if(data?.activeStrategy == nil && data?.risk == nil && data?.expectedYield == nil){
			viewBottomToInformationView.constant = 0
		}else if(data?.activeStrategy == nil){
			viewBottomToInformationView.constant = 50
		}else if(data?.risk == nil && data?.expectedYield == nil){
			viewBottomToInformationView.constant = 50
			viewBottomToActiveStrategyView.constant = 3.5
		}
        
        //MARK: - Default strategy and Active strategy
        if(data?.activeStrategy != nil || (data?.risk != nil && data?.expectedYield != nil))
        {
            //Default strategy
			if(data?.risk != nil && data?.expectedYield != nil)
            {
				self.riskLbl.attributedText = CommonUI.showAttributedString(firstStr: "\(CommonFunctions.localisation(key: "RISK")) : ", secondStr: CommonFunctions.localisation(key: data?.risk?.uppercased() ?? ""), firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                self.yieldLbl.attributedText = CommonUI.showAttributedString(firstStr: "\(CommonFunctions.localisation(key: "YIELD")) : ", secondStr: CommonFunctions.localisation(key: data?.expectedYield?.uppercased() ?? ""), firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                defaultStrategyView.isHidden = false
                    
            }
            
            //Active strategy
            if(data?.activeStrategy != nil)
            {
                self.frequenceLbl.attributedText = CommonUI.showAttributedString(firstStr:" \(CommonFunctions.localisation(key: "FREQUENCY")) : ", secondStr: CommonFunctions.frequenceDecoder(frequence: data?.activeStrategy?.frequency), firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                
                self.amountLbl.attributedText = CommonUI.showAttributedString(firstStr: "\(CommonFunctions.localisation(key: "AMOUNT")) : ", secondStr: String(data?.activeStrategy?.amount ?? 0)+"€", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                
                activeStrategyView.isHidden = false
            }
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
        cell.configureWithData(data : investmentStrategyAssets[indexPath.row],strategyColor : CommonFunctions.selectorStrategyColor(position : indexPath.row, totalNumber : investmentStrategyAssets.count))
        return cell
    }
    
    
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
        //2DispatchQueue.main.async {
            sectionView.backgroundColor = CommonFunctions.selectorStrategyColor(position : section, totalNumber : self.investmentStrategyAssets.count)
        //}
       
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

        let height = CGFloat((20*((self.investmentStrategyAssets.count+1)/2)) + 12*(self.investmentStrategyAssets.count/2))
        collViewHeightConst.constant = height
		
		if(isLastElement){
			collViewHeightConst.constant += 50
		}
			
    }
    
}
