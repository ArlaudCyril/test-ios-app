//
//  TotalEarningsVC.swift
//  Lyber
//
//  Created by sonam's Mac on 17/06/22.
//

import UIKit
import Charts

class TotalEarningsVC: ViewController {
    
    //MARK: - Variables
    var chartData = ["1H","1D","1W","1M","1Y","ALL"]
    var assetsData : [Asset] = []
    var returnOnInvestment : Bool? = false
    let customMarkerView = customMarker()
    
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var dropdownBtn: UIButton!
    @IBOutlet var totalEarningLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var yieldLbl: UILabel!
    @IBOutlet var chartView: LineChartView!
//    @IBOutlet var collView: UICollectionView!
    @IBOutlet var assetBreakdownLbl: UILabel!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var tblview: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callMyAssetsApi()
//        setUpChart()
    }

    override func setUpUI(){
        
        
        self.backBtn.layer.cornerRadius = 12
        if returnOnInvestment == true{
            CommonUI.setUpButton(btn: self.dropdownBtn, text: "  \(CommonFunctions.localisation(key: "RETURN_ON_INVESTMENT"))  ", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: totalEarningLbl, text: "\(CommonFunctions.localisation(key: "YIELD")) : ", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: euroLbl, text: "5.01%", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
            CommonUI.setUpLbl(lbl: yieldLbl, text: "Total earnings: 0.00€", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))
        }else{
            CommonUI.setUpButton(btn: self.dropdownBtn, text: "  \(CommonFunctions.localisation(key: "TOTAL_EARNINGS"))  ", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: totalEarningLbl, text: CommonFunctions.localisation(key: "TOTAL_EARNINGS"), textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: euroLbl, text: "0.00€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
            CommonUI.setUpLbl(lbl: yieldLbl, text: "Yield: 5.01%", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))
        }
//        self.collView.layer.cornerRadius = 12
//        self.collView.backgroundColor = UIColor.borderColor
//        self.collView.delegate = self
//        self.collView.dataSource = self
        self.tblview.delegate = self
        self.tblview.dataSource = self
        self.tblview.layer.cornerRadius = 16
        bottomView.layer.cornerRadius = 32
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        CommonUI.setUpLbl(lbl: assetBreakdownLbl, text: "Assets breakdown", textColor: UIColor.grey36323C, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.dropdownBtn.addTarget(self, action: #selector(dropdownBtnAct), for: .touchUpInside)
    }
    
    func setUpChart(){
        var graphValues: [ChartDataEntry] = []
        for index in 0..<8 {
//            let randomValue = Double(arc4random_uniform(15000))
            graphValues.append(ChartDataEntry(x: Double(index), y: 0))
        }
        extractedFunc(graphValues, UIColor.PurpleColor)
       
        let lastPoint = chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
        print("lastPoint : \(lastPoint)")
        self.customMarkerView.center = CGPoint(x: lastPoint.x, y: (lastPoint.y ))
        self.customMarkerView.contentView.isHidden = true
        self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: graphValues[graphValues.count - 1].x, yValue: graphValues[graphValues.count - 1].y)
        
        self.chartView.delegate = self
//        self.customMarkerView.gifImg.image = UIImage.gifImageWithName("Animation_1")
        self.chartView.addSubview(customMarkerView)
       
    }
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunctions.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
}

////MARK: - Coll VIEW DELEGATE AND DATA SOURCE METHODS
//extension TotalEarningsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return chartData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioHomeCVC", for: indexPath as IndexPath) as! PortfolioHomeCVC
//        cell.configureWithData(data : chartData[indexPath.row])
//        if (indexPath.row == 0){
//            cell.isSelected = true
//            self.collView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: ((collView.layer.bounds.width/6) - 12), height: collView.layer.bounds.height)
//    }
//
//}

//MARK:- objective functions
extension TotalEarningsVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dropdownBtnAct(){
        
    }
}


//Mark:- table view delegates and dataSource
extension TotalEarningsVC: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TotalEarningsTVC")as! TotalEarningsTVC
        cell.setUpCell(data: assetsData[indexPath.row],index : indexPath.row, lastIndex: assetsData.count - 1)
        return cell
    }

}

// MARK: - TABLE VIEW OBSERVER
extension TotalEarningsVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.setUpUI()
      self.tblview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      self.tblview.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.tblview.removeObserver(self, forKeyPath: "contentSize")
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if let obj = object as? UITableView {
          if obj == self.tblview && keyPath == "contentSize" {
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
              self.tblViewHeightConst.constant = newSize.height
            }
          }
      }
    }
}

extension TotalEarningsVC: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		guard (chartView.data?.dataSets[highlight.dataSetIndex]) != nil else { return }
        print("chartValueSelected : x = \(highlight.xPx) y = \(highlight.yPx)")
        
        customMarkerView.center = CGPoint(x: highlight.xPx, y: (highlight.yPx ))
//        customMarkerView.graphLbl.text = "\(highlight.y)€"
//        customMarkerView.bottomEuroLbl.text = "\(CommonFunction.formattedCurrency(from: highlight.y))€"
//        customMarkerView.dateTimeLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
//        customMarkerView.bottomDateLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
//        customMarkerView.isHidden = false
        
//        let pixel: CGPoint = self.chartView.pixelForValues(x: highlight.x, y: highlight.y, axis: .left)
//        if pixel.y > self.chartView.layer.bounds.height/2{
//            customMarkerView.bottomBubble.isHidden = true
//            customMarkerView.topBubble.isHidden = false
//        }else{
//            customMarkerView.bottomBubble.isHidden = false
//            customMarkerView.topBubble.isHidden = true
//        }
//
        customMarkerView.isHidden = false
        
        let pixel: CGPoint = self.chartView.pixelForValues(x: highlight.x, y: highlight.y, axis: .left)
        print("pixel is : \(pixel)")
        self.hideShowBubble(xPixel: highlight.xPx, yPixel: highlight.yPx, xValue: highlight.x, yValue:highlight.y )
//        customMarkerView.chartView = self.chartView
//        self.chartView.marker = customMarkerView
//        self.chartView.drawMarkers = true

    }
}

//MARK: - Other functions
extension TotalEarningsVC{
    func callMyAssetsApi(){
        CommonFunctions.showLoader(self.view)
        PortfolioHomeVM().getMyAssetsApi(completion: {[weak self]response in
            CommonFunctions.hideLoader(self?.view ?? UIView())
            if let response = response{
                self?.assetsData = response.assets ?? []
                self?.tblview.reloadData()
                self?.setUpChart()
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
        DispatchQueue.main.async {
//            self.customMarkerView.contentView.isHidden = false
        }
        self.customMarkerView.contentView.isHidden = false
        customMarkerView.graphLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunctions.formattedCurrency(from: yValue))€"
        customMarkerView.dateTimeLbl.text = "\(CommonFunctions.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
        customMarkerView.bottomDateLbl.text = "\(CommonFunctions.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
    }
}
