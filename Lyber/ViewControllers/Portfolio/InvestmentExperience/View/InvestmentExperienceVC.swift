//
//  InvestmentExperienceVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class InvestmentExperienceVC: UIViewController {
    //MARK: - Variables
    var investmentType : investment!
    var investmentExpData : [String] = [L10n.IHaveNeverInvested.description,
                                        L10n.lessThan1000€.description,
                                        L10n.between1000€and9999€.description,
                                        L10n.Between10000€And99999€.description,
                                        L10n.greaterThan100000€.description]
    var sourceOfIncomeData : [String] = [L10n.Salary.description,
                                        L10n.Investments.description,
                                        L10n.Savings.description,
                                        L10n.Inheritance.description,
                                        L10n.CreditLoan.description,
                                        L10n.FamillyOthers.description]
    var workIndustryData : [String] = [L10n.Agriculture.description,
                                        L10n.ArtsMedia.description,
                                        L10n.CasinosGames.description,
                                        L10n.Building.description,
                                        L10n.Defense.description,
                                        L10n.Entertainement.description,
                                        L10n.Education.description,
                                        L10n.Energy.description,
                                        L10n.MediaTV.description,
                                        L10n.NewTechnologies.description]
    var annualIncomeData : [String] = ["0-18k€/month","19-23k€/month","24-27k€/month", "28-35k€/month","36-56k€/month","57-*k€/month"]
    var personalAssetsData  = ["0-2 assets","3-22 assets","23-128 assets", "129-319 assets","320-464 assets","465- assets"]

    var investExperienceCallBack :((String)->())?
    //MARK: - IB OUTLETS
    @IBOutlet var outerVw: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var yourInvestmentExpLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

//MARK: - SetUpUI
extension InvestmentExperienceVC{
    func setUpUI(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        CommonUI.setUpViewBorder(vw: self.bottomView, radius: 32, borderWidth: 0, borderColor: UIColor.greyColor.cgColor)
        bottomView.addShadow()
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.yourInvestmentExpLbl, text: L10n.WhatYourInvestmentExperienceWithCryptos.description, textColor: UIColor.ThirdTextColor, font: UIFont.AtypDisplayMedium(Size.Header.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.yourInvestmentExpLbl, text: L10n.WhatYourInvestmentExperienceWithCryptos.description, lineSpacing: 6, textAlignment: .left)
        
        if investmentType == .experience{
            self.yourInvestmentExpLbl.text = L10n.WhatYourInvestmentExperienceWithCryptos.description
        }else if investmentType == .sourceOfIncome{
            self.yourInvestmentExpLbl.text = L10n.WhatYourSourceOfIncome.description
        }else if investmentType == .workIndustry{
            self.yourInvestmentExpLbl.text = L10n.WhatYourWorkIndustry.description
        }else if investmentType == .AnnualIncome{
            self.yourInvestmentExpLbl.text = L10n.WhatSalaryRangeYouFallInto.description
        }else if investmentType == .personalAssets{
            self.yourInvestmentExpLbl.text = L10n.HowManyPersonalAssetsYouHave.description
        }
        let outerTapped = UITapGestureRecognizer(target: self, action: #selector(cancelBtnAct))
        self.outerVw.addGestureRecognizer(outerTapped)
    }
}

//MARK: - table view delegates and dataSource
extension InvestmentExperienceVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if investmentType == .experience{
            return investmentExpData.count
        }else if investmentType == .sourceOfIncome{
            return sourceOfIncomeData.count
        }else if investmentType == .workIndustry{
            return workIndustryData.count
        }else if investmentType == .AnnualIncome{
            return annualIncomeData.count
        }else if investmentType == .personalAssets{
            return personalAssetsData.count
        }else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentExperienceTVC")as! InvestmentExperienceTVC
        if investmentType == .experience{
            cell.setUpCell(data: investmentExpData[indexPath.row])
        }else if investmentType == .sourceOfIncome{
            cell.setUpCell(data: sourceOfIncomeData[indexPath.row])
        }else if investmentType == .workIndustry{
            cell.setUpCell(data: workIndustryData[indexPath.row])
        }else if investmentType == .AnnualIncome{
            cell.setUpCell(data: annualIncomeData[indexPath.row])
        }else if investmentType == .personalAssets{
            cell.setUpCell(data: personalAssetsData[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if investmentType == .experience{
            self.investExperienceCallBack?(investmentExpData[indexPath.row])
        }else if investmentType == .sourceOfIncome{
            self.investExperienceCallBack?(sourceOfIncomeData[indexPath.row])
        }else if investmentType == .workIndustry{
            self.investExperienceCallBack?(workIndustryData[indexPath.row])
        }else if investmentType == .AnnualIncome{
            self.investExperienceCallBack?(annualIncomeData[indexPath.row])
        }else if investmentType == .personalAssets{
            self.investExperienceCallBack?(personalAssetsData[indexPath.row])
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - objective functions
extension InvestmentExperienceVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TABLE VIEW OBSERVER
extension InvestmentExperienceVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.setUpUI()
      self.tblView.reloadData()
    }
      
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.tblView.removeObserver(self, forKeyPath: "contentSize")
    }
      
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if let obj = object as? UITableView {
          if obj == self.tblView && keyPath == "contentSize" {
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
              self.tblViewHeightConst.constant = newSize.height
            }
          }
      }
    }
}
