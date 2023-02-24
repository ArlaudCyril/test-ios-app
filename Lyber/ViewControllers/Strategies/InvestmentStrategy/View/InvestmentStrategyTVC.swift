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
    var investmentStrategyAssets : [InvestmentStrategyAsset] = []
    
    //MARK: - IB OUTLETS
    @IBOutlet var strategyVw: UIView!
    @IBOutlet var strategyTypeLbl: UILabel!
    @IBOutlet var selectStrategyBtn: UIButton!
    @IBOutlet var riskLbl: UILabel!
    @IBOutlet var riskIcon: UIImageView!
    @IBOutlet var yieldLbl: UILabel!
    @IBOutlet var yieldIcon: UIImageView!
    @IBOutlet var amountLbl: UILabel!
    @IBOutlet var amountIcon: UIImageView!
    @IBOutlet var frequenceLbl: UILabel!
    @IBOutlet var frequenceIcon: UIImageView!
    @IBOutlet var informationsView: UIView!
    @IBOutlet var defaultStrategyView: UIView!
    @IBOutlet var activeStrategyView: UIView!
    @IBOutlet var informationViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var progressVw: MultiProgressView!
    
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension InvestmentStrategyTVC{
    func setUpCell(data : Strategy?){
        investmentStrategyAssets = data?.bundle ?? []
        
        var informationHeight = 0
        defaultStrategyView.isHidden = true
        activeStrategyView.isHidden = true
        informationsView.isHidden = true
        
        CommonUI.setUpViewBorder(vw: strategyVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        CommonUI.setUpLbl(lbl: self.strategyTypeLbl, text: data?.name ?? "", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
         
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
                self.progressVw.setProgress(section: i, to: (Float(data?.bundle?[i].share ?? 0))/100)
            }
        }
        
        
        if data?.isSelected == true{
            strategyVw.layer.backgroundColor = UIColor.LightPurple.cgColor
            strategyVw.layer.borderColor = UIColor.PurpleColor.cgColor
            
        }
        
        if data?.activeStrategy != nil{
            selectStrategyBtn.layer.cornerRadius = selectStrategyBtn.frame.height/2
            selectStrategyBtn.backgroundColor = UIColor.UIColorFromRGB(rgbValue: 0x1EB35A)
        }
        
        //MARK: - Default strategy and Active strategy
        if(data?.activeStrategy != nil || (data?.risk != nil && data?.expectedYield != nil))
        {
            informationsView.isHidden = false
            
            //Default strategy
            if(data?.risk != nil && data?.expectedYield != nil)
            {
                informationHeight += 50
                self.riskLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.Risk.description, secondStr: data?.risk?.capitalizedSentence ?? "", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                self.yieldLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.Yield.description, secondStr: data?.expectedYield?.capitalizedSentence ?? "", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                defaultStrategyView.isHidden = false
                    
            }
            
            //Active strategy
            if(data?.activeStrategy != nil)
            {
                informationHeight += 50
                self.frequenceLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.Frequency.description, secondStr: CommonFunctions.frequenceMapper(frequence: data?.activeStrategy?.frequency), firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                
                self.amountLbl.attributedText = CommonUI.showAttributedString(firstStr: L10n.Amount.description, secondStr: String(data?.activeStrategy?.amount ?? 0)+"€", firstFont: UIFont.MabryPro(Size.Large.sizeValue()), secondFont: UIFont.MabryPro(Size.Large.sizeValue()), firstColor: UIColor.SecondarytextColor, secondColor: UIColor.primaryTextcolor)
                
                activeStrategyView.isHidden = false
            }
        }
        informationViewHeightConst.constant = CGFloat(informationHeight)
        
        
    }
}

//MARK:- TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension InvestmentStrategyTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return investmentStrategyAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestmentStrategyCVC", for: indexPath as IndexPath) as! InvestmentStrategyCVC
        cell.configureWithData(data : investmentStrategyAssets[indexPath.row],strategyColor : self.selectorStrategyColor(position : indexPath.row, totalNumber : investmentStrategyAssets.count))
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
        DispatchQueue.main.async {
            sectionView.backgroundColor = self.selectorStrategyColor(position : section, totalNumber : self.investmentStrategyAssets.count)
        }
       
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
        
    }
    
    func selectorStrategyColor(position : Int, totalNumber : Int) -> UIColor{
        if(totalNumber > 8)
        {
            let percentage = Double(position) / Double(totalNumber)
            let color = UIColor(named: "purple_800")?.lighter(componentDelta: CGFloat(percentage)) ?? UIColor()
            return color
        }
        else
        {
            switch totalNumber {
            case 1:
                return UIColor(named: "purple_600") ?? UIColor()
            case 2:
                switch position{
                case 0:
                    return UIColor(named: "purple_600") ?? UIColor()
                default:
                    return UIColor(named: "purple_400") ?? UIColor()
                }
            case 3:
                switch position{
                case 0:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_400") ?? UIColor()
                default:
                    return UIColor(named: "purple_200") ?? UIColor()
                }
            case 4:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                default:
                    return UIColor(named: "purple_200") ?? UIColor()
                }
            case 5:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_200") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 6:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 7:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_300") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 5:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 8:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_500") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_300") ?? UIColor()
                case 5:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 6:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
                
            default:
                return UIColor(named: "purple_400") ?? UIColor()
            }
        }
        
    }
}
