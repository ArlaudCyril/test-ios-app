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
    var entrySelected = ChartDataEntry()
    let customMarkerView = customMarker()
    var graphValues: [ChartDataEntry] = []
    var dateTimeArr : [graphStruct] = []
	var chartData = [CommonFunctions.localisation(key: "1D"), CommonFunctions.localisation(key: "1W"),"1M", "ALL"]
    private var daily = false

    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var portfolioLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var profilePicVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var hideBalanceBtn: UIButton!
}

extension PortfolioHomeTVC{
    func setUpCell(){
		getTotalPortfolio()
		drawChartView(limit: 1)
        
        CommonUI.setUpLbl(lbl: portfolioLbl, text: CommonFunctions.localisation(key: "PORTFOLIO"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
		self.profilePic.image = UIImage(asset: Assets(rawValue: userData.shared.profile_image) ?? Assets.chick_egg)
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.profilePicVw.layer.cornerRadius = self.profilePicVw.layer.bounds.height/2
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileAction))
        self.profilePic.addGestureRecognizer(profileTap)
        self.profilePic.isUserInteractionEnabled = true
        
        self.hideBalanceBtn.addTarget(self, action: #selector(toggleMaskBalance), for: .touchUpInside)
        
        self.chartView.delegate = self
        self.chartView.addSubview(customMarkerView)
        
		self.collView.layer.cornerRadius = 12
		self.collView.delegate = self
		self.collView.dataSource = self
        self.collView.reloadData()
        
        if userData.shared.hideBalance {
            self.hideBalanceBtn.setImage(Assets.visibility_off.image(), for: .normal)
        } else {
            self.hideBalanceBtn.setImage(Assets.visibility.image(), for: .normal)
        }
    }
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunctions.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
        if userData.shared.hideBalance {
            chartView.rightAxis.enabled = false
        }
        //actualise the data to place right the last point
        chartView.notifyDataSetChanged()
        putBubleAtLastPoint()
    }
}


extension PortfolioHomeTVC: ChartViewDelegate{
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
       print("nothing selected")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.customMarkerView.center = CGPoint(x: highlight.xPx, y: (highlight.yPx ))
        self.entrySelected = entry
        self.customMarkerView.contentView.isHidden = false
        self.hideShowBubble(xPixel: highlight.xPx, yPixel: highlight.yPx, xValue: highlight.x, yValue:highlight.y )
    }

}

extension PortfolioHomeTVC{
    @objc func profileAction(){
        let vc = ProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		self.controller?.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func toggleMaskBalance(){
        userData.shared.hideBalance = !userData.shared.hideBalance
        userData.shared.dataSave()
        self.controller?.tblView.reloadData()
        
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
		var limit = 1
        self.daily = true
		switch indexPath.row{
			case 1:
                limit = 7
            case 2:
                limit = 30
            case 3:
				limit = 5000
			default:
                daily = false
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
			if(balance?.id == "usdc"){
				totalEuroAvailable = (Double(balance?.balanceData.balance ?? "0") ?? 0)
			}
		}
		
		
		CommonUI.setUpLblBalance(lbl: euroLbl, text: "\(CommonFunctions.getTwoDecimalValue(number: totalPortfolio))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
	}
	
    func drawChartView(limit: Int){
        self.graphValues = []
        self.dateTimeArr = []
		
        PortfolioHomeVM().walletGetBalanceHistoryApi(limit: limit,daily: self.daily, completion:{response in
			if response != nil{
				if(response?.data.count ?? 0 > 0){
					for i in 0...(response?.data.count ?? 1)-1{
                        self.graphValues.append(ChartDataEntry(x: Double(i), y: Double(response?.data[i].total ?? "0" ) ?? 0.0))
                        self.dateTimeArr.append(graphStruct(index: i, date: response?.data[i].date ?? "", euro: Double(response?.data[i].total ?? "") ?? 0))
					}
                    self.graphValues.append(ChartDataEntry(x: Double(response?.data.count ?? 0), y: totalPortfolio))
                    self.dateTimeArr.append(graphStruct(index: response?.data.count ?? 0, date: response?.data.last?.date ?? "", euro: Double(response?.data.last?.total ?? "") ?? 0))
				}else{
                    self.graphValues.append(ChartDataEntry(x: Double(0), y: totalPortfolio))
                    self.graphValues.append(ChartDataEntry(x: Double(1), y: totalPortfolio))
				}
				
				
                self.extractedFunc(self.graphValues, UIColor.PurpleColor)
			}
		})
	}
    
    func hideShowBubble(xPixel:CGFloat,yPixel : CGFloat,xValue : CGFloat,yValue: CGFloat){
        if yPixel > self.chartView.layer.bounds.height/2{
            customMarkerView.bottomBubble.isHidden = true
            customMarkerView.topBubble.isHidden = false
        }else{
            customMarkerView.bottomBubble.isHidden = false
            customMarkerView.topBubble.isHidden = true
        }
        CommonUI.setUpLblBalance(lbl: customMarkerView.graphLbl, text: "\(CommonFunctions.formattedCurrency(from: yValue))€", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Medium.sizeValue()))
        
        CommonUI.setUpLblBalance(lbl: customMarkerView.bottomEuroLbl, text: "\(CommonFunctions.formattedCurrency(from: yValue))€", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Medium.sizeValue()))
        
        for (index,_) in stride(from: 0, through: (self.dateTimeArr.count)-1, by: 1).enumerated(){
            if self.dateTimeArr[index].index == Int(xValue){
                var inputFormat = "yyyy-MM-dd'T'HH:mm"
                let outputFormat = "MMM. d, HH:mm"
                if(daily == true){
                    inputFormat = "yyyy-MM-dd"
                }
                print("NEW VALUE : \(self.dateTimeArr[index].date)")
                let date = CommonFunctions.getDateFormat(date: self.dateTimeArr[index].date, inputFormat: inputFormat, outputFormat: outputFormat)
                
                customMarkerView.dateTimeLbl.text = date
                customMarkerView.bottomDateLbl.text = date
            }
        }
        
        adjustBubblePosition(xPixel: xPixel)
    }
    
    func adjustBubblePosition(xPixel: CGFloat) {
        let bubbleWidth = self.customMarkerView.frame.width
        let chartWidth = self.chartView.bounds.width

        let leftEdgeDistance = xPixel - bubbleWidth / 2
        let rightEdgeDistance = chartWidth - xPixel - bubbleWidth / 2

        if leftEdgeDistance < 0 {
            self.customMarkerView.imageViewCenterTopBubbleConstraint.constant = -leftEdgeDistance
            self.customMarkerView.imageViewCenterBottomBubbleConstraint.constant = -leftEdgeDistance
        } else if rightEdgeDistance < 0 {
            self.customMarkerView.imageViewCenterTopBubbleConstraint.constant = rightEdgeDistance
            self.customMarkerView.imageViewCenterBottomBubbleConstraint.constant = rightEdgeDistance
        } else {
            self.customMarkerView.imageViewCenterTopBubbleConstraint.constant = 0
            self.customMarkerView.imageViewCenterBottomBubbleConstraint.constant = 0
        }

        self.customMarkerView.layoutIfNeeded()
    }
    
    private func putBubleAtLastPoint() {
        guard let lastEntry = self.graphValues.last else { return }
        
        let lastPoint = self.chartView.getPosition(entry: lastEntry, axis: .left)
        print("lastPoint : \(lastPoint)")
        self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
        self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: self.graphValues[self.graphValues.count - 1].x, yValue: self.graphValues[self.graphValues.count - 1].y)
    }
}

