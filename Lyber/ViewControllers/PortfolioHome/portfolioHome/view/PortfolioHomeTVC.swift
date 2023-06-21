//
//  PortfolioHomeTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import Charts
import NVActivityIndicatorView
import AVKit
import MediaPlayer
import SwiftyGif

class PortfolioHomeTVC: UITableViewCell {
    //MARK: - Variables
    var activityIndicator : NVActivityIndicatorView!
    var controller : PortfolioHomeVC?
    var markerController : customMarker?
    let customMarkerView = customMarker()
	var chartData = ["1M ",CommonFunctions.localisation(key: "1Y"), "ALL"]

    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var portfolioLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var profilePicVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var collView: UICollectionView!
}

extension PortfolioHomeTVC{
    func setUpCell(){
		getTotalPortfolio()
		drawChartView(limit: 30)
        
        CommonUI.setUpLbl(lbl: portfolioLbl, text: CommonFunctions.localisation(key: "PORTFOLIO"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		
        
        self.profilePic.yy_setImage(with: URL(string: "\(ApiEnvironment.ImageUrl)\(userData.shared.profile_image)"), placeholder: UIImage(named: "profile"))
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.profilePicVw.layer.cornerRadius = self.profilePicVw.layer.bounds.height/2
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileAction))
        self.profilePic.addGestureRecognizer(profileTap)
        self.profilePic.isUserInteractionEnabled = true
        self.chartView.delegate = self
        self.chartView.addSubview(customMarkerView)
		
		self.collView.layer.cornerRadius = 12
		self.collView.delegate = self
		self.collView.dataSource = self

    }
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunctions.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
}


extension PortfolioHomeTVC: ChartViewDelegate{
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
       print("nothing selected")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       
    }

}

extension PortfolioHomeTVC{
    @objc func profileAction(){
        let vc = ProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Coll VIEW DELEGATE AND DATA SOURCE METHODS
extension PortfolioHomeTVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return chartData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioHomeCVC", for: indexPath as IndexPath) as! PortfolioHomeCVC
		cell.configureWithData(data : chartData[indexPath.row])
		if (indexPath.row == 0){
			cell.isSelected = true
			self.collView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: (((collView.layer.bounds.width/Double(chartData.count)) - 10)), height: collView.layer.bounds.height)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var limit = 30
		switch indexPath.row{
			case 1:
				limit = 365
			case 2:
				limit = 5000
			default:
				break
		}
		self.drawChartView(limit: limit)
	}
}

//MARK: - Other functions
extension PortfolioHomeTVC{
	func getTotalPortfolio(){
		totalPortfolio = 0
		totalEuroAvailable = 0
		for balance in Storage.balances{
			totalPortfolio += (Double(balance?.balanceData.euroBalance ?? "0") ?? 0)
			if(balance?.id == "usdt"){
				totalEuroAvailable = (Double(balance?.balanceData.balance ?? "0") ?? 0)
			}
		}
		
		
		CommonUI.setUpLbl(lbl: euroLbl, text: "\(CommonFunctions.getTwoDecimalValue(number: totalPortfolio))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
	}
	
	func drawChartView(limit: Int){
		var graphValues: [ChartDataEntry] = []
		
		PortfolioHomeVM().walletGetBalanceHistoryApi(limit: limit, completion:{response in
			if response != nil{
				if(response?.data.count ?? 0 > 0){
					for i in 0...(response?.data.count ?? 1)-1{
						graphValues.append(ChartDataEntry(x: Double(i), y: Double(response?.data[i].total ?? "0" ) ?? 0.0))
					}
					graphValues.append(ChartDataEntry(x: Double(response?.data.count ?? 0), y: totalPortfolio))
				}else{
					graphValues.append(ChartDataEntry(x: Double(0), y: totalPortfolio))
					graphValues.append(ChartDataEntry(x: Double(1), y: totalPortfolio))
				}
				
				
				self.extractedFunc(graphValues, UIColor.PurpleColor)
				let lastPoint = self.chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
				print("lastPoint : \(lastPoint)")
				self.customMarkerView.contentView.isHidden = true
			}
		})
	}
}
