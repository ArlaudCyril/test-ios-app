//
//  PortfolioDetailTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import Charts

class PortfolioDetailTVC: UITableViewCell {
    //MARK: - Variables
    var chartData = ["1H ","4H ",CommonFunctions.localisation(key: "1D"),CommonFunctions.localisation(key: "1W"),"1M ",CommonFunctions.localisation(key: "1Y")]
//                     ,"ALL"]
    var controller : PortfolioDetailVC?
    let customMarkerView = customMarker()
    var allAssets : [GetAssetsAPIElement] = []
    var assetDetail : Trending?
	var dateTimeArr : [graphStruct] = []
    var assetName = String()
    var chartLastPoint = Double()
	var graphValues: [ChartDataEntry] = []
	var valueWebSocket : Double = 0
	var timer = Timer()
	var entrySelected = ChartDataEntry()
	var scaleYChartView : CGFloat = 0
    
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var coinBtn: UIButton!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var collView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
		//setting timer for updating point
    }

}

extension PortfolioDetailTVC{
    func setUpCell(assetData : Trending?,chartData : chartData?){
        self.customMarkerView.contentView.isHidden = true
        self.assetDetail = assetData
		self.graphValues = []
        
        self.chartView.delegate = self
        
        let modifiedDateArr = self.getTimeValues(date: chartData?.lastUpdate ?? "", count: chartData?.prices?.count ?? 0)

		for (index,_) in stride(from: 0, through: (chartData?.prices?.count ?? 0)-1, by: 1).enumerated(){
			self.dateTimeArr.append(graphStruct(index: index, date: modifiedDateArr[index], euro: Double(chartData?.prices?[index] ?? "") ?? 0))
			let yValue = Double(chartData?.prices?[index] ?? "") ?? 0
			self.graphValues.append(ChartDataEntry(x: Double(index), y: yValue))
        }
        self.extractedFunc(self.graphValues, UIColor.PurpleColor)
        
        if self.graphValues.count > 0{
            let lastPoint = self.chartView.getPosition(entry: self.graphValues[self.graphValues.count - 1], axis: .left)
            self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
            self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: self.graphValues[self.graphValues.count - 1].x, yValue: self.graphValues[self.graphValues.count - 1].y)
            self.chartLastPoint = self.graphValues[self.graphValues.count - 1].y
            self.customMarkerView.contentView.isHidden = false
        }
        
        self.chartView.addSubview(customMarkerView)
		
		
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpButton(btn: self.coinBtn, text: "", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        for coin in coinDetailData{
            if coin.id == self.assetName {
                self.coinBtn.setTitle("\(coin.fullName ?? "")", for: .normal)
            }
        }
        
        CommonUI.setUpLbl(lbl: priceLbl, text: CommonFunctions.localisation(key: "PRICE"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))

        CommonUI.setUpLbl(lbl: euroLbl, text: "\(CommonFunctions.formattedCurrency(from: self.chartLastPoint ))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: percentageLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))//update percentage
        
        if (assetData?.priceChangePercentage24H ?? 0) < 0{
            percentageLbl.textColor = UIColor.Red_500
            self.percentageLbl.text = "▼ \(assetData?.priceChangePercentage24H ?? 0)% (\(CommonFunctions.formattedCurrency(from: assetData?.priceChange24H ?? 0))€)"
        }else{
            percentageLbl.textColor = UIColor.GreenColor
            self.percentageLbl.text = "▲ \(assetData?.priceChangePercentage24H ?? 0)% (\(CommonFunctions.formattedCurrency(from: assetData?.priceChange24H ?? 0))€)"
        }
        
        self.collView.layer.cornerRadius = 12
        self.collView.delegate = self
        self.collView.dataSource = self
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.coinBtn.addTarget(self, action: #selector(coinBtnAct), for: .touchUpInside)
		
		
        
    }
    
    func getTimeValues(date : String,timeFrame: String = "1h",count : Int)->([String]){
        let dateString = date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var date = formatter.date(from: dateString) ?? Date()
        var modifiedDate = date
        var arr : [Date] = []
        var datesArr : [String] = []
        for i in 0..<count{
            let required = CommonFunctions.getDate(date: modifiedDate)
            datesArr.append(required)
            arr.append(modifiedDate )
            if timeFrame == "1h"{
                modifiedDate = Calendar.current.date(byAdding: .minute, value: -1, to: date )!
            }else if timeFrame == "4h"{
                modifiedDate = Calendar.current.date(byAdding: .minute, value: -5, to: date )!
            }else if timeFrame == "1d"{
                modifiedDate = Calendar.current.date(byAdding: .minute, value: -30, to: date )!
            }else if timeFrame == "1w"{
                modifiedDate = Calendar.current.date(byAdding: .hour , value: -4, to: date )!
            }else if timeFrame == "1m"{
                modifiedDate = Calendar.current.date(byAdding: .hour, value: -12, to: date )!
            }else if timeFrame == "1y"{
                modifiedDate = Calendar.current.date(byAdding: .day, value: -7, to: date )!
            }else{
                
            }
            date = modifiedDate
        }
        return datesArr.reversed()
    }
    
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunctions.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
}

//MARK: - Coll VIEW DELEGATE AND DATA SOURCE METHODS
extension PortfolioDetailTVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        return CGSize(width: (((collView.layer.bounds.width/6) - 10)), height: collView.layer.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.customMarkerView.contentView.isHidden = true
        var chartDuration : chartType = .oneWeek
		self.timer.invalidate()
        switch indexPath.row{
        case 0:
            chartDuration = .oneHour
        case 1:
            chartDuration = .fourHour
        case 2:
            chartDuration = .oneDay
        case 3:
            chartDuration = .oneWeek
        case 4:
            chartDuration = .oneMonth
        case 5:
            chartDuration = .oneYear
        default:
            break
        }
		self.dateTimeArr = []
		self.callChartApi(duration: chartDuration.rawValue)
    }
}

//MARK: - objective functions
extension PortfolioDetailTVC{
    @objc func backBtnAct(){
		if(self.controller?.previousController is ConfirmInvestmentVC){
			self.controller?.navigationController?.deleteToViewController(ofClass: Storage.previousControllerPortfolioDetailObject)
			self.controller?.navigationController?.popViewController(animated: true)
		}else{
			self.controller?.navigationController?.popViewController(animated: true)
		}
		
    }
    
    @objc func coinBtnAct(){
        let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
	
	@objc func updateChartView(value: Double){
		let indexSelected = Int(self.entrySelected.x)
		
		//delete first element
		self.dateTimeArr.remove(at: 0)
		self.graphValues.remove(at: 0)
		
		//reset arrays without the first element
		let copyDateTimeArr = self.dateTimeArr
		let copyGraphValues = self.graphValues
		
		self.dateTimeArr = []
		self.graphValues = []
		
		for (index,_) in stride(from: 0, through: copyGraphValues.count-1, by: 1).enumerated(){
			self.dateTimeArr.append(graphStruct(index: index, date: copyDateTimeArr[index].date, euro: copyDateTimeArr[index].euro))
			self.graphValues.append(ChartDataEntry(x: Double(index), y: copyGraphValues[index].y))
		}
		
		//last index
		let date = CommonFunctions.getDate(date: Date())
		//ici bug
		var value = self.valueWebSocket
		if(value == 0){
			value = self.graphValues.last?.y ?? 0
		}
		self.dateTimeArr.append(graphStruct(index: self.graphValues.count, date: date, euro: value))
		self.graphValues.append(ChartDataEntry(x: Double(self.graphValues.count), y: value))
		self.extractedFunc(self.graphValues, UIColor.PurpleColor)
		
		
		var indexGraph = 0
		if(indexSelected >= self.graphValues.count-1){
			indexGraph = self.graphValues.count-1
		}else if(indexSelected <= 0){
			indexGraph = 0
		}else{
			indexGraph = indexSelected-1
		}
		self.entrySelected = self.graphValues[indexGraph]
		let point = self.chartView.getPosition(entry: self.graphValues[indexGraph], axis: .left)
		self.customMarkerView.center = CGPoint(x: point.x , y: (point.y ) )
		self.hideShowBubble(xPixel: point.x, yPixel: point.y, xValue: self.graphValues[indexGraph].x, yValue: self.graphValues[indexGraph].y)
		
	}
	
}

//MARK: ChartViewDelegate
extension PortfolioDetailTVC: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.customMarkerView.center = CGPoint(x: highlight.xPx, y: (highlight.yPx ))
		self.entrySelected = entry
        self.customMarkerView.contentView.isHidden = false
        self.hideShowBubble(xPixel: highlight.xPx, yPixel: highlight.yPx, xValue: highlight.x, yValue:highlight.y )
        
    }
}

//MARK: - Other functions
extension PortfolioDetailTVC{
    func callChartApi(duration : String){
        self.controller?.portfolioDetailVM.getChartDataApi(AssetId: self.assetName, timeFrame: duration , completion: {[ self]response in
            if let response = response{
                self.graphValues = []
                
                let modifiedDateArr = self.getTimeValues(date: response.data?.lastUpdate ?? "", timeFrame: duration, count: response.data?.prices?.count ?? 0)
                
                for (index,value) in stride(from: 0, through: (response.data?.prices?.count ?? 0)-1, by: 1).enumerated(){
                    self.dateTimeArr.append(graphStruct(index: index, date: modifiedDateArr[value], euro: Double(response.data?.prices?[value] ?? "") ?? 0))
                    let yValue = Double(response.data?.prices?[value] ?? "") ?? 0
                    self.graphValues.append(ChartDataEntry(x: Double(value), y: yValue))
                }
                self.extractedFunc(self.graphValues, UIColor.PurpleColor)
				self.entrySelected = self.graphValues.last ?? ChartDataEntry()
				self.setTimer(timeFrame: duration)
                
                let lastPoint = self.chartView.getPosition(entry: self.graphValues[self.graphValues.count - 1], axis: .left)
                self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
                self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: self.graphValues[self.graphValues.count - 1].x, yValue: self.graphValues[self.graphValues.count - 1].y)
                self.customMarkerView.contentView.isHidden = false
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
        customMarkerView.graphLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"

        for (index,_) in stride(from: 0, through: (self.dateTimeArr.count)-1, by: 1).enumerated(){
            if self.dateTimeArr[index].index == Int(xValue){
                customMarkerView.dateTimeLbl.text = self.dateTimeArr[index].date
                customMarkerView.bottomDateLbl.text = self.dateTimeArr[index].date
            }
        }
    }
	
	func updateValueLastPoint(){
		let diffYCharView = Double(self.chartView.data?.yMax ?? 0) - Double(self.chartView.data?.yMin ?? 0)
		if(diffYCharView != self.scaleYChartView){
			self.scaleYChartView = diffYCharView
			let pointSelected = self.chartView.getPosition(entry: self.entrySelected, axis: .left)
			self.customMarkerView.center = CGPoint(x: pointSelected.x , y: (pointSelected.y ) )
		}
		let lastPoint = self.chartView.getPosition(entry: self.graphValues[self.graphValues.count - 1], axis: .left)
		//self.customMarkerView.contentView.isHidden = false
		if(Int(self.entrySelected.x) == self.graphValues.count - 1){
			self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
			self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: self.graphValues[self.graphValues.count - 1].x, yValue: self.valueWebSocket)
			
		}
		self.graphValues[self.graphValues.count-1] = ChartDataEntry(x: Double(self.graphValues.count-1), y: self.valueWebSocket)
		self.extractedFunc(self.graphValues, UIColor.PurpleColor)
	}
	
	func setTimer(timeFrame : String){
		//setting timer for updating point
		var interval : Double = 0
		let formatter = DateFormatter()
		//get current year
		formatter.dateFormat = "yyyy"
		let yearString = formatter.string(from: Date())
		let dateString = (self.dateTimeArr.last?.date)! + " " + yearString
		//get date of the last index in array
		formatter.dateFormat = "MMM. d, HH:mm yyyy"
		var date = formatter.date(from: dateString) ?? Date()
		switch timeFrame {
			case "1h":
				//every minutes
				date = Calendar.current.date(byAdding: .minute, value: 1, to: date )!
				interval = 60
			case "4h":
				//every 5 minutes
				date = Calendar.current.date(byAdding: .minute, value: 5, to: date )!
				interval = 60*5
			case "1d":
				//every 30 minutes
				date = Calendar.current.date(byAdding: .minute, value: 30, to: date )!
				interval = 60*30
			case "1w":
				//every 4 hours
				date = Calendar.current.date(byAdding: .hour , value: 4, to: date )!
				interval = 60*60*4
			case "1m":
				//every 12 hours
				date = Calendar.current.date(byAdding: .hour, value: 12, to: date )!
				interval = 60*60*12
			case "1y":
				//every 7 days
				date = Calendar.current.date(byAdding: .day, value: 7, to: date )!
				interval = 60*60*24*7
			default:
				print("timeFrame not recognized")
		}
		
		self.timer = Timer(fireAt: date, interval: interval, target: self, selector: #selector(self.updateChartView), userInfo: nil, repeats: true)
		RunLoop.main.add(self.timer, forMode: RunLoop.Mode.common)
	}
}


