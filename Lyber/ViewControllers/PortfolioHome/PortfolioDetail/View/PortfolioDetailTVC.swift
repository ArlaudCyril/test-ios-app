//
//  PortfolioDetailTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import Charts
import SwiftyJSON

class PortfolioDetailTVC: UITableViewCell {
    //MARK: - Variables
    var chartData = ["1H ","4H ","1D","1W ","1M ","1Y"]
//                     ,"ALL"]
    var controller : PortfolioDetailVC?
    let customMarkerView = customMarker()
    var allAssets : [GetAssetsAPIElement] = []
    var assetDetail : Trending?
    var dateTimeArr : [graphStruct] = []
    var assetName = String()
    var chartLastPoint = Double()
    var isOpened = false
//    var webSocket : URLSessionWebSocketTask?
    
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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension PortfolioDetailTVC{
    func setUpCell(assetData : Trending?,chartData : chartData?){
        self.customMarkerView.contentView.isHidden = true
        self.assetDetail = assetData
        var graphValues: [ChartDataEntry] = []
        self.chartView.delegate = self
        
        let modifiedDateArr = self.getTimeValues(date: chartData?.lastUpdate ?? "", count: chartData?.prices?.count ?? 0)
        print("modifiedDateArr \(modifiedDateArr)")
        for (index,value) in stride(from: 0, through: (chartData?.prices?.count ?? 0)-1, by: 1).enumerated(){
            
            self.dateTimeArr.append(graphStruct(index: index, date: modifiedDateArr[value], euro: Double(chartData?.prices?[value] ?? "") ?? 0))
//            let yValue = chartData?.prices?[value][1] ?? ""
            let yValue = Double(chartData?.prices?[value] ?? "") ?? 0
            graphValues.append(ChartDataEntry(x: Double(value), y: yValue))
        }
        self.extractedFunc(graphValues, UIColor.PurpleColor)
        
        if graphValues.count > 0{
            let lastPoint = self.chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
            print("lastPoint : \(lastPoint)")
            self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
            self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: graphValues[graphValues.count - 1].x, yValue: graphValues[graphValues.count - 1].y)
            self.chartLastPoint = graphValues[graphValues.count - 1].y
            self.customMarkerView.contentView.isHidden = false
        }
        
        self.chartView.addSubview(customMarkerView)
        self.receiveMessage()
   
        
        
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpButton(btn: self.coinBtn, text: "", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        for coin in coinDetailData{
            if coin.id == self.assetName {
                self.coinBtn.setTitle("\(coin.fullName ?? "") (\(self.assetName.uppercased()))", for: .normal)
            }
        }
        
        CommonUI.setUpLbl(lbl: priceLbl, text: L10n.price.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: euroLbl, text: "\(CommonFunction.formattedCurrency(from: self.chartLastPoint ))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: percentageLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        if (assetData?.priceChangePercentage24H ?? 0) < 0{
            percentageLbl.textColor = UIColor.RedDF5A43
            self.percentageLbl.text = "▼ \(CommonFunction.formattedCurrency(from: assetData?.priceChangePercentage24H ?? 0))% (\(CommonFunction.formattedCurrency(from: assetData?.priceChange24H ?? 0))€)"
        }else{
            percentageLbl.textColor = UIColor.GreenColor
            self.percentageLbl.text = "▲ \(CommonFunction.formattedCurrency(from: assetData?.priceChangePercentage24H ?? 0))% (\(CommonFunction.formattedCurrency(from: assetData?.priceChange24H ?? 0))€)"
        }
        
        self.collView.layer.cornerRadius = 12
        self.collView.backgroundColor = UIColor.borderColor
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
            let required = CommonFunction.getDate(date: modifiedDate)
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
        CommonFunction.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
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
        print("Item Selected is \(indexPath.item)")
        self.customMarkerView.contentView.isHidden = true
        var chartDuration : chartType = .oneWeek
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
//        self.controller?.chartDurationTime = chartDuration.rawValue
//        if indexPath.row == 0 || indexPath.row == 1{
//            var graphValues: [ChartDataEntry] = []
//            graphValues.append(ChartDataEntry(x: 0, y: 0))
//            for index in 1..<8 {
//                let randomValue = Double(arc4random_uniform(15000))
//                graphValues.append(ChartDataEntry(x: Double(index), y: randomValue ))
//            }
//            extractedFunc(graphValues, UIColor.PurpleColor)
//
//            let lastPoint = self.chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
//            print("lastPoint : \(lastPoint)")
//            self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
//            self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: graphValues[graphValues.count - 1].x, yValue: graphValues[graphValues.count - 1].y)
//            self.customMarkerView.contentView.isHidden = false
//        }else{
            self.dateTimeArr = []
            self.callChartApi(duration: chartDuration.rawValue)
//        }
        
    }
}

//MARK: - objective functions
extension PortfolioDetailTVC{
    @objc func backBtnAct(){
        self.controller?.navigationController?.popViewController(animated: true)
    }
    
    @objc func coinBtnAct(){
        let vc = SearchAssetVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
        vc.assetNameCallback = {assetName in
            self.controller?.assetName = assetName
            self.controller?.callCoinInfoApi()
        }
    }
}


extension PortfolioDetailTVC: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        print("chartValueSelected : x = \(highlight.x) y = \(highlight.y)")
        self.customMarkerView.center = CGPoint(x: highlight.xPx, y: (highlight.yPx ))
        self.customMarkerView.contentView.isHidden = false
        self.hideShowBubble(xPixel: highlight.xPx, yPixel: highlight.yPx, xValue: highlight.x, yValue:highlight.y )
        
    }
}

//MARK: - Other functions
extension PortfolioDetailTVC{
    func callChartApi(duration : String){
        self.controller?.portfolioDetailVM.getChartDataApi(AssetId: self.assetName, timeFrame: duration , completion: {[ self]response in
//            CommonFunction.hideLoader()
            if let response = response{
                var graphValues: [ChartDataEntry] = []
                
                let modifiedDateArr = self.getTimeValues(date: response.data?.lastUpdate ?? "", timeFrame: duration, count: response.data?.prices?.count ?? 0)
                print("modifiedDateArr \(modifiedDateArr)")
                
                for (index,value) in stride(from: 0, through: (response.data?.prices?.count ?? 0)-1, by: 1).enumerated(){
                    self.dateTimeArr.append(graphStruct(index: index, date: modifiedDateArr[value], euro: Double(response.data?.prices?[value] ?? "") ?? 0))
               
        //            let yValue = chartData?.prices?[value][1] ?? ""
                    let yValue = Double(response.data?.prices?[value] ?? "") ?? 0
                    graphValues.append(ChartDataEntry(x: Double(value), y: yValue))
                }
                self.extractedFunc(graphValues, UIColor.PurpleColor)
                
                let lastPoint = self.chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
                print("lastPoint : \(lastPoint)")
                self.customMarkerView.center = CGPoint(x: lastPoint.x , y: (lastPoint.y ) )
                self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: graphValues[graphValues.count - 1].x, yValue: graphValues[graphValues.count - 1].y)
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
        print(yValue)
        customMarkerView.graphLbl.text = "\(CommonFunction.formattedCurrency(from: yValue))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunction.formattedCurrency(from: yValue))€"

        for (index,_) in stride(from: 0, through: (self.dateTimeArr.count)-1, by: 1).enumerated(){
            if self.dateTimeArr[index].index == Int(xValue){
                customMarkerView.dateTimeLbl.text = self.dateTimeArr[index].date
                customMarkerView.bottomDateLbl.text = self.dateTimeArr[index].date
            }
        }
    }
}


extension PortfolioDetailTVC : URLSessionWebSocketDelegate{
    func receiveMessage() {
        if !isOpened {
            openWebSocket(assetName: self.assetName)
        }
        self.controller?.webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let messageString):
                    print(messageString)
                    let messageDict = messageString as String
                    print(messageDict)
                    do{
                        let data = messageString.data(using: .utf8)
                        let jsondata = try JSON(data: data ?? Data())
                        print(jsondata["Price"])
                        let price = (jsondata["Price"].rawValue) as? String
                        let value = Double(price ?? "")
                        DispatchQueue.main.async {
                            if value  != 0{
                                self?.euroLbl.text = "\(CommonFunction.formattedCurrency(from: value ))€"
                            }
                        }
                    }
                    catch let error as NSError {
                        print(error)
                    }
//
                case .data(let data):
                    print(data.description)
                default:
                    print("Unknown type received from WebSocket")
                }
            }
            self?.receiveMessage()
        })
    }

    func openWebSocket(assetName : String) {
        let urlString = ApiEnvironment.socketBaseUrl + "\(assetName)eur"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            self.controller?.webSocket = session.webSocketTask(with: request)
            self.controller?.webSocket?.resume()
            isOpened = true
        }
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Web socket opened")
//        isOpened = true
    }

    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Web socket closed")
//        isOpened = false
    }

}
