//
//  LoadingInvestmentVC.swift
//  Lyber
//
//  Created by Lyber on 20/07/2023.
//

import UIKit
import MultiProgressView

class LoadingInvestmentVC: ViewController {
	//MARK: - Variables
	var idInvestment : String = ""
	var timer = Timer()
	
	//MARK: - IB OUTLETS
	@IBOutlet var oneTimeInvestmentLbl: UILabel!
	@IBOutlet var executingStrategyLbl: UILabel!
	@IBOutlet var loadingVw: UIView!
	@IBOutlet var SpinnerVw: SpinnerView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	
	//MARK: - SetUpUI

	override func setUpUI(){
		
		self.loadingVw.layer.cornerRadius = self.loadingVw.frame.width/2
		self.SpinnerVw.showColor = UIColor.white.cgColor
		
		CommonUI.setUpLbl(lbl: self.oneTimeInvestmentLbl, text: CommonFunctions.localisation(key: "EXECUTION_IN_PROGRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		self.oneTimeInvestmentLbl.numberOfLines = 0
		
		CommonUI.setUpLbl(lbl: self.executingStrategyLbl, text: CommonFunctions.localisation(key: "EXECUTING_YOUR_STRATEGY"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.executingStrategyLbl.numberOfLines = 0
		
		self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
	}
}

//MARK: - objective functions
extension LoadingInvestmentVC{
	@objc func fireTimer(){
		OneTimeInvestmentVM().getStrategyExecutionApi(executionId: self.idInvestment, completion: {response in
			if response != nil{
                if(response?.data.status != "PENDING"){
                    self.timer.invalidate()
                    let vc = OneTimeInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                    vc.oneInvestment = response?.data
                    self.navigationController?.pushViewController(vc, animated: false)
                }
			}
		})
		
	}
}

