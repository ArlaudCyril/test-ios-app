//
//  chartVC.swift
//  Lyber
//
//  Created by sonam's Mac on 11/10/22.
//

import UIKit
import Charts

class chartVC: UIViewController {

    let customMarkerView = customMarker()
    
    
    @IBOutlet var chartVw: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var graphValues: [ChartDataEntry] = []
        graphValues.append(ChartDataEntry(x: 0, y: 0))
        for index in 1..<10 {
            let randomValue = Double(arc4random_uniform(15000))
            graphValues.append(ChartDataEntry(x: Double(index), y: randomValue ))
        }
        extractedFunc(graphValues, UIColor.PurpleColor)
        self.chartVw.delegate = self
        self.chartVw.addSubview(customMarkerView)
        self.customMarkerView.gifImg.image = UIImage.gifImageWithName("Animation")
        
//        customMarkerView.chartView = chartVw
//        chartVw.marker = customMarkerView
    }
    
    
    func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunction.drawDetailChart(with: graphValues, on: chartVw, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }


}


extension chartVC: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected : x = \(highlight.xPx) y = \(highlight.yPx)")
//        customMarkerView.frame = CGRect(x: highlight.xPx, y: highlight.yPx, width: self.customMarkerView.frame.width, height: self.customMarkerView.frame.height)
//        self.customMarkerView.offset = CGPoint(x: (-((self.customMarkerView.frame.width/2))), y: -((72)))
        self.customMarkerView.center = CGPoint(x: highlight.xPx, y: highlight.yPx)
        customMarkerView.isHidden = false
        
        customMarkerView.graphLbl.text = "\(CommonFunction.formattedCurrency(from: highlight.y))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunction.formattedCurrency(from: highlight.y))€"
        customMarkerView.dateTimeLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
        customMarkerView.bottomDateLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            if touch.view == self.chartVw{
//                let loc:CGPoint = touch.location(in: touch.view)
//                print(loc)
//            }
//        }
    }
}
        

//
////        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
////           let entryIndex = dataSet.entryIndex(entry: entry)
////
////        print("entryIndex :\(entryIndex)")
////
//        self.chartVw.marker = customMarkerView
////        customMarkerView.center = CGPoint(x: highlight.x , y:highlight.y)
////        let pos = self.chartVw.getMarkerPosition(highlight: highlight)
////        print(pos)
//
//
//        customMarkerView.graphLbl.text = "\(CommonFunction.formattedCurrency(from: highlight.y))€"
//        customMarkerView.bottomEuroLbl.text = "\(CommonFunction.formattedCurrency(from: highlight.y))€"
//        customMarkerView.dateTimeLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
//        customMarkerView.bottomDateLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
//        customMarkerView.isHidden = false
////        let pixel: CGPoint = self.chartVw.pixelForValues(x: highlight.x, y: highlight.y, axis: .left)
////        if pixel.y > self.chartVw.layer.bounds.height/2{
////            customMarkerView.bottomBubble.isHidden = true
////            customMarkerView.topBubble.isHidden = false
////        }else{
////            customMarkerView.bottomBubble.isHidden = false
//////            customMarkerView.topBubble.isHidden = true
////        }
////        customMarkerView.center = CGPoint(x: 5, y: 100)
////        self.customMarkerView.frame = CGRect(x: highlight.x , y: highlight.y, width: self.customMarkerView.contentView.frame.width, height: self.customMarkerView.contentView.frame.height)
////        self.customMarkerView.center = CGPoint(x: <#T##Double#>, y: <#T##Double#>)
////        self.customMarkerView.
//
////        self.customMarkerView.gifImg.image = UIImage.gifImageWithName("collection_two")
