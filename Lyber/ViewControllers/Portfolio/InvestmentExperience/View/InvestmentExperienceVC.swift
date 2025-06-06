//
//  InvestmentExperienceVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class InvestmentExperienceVC: ViewController {
    //MARK: - Variables
    var investmentType : investment!
    var investmentExpData : [String] = ["I_HAVE_NEVER_INVESTED",
                                        "LESS_THAN_1000€",
                                        "BETWEEN_1000€_AND_9999€",
                                        "BETWEEN_10000_€AND_99999€",
                                        "GREATER_THAN_100000€"]
    var sourceOfIncomeData : [String] = ["SALARY",
                                        "INVESTMENTS",
                                        "SAVINGS",
                                        "INHERITANCE",
                                        "CREDIT_LOAN",
                                        "FAMILY_OTHERS"]
    var workIndustryData : [String] = ["AGRICULTURE",
                                        "ARTS_MEDIA",
                                        "BANKING_FINANCE_INSURANCE",
                                        "BUSINESS_SERVICES_CONSULTING",
                                        "BUILDING",
                                        "EDUCATION_TRAINING_RESEARCH",
										"ENERGY_ENVIRONMENT",
										"GOVERNMENT_ADMINISTRATION_SOCIAL",
										"HEALTH_MEDICAL_PHARMACEUTICAL",
										"HOSPITALITY_TOURISM_CATERING",
										"IT",
										"MANUFACTURING_METTALURGY",
										"MARKETING_ADVERTISING_PUBLIC_RELATIONS",
										"REAL_ESTATE_PROPERTY_MANAGEMENT",
										"RETAIL_ECOMMERCE",
										"SPORTS_LEISURE_ENTERTAINMENT",
										"TEXTILE_FASHION_APPAREL",
										"TRANSPORT_LOGISTICS_WHOLESALE"]
    var annualIncomeData : [String] = ["LESS_THAN_500",
									   "500_1000",
									   "1001_1500",
									   "1501_2000",
									   "2001_3000",
									   "OVER_3001"]
	
	var activityData : [String] = ["BUY_SELL_DIGITAL_ASSETS",
									   "SAVE_MONEY",
									   "STORE_DIGITAL_ASSETS"]


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


	//MARK: - SetUpUI

    override func setUpUI(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        CommonUI.setUpViewBorder(vw: self.bottomView, radius: 32, borderWidth: 0, borderColor: UIColor.greyColor.cgColor)
        bottomView.addShadow()
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.yourInvestmentExpLbl, text: CommonFunctions.localisation(key: "WHAT_YOUR_INVESTMENT_EXPERIENCE_WITH_CRYPTOS"), textColor: UIColor.ThirdTextColor, font: UIFont.AtypDisplayMedium(Size.Header.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.yourInvestmentExpLbl, text: CommonFunctions.localisation(key: "WHAT_YOUR_INVESTMENT_EXPERIENCE_WITH_CRYPTOS"), lineSpacing: 6, textAlignment: .left)
        
        if investmentType == .experience{
            self.yourInvestmentExpLbl.text = CommonFunctions.localisation(key: "WHAT_YOUR_INVESTMENT_EXPERIENCE_WITH_CRYPTOS")
        }else if investmentType == .sourceOfIncome{
            self.yourInvestmentExpLbl.text = CommonFunctions.localisation(key: "WHAT_YOUR_SOURCE_OF_INCOME")
        }else if investmentType == .workIndustry{
            self.yourInvestmentExpLbl.text = CommonFunctions.localisation(key: "WHAT_YOUR_WORK_INDUSTRY")
        }else if investmentType == .AnnualIncome{
            self.yourInvestmentExpLbl.text = CommonFunctions.localisation(key: "WHAT_SALARY_RANGE_YOU_FALL_INTO")
        }else if investmentType == .activity{
            self.yourInvestmentExpLbl.text = CommonFunctions.localisation(key: "WHAT_DO_YOU_PLAN_MAINLY")
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
        }else if investmentType == .activity{
            return activityData.count
        }else{
            return 2
		}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentExperienceTVC")as! InvestmentExperienceTVC
        if investmentType == .experience{
			cell.setUpCell(data: CommonFunctions.localisation(key: investmentExpData[indexPath.row]))
        }else if investmentType == .sourceOfIncome{
			cell.setUpCell(data: CommonFunctions.localisation(key: sourceOfIncomeData[indexPath.row]))
        }else if investmentType == .workIndustry{
			cell.setUpCell(data: CommonFunctions.localisation(key: workIndustryData[indexPath.row]))
        }else if investmentType == .AnnualIncome{
			cell.setUpCell(data: CommonFunctions.localisation(key: annualIncomeData[indexPath.row]))
        }else if investmentType == .activity{
			cell.setUpCell(data: CommonFunctions.localisation(key: activityData[indexPath.row]))
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
        }else if investmentType == .activity{
            self.investExperienceCallBack?(activityData[indexPath.row])
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
		self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
      
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.tblView.removeObserver(self, forKeyPath: "contentSize")
    }
      
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if let obj = object as? UITableView {
          if obj == self.tblView && keyPath == "contentSize" {
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
				self.tblViewHeightConst.constant = min(self.view.frame.height/1.6, newSize.height)
            }
          }
      }
    }
}



