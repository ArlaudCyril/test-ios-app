//
//  AnalyticsTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit
import Charts
class AnalyticsTVC: UITableViewCell {
    var controller : PortfolioHomeVC?
    //MARK:- IB OUTLETS
    @IBOutlet var earningVw: UIView!
    @IBOutlet var totalEarningLbl: UILabel!
    @IBOutlet var totalEuroLbl: UILabel!
    @IBOutlet var earningGraphVw: LineChartView!
    
    @IBOutlet var yieldVw: UIView!
    @IBOutlet var yieldLbl: UILabel!
    @IBOutlet var yieldPercentageLbl: UILabel!
    @IBOutlet var yieldGraphVw: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

//Mark:- SetUpUI
extension AnalyticsTVC{
    func setUpCell(){
        CommonUI.setUpViewBorder(vw: self.earningVw, radius: 12, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.totalEarningLbl, text: CommonFunctions.localisation(key: "TOTAL_EARNINGS"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalEuroLbl, text: "0.00€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.yieldVw, radius: 12, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.yieldLbl, text: CommonFunctions.localisation(key: "RETURN_ON_INVESTMENT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.yieldPercentageLbl, text: "0.00%", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        var graphValues: [ChartDataEntry] = []
        for index in 0..<8 {
			_ = Double(arc4random_uniform(15000))
            graphValues.append(ChartDataEntry(x: Double(index), y: 0))
        }
        extractedFunc(graphValues, UIColor.PurpleColor)
        
//        let earningVwTap = UITapGestureRecognizer(target: self, action: #selector(earningVwAction))
//        self.earningVw.addGestureRecognizer(earningVwTap)
//        let roiVwTap = UITapGestureRecognizer(target: self, action: #selector(ROIViewAction))
//        self.yieldVw.addGestureRecognizer(roiVwTap)
        
    }
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunctions.drawChart(with: graphValues, on: earningGraphVw, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
        CommonFunctions.drawChart(with: graphValues, on: yieldGraphVw, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
}

//MARK: - objective functions
extension AnalyticsTVC{
    @objc func earningVwAction(){
        let vc = TotalEarningsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func ROIViewAction(){
        let vc = TotalEarningsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        vc.returnOnInvestment = true
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
