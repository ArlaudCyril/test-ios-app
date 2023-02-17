//
//  InvestmentExperienceCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class InvestmentExperienceCVC: UICollectionViewCell {
    //MARK: - Variables
    var controller : PersonalDataVC?
    
    //MARK: - IB OUTLETS
    @IBOutlet var investmentExperienceLbl: UILabel!
    @IBOutlet var investmentExpDescLbl: UILabel!
    
    @IBOutlet var investExpWithCryptoLbl: UILabel!
    @IBOutlet var experienceView: UIView!
    @IBOutlet var experienceLbl: UILabel!
    
    @IBOutlet var yourSourceOfIncomeLbl: UILabel!
    @IBOutlet var sourceOfIncomeVw: UIView!
    @IBOutlet var sourceOfIncomeLbl: UILabel!
    
    @IBOutlet var yourWorkIndustryLbl: UILabel!
    @IBOutlet var workIndustryVw: UIView!
    @IBOutlet var workIndustryLbl: UILabel!
    
    @IBOutlet var YourAnnualIncomeLbl: UILabel!
    @IBOutlet var annualIncomeVw: UIView!
    @IBOutlet var annualIncomeLbl: UILabel!
    
    @IBOutlet var personalAssetsLbl: UILabel!
    @IBOutlet var personalAssetsVw: UIView!
    @IBOutlet var personalAssetsValueLbl: UILabel!
    override func awakeFromNib() {
        setUpCell()
    }
}

extension InvestmentExperienceCVC{
    func setUpCell(){
        CommonUI.setUpLbl(lbl: self.investmentExperienceLbl, text: L10n.InvestmentExperience.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.investmentExpDescLbl, text: L10n.mustAnswerTheseQuestions.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.investmentExpDescLbl, text: L10n.mustAnswerTheseQuestions.description, lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.investExpWithCryptoLbl, text: L10n.investExperienceWithCryptos.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.yourSourceOfIncomeLbl, text: L10n.YourSourceOfIncome.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.yourWorkIndustryLbl, text: L10n.YourWorkIndustry.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.YourAnnualIncomeLbl, text: L10n.YourAnnualIncome.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.personalAssetsLbl, text: L10n.YourPersonalAssets.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.experienceView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.sourceOfIncomeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.workIndustryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.annualIncomeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.personalAssetsVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpLbl(lbl: self.experienceLbl, text: L10n.Choose.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.sourceOfIncomeLbl, text: L10n.Choose.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.workIndustryLbl, text: L10n.Choose.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.annualIncomeLbl, text: L10n.Choose.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.personalAssetsValueLbl, text: L10n.Choose.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        let experienceTap = UITapGestureRecognizer(target: self, action: #selector(experinceVwTapped))
        self.experienceView.addGestureRecognizer(experienceTap)
        let sourceIncomeTap = UITapGestureRecognizer(target: self, action: #selector(sourceIncomeVwTapped))
        self.sourceOfIncomeVw.addGestureRecognizer(sourceIncomeTap)
        let workIndustryTap = UITapGestureRecognizer(target: self, action: #selector(workIndustryVwTapped))
        self.workIndustryVw.addGestureRecognizer(workIndustryTap)
        let annualIncomeTap = UITapGestureRecognizer(target: self, action: #selector(annualIncomeVwTapped))
        self.annualIncomeVw.addGestureRecognizer(annualIncomeTap)
        let personalAssetsTap = UITapGestureRecognizer(target: self, action: #selector(personalAssetsVwTapped))
        self.personalAssetsVw.addGestureRecognizer(personalAssetsTap)
    }
    
    func setPersonalDate (data : UserPersonalData?){
        self.experienceLbl.text = data?.investment_experience ?? ""
        self.sourceOfIncomeLbl.text = data?.income_source ?? ""
        self.workIndustryLbl.text = data?.occupation ?? ""
        self.annualIncomeLbl.text = "\(data?.incomeRange ?? "")€/month"
        self.personalAssetsValueLbl.text = "\(data?.personalAssets ?? "") assets"
        
        DispatchQueue.main.async {
            self.controller?.investmentExp = self.experienceLbl.text ?? ""
            self.controller?.sourceOfIncome = self.sourceOfIncomeLbl.text ?? ""
            self.controller?.workIndustry = self.workIndustryLbl.text ?? ""
            self.controller?.annualIncome = self.annualIncomeLbl.text ?? ""
            self.controller?.personalAssets = self.personalAssetsValueLbl.text ?? ""
            
        }
        self.experienceLbl.textColor = UIColor.ThirdTextColor
        self.sourceOfIncomeLbl.textColor = UIColor.ThirdTextColor
        self.workIndustryLbl.textColor = UIColor.ThirdTextColor
        self.annualIncomeLbl.textColor = UIColor.ThirdTextColor
        self.personalAssetsValueLbl.textColor = UIColor.ThirdTextColor

    }
}

//MARK: - objective functions
extension InvestmentExperienceCVC{
    @objc func experinceVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .experience
        vc.investExperienceCallBack = { experience in
            self.experienceLbl.text = experience
            self.controller?.investmentExp = experience
            self.experienceLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func sourceIncomeVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .sourceOfIncome
        vc.investExperienceCallBack = { experience in
            self.sourceOfIncomeLbl.text = experience
            self.controller?.sourceOfIncome = experience
            self.sourceOfIncomeLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func workIndustryVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .workIndustry
        vc.investExperienceCallBack = { experience in
            self.workIndustryLbl.text = experience
            self.controller?.workIndustry = experience
            self.workIndustryLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func annualIncomeVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .AnnualIncome
        vc.investExperienceCallBack = { experience in
            self.annualIncomeLbl.text = experience
            self.controller?.annualIncome = experience
            self.annualIncomeLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func personalAssetsVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .personalAssets
        vc.investExperienceCallBack = { experience in
            self.personalAssetsValueLbl.text = experience
            self.controller?.personalAssets = experience
            self.personalAssetsValueLbl.textColor = UIColor.ThirdTextColor
        }
    }
    
}
