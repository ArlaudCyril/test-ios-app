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
//    var player: AVQueuePlayer!
//    var playerLayer = AVPlayerLayer!
//    var playerItem: AVPlayerItem!
//    var playerLooper: AVPlayerLooper!
    
    var playerAV: AVPlayer!

    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var portfolioLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var profilePicVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var chartView: LineChartView!
//    @IBOutlet var collView: UICollectionView!
}

extension PortfolioHomeTVC{
    func setUpCell(){
		getTotalPortfolio()
		drawChartView()
        
        CommonUI.setUpLbl(lbl: portfolioLbl, text: CommonFunctions.localisation(key: "PORTFOLIO"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		
        
        self.profilePic.yy_setImage(with: URL(string: "\(ApiEnvironment.ImageUrl)\(userData.shared.profile_image)"), placeholder: UIImage(named: "profile"))
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.profilePicVw.layer.cornerRadius = self.profilePicVw.layer.bounds.height/2
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileAction))
        self.profilePic.addGestureRecognizer(profileTap)
        self.profilePic.isUserInteractionEnabled = true
        self.chartView.delegate = self
        self.chartView.addSubview(customMarkerView)

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

//MARK: - Other functions
extension PortfolioHomeTVC{
    func hideShowBubble(xPixel:CGFloat,yPixel : CGFloat,xValue : CGFloat,yValue: CGFloat){
        if yPixel > self.chartView.layer.bounds.height/2{
            customMarkerView.bottomBubble.isHidden = true
            customMarkerView.topBubble.isHidden = false
        }else{
            customMarkerView.bottomBubble.isHidden = false
            customMarkerView.topBubble.isHidden = true
        }
        
        if self.controller?.groupLeaved == true{
            self.customMarkerView.contentView.isHidden = false
        }
        
        customMarkerView.graphLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"
        customMarkerView.dateTimeLbl.text = "\(CommonFunctions.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
        customMarkerView.bottomDateLbl.text = "\(CommonFunctions.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
    }
	
	func getTotalPortfolio(){
		totalPortfolio = 0
		for balance in Storage.balances{
			totalPortfolio += (Double(balance?.balanceData.euroBalance ?? "0") ?? 0)
		}
		
		CommonUI.setUpLbl(lbl: euroLbl, text: "\(CommonFunctions.formattedCurrency(from: totalPortfolio ))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
	}
	
	func drawChartView(){
		var graphValues: [ChartDataEntry] = []
		
		PortfolioHomeVM().walletGetBalanceHistoryApi(completion:{response in
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
