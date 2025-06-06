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
	var bundleEnglish : Bundle?
    
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
	
	@IBOutlet var yourActivityLbl: UILabel!
    @IBOutlet var activityVw: UIView!
    @IBOutlet var activityLbl: UILabel!
    
    override func awakeFromNib() {
		let language = "en"
		let path = Bundle.main.path(forResource: language, ofType: "lproj")
		bundleEnglish = Bundle(path: path!)
        setUpCell()
    }
}

extension InvestmentExperienceCVC{
    func setUpCell(){
        CommonUI.setUpLbl(lbl: self.investmentExperienceLbl, text: CommonFunctions.localisation(key: "INVESTMENT_EXPERIENCE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.investmentExpDescLbl, text: CommonFunctions.localisation(key: "MUST_ANSWER_THESE_QUESTIONS"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.investmentExpDescLbl, text: CommonFunctions.localisation(key: "MUST_ANSWER_THESE_QUESTIONS"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.investExpWithCryptoLbl, text: CommonFunctions.localisation(key: "INVEST_EXPERIENCE_WITH_CRYPTOS"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.investExpWithCryptoLbl.numberOfLines = 0
		
        CommonUI.setUpLbl(lbl: self.yourSourceOfIncomeLbl, text: CommonFunctions.localisation(key: "YOUR_SOURCE_OF_INCOME"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.yourWorkIndustryLbl, text: CommonFunctions.localisation(key: "YOUR_WORK_INDUSTRY"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.YourAnnualIncomeLbl, text: CommonFunctions.localisation(key: "YOUR_MONTHLY_INCOME"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.yourActivityLbl, text: CommonFunctions.localisation(key: "YOUR_ACTIVITY_LYBER"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.experienceView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.sourceOfIncomeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.workIndustryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.annualIncomeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
		CommonUI.setUpViewBorder(vw: self.activityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpLbl(lbl: self.experienceLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.sourceOfIncomeLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.workIndustryLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.annualIncomeLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: self.activityLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        let experienceTap = UITapGestureRecognizer(target: self, action: #selector(experinceVwTapped))
        self.experienceView.addGestureRecognizer(experienceTap)
        let sourceIncomeTap = UITapGestureRecognizer(target: self, action: #selector(sourceIncomeVwTapped))
        self.sourceOfIncomeVw.addGestureRecognizer(sourceIncomeTap)
        let workIndustryTap = UITapGestureRecognizer(target: self, action: #selector(workIndustryVwTapped))
        self.workIndustryVw.addGestureRecognizer(workIndustryTap)
        let annualIncomeTap = UITapGestureRecognizer(target: self, action: #selector(annualIncomeVwTapped))
        self.annualIncomeVw.addGestureRecognizer(annualIncomeTap)
		let activityTap = UITapGestureRecognizer(target: self, action: #selector(activityVwTapped))
        self.activityVw.addGestureRecognizer(activityTap)
    }
    
    func setPersonalData(){
		self.experienceLbl.text = CommonFunctions.localisation(key: CommonFunctions.getLocalizationKey(fromLocalizedText: userData.shared.investmentExperience, in: "en"))
        self.sourceOfIncomeLbl.text = CommonFunctions.localisation(key: CommonFunctions.getLocalizationKey(fromLocalizedText: userData.shared.sourceOfIncome, in: "en"))
        self.workIndustryLbl.text = CommonFunctions.localisation(key: CommonFunctions.getLocalizationKey(fromLocalizedText: userData.shared.workIndustry, in: "en"))
        self.annualIncomeLbl.text = CommonFunctions.localisation(key: CommonFunctions.getLocalizationKey(fromLocalizedText: userData.shared.annualIncome, in: "en"))
        self.activityLbl.text = CommonFunctions.localisation(key: CommonFunctions.getLocalizationKey(fromLocalizedText: userData.shared.activityOnLyber, in: "en"))

        DispatchQueue.main.async {
            self.controller?.investmentExp = userData.shared.investmentExperience
            self.controller?.sourceOfIncome = userData.shared.sourceOfIncome
            self.controller?.workIndustry = userData.shared.workIndustry
            self.controller?.annualIncome = userData.shared.annualIncome
            self.controller?.activity = userData.shared.activityOnLyber
            
        }
        self.experienceLbl.textColor = UIColor.ThirdTextColor
        self.sourceOfIncomeLbl.textColor = UIColor.ThirdTextColor
        self.workIndustryLbl.textColor = UIColor.ThirdTextColor
        self.annualIncomeLbl.textColor = UIColor.ThirdTextColor
        self.activityLbl.textColor = UIColor.ThirdTextColor

    }
}

//MARK: - objective functions
extension InvestmentExperienceCVC{
    @objc func experinceVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .experience
        vc.investExperienceCallBack = { experience in
            self.experienceLbl.text = CommonFunctions.localisation(key: experience)
			self.controller?.investmentExp = self.bundleEnglish?.localizedString(forKey: experience, value:nil , table: nil) ?? ""
            self.experienceLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func sourceIncomeVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .sourceOfIncome
        vc.investExperienceCallBack = { experience in
            self.sourceOfIncomeLbl.text = CommonFunctions.localisation(key: experience)
            self.controller?.sourceOfIncome = self.bundleEnglish?.localizedString(forKey: experience, value:nil , table: nil) ?? ""
            self.sourceOfIncomeLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func workIndustryVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .workIndustry
        vc.investExperienceCallBack = { experience in
            self.workIndustryLbl.text = CommonFunctions.localisation(key: experience)
            self.controller?.workIndustry = self.bundleEnglish?.localizedString(forKey: experience, value:nil , table: nil) ?? ""
            self.workIndustryLbl.textColor = UIColor.ThirdTextColor
        }
    }
    @objc func annualIncomeVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .AnnualIncome
        vc.investExperienceCallBack = { experience in
            self.annualIncomeLbl.text = CommonFunctions.localisation(key: experience)
            self.controller?.annualIncome = self.bundleEnglish?.localizedString(forKey: experience, value:nil , table: nil) ?? ""
            self.annualIncomeLbl.textColor = UIColor.ThirdTextColor
        }
    }
	@objc func activityVwTapped(){
        let vc = InvestmentExperienceVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        controller?.present(vc, animated: true, completion: nil)
        vc.investmentType = .activity
        vc.investExperienceCallBack = { experience in
            self.activityLbl.text = CommonFunctions.localisation(key: experience)
            self.controller?.activity = self.bundleEnglish?.localizedString(forKey: experience, value:nil , table: nil) ?? ""
            self.activityLbl.textColor = UIColor.ThirdTextColor
        }
    }
    
}
