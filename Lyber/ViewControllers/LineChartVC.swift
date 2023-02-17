//
//  LineChartVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit
import Charts

class LineChartVC: UIViewController {
    let customMarkerView = customMarker()
    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var graphValues: [ChartDataEntry] = []
        for index in 0..<6 {
            let randomValue = Double(arc4random_uniform(20))
            graphValues.append(ChartDataEntry(x: Double(index), y: randomValue))
        }
        extractedFunc(graphValues, UIColor.PurpleColor)
        self.chartView.delegate = self
        
       
    }
    
    func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunction.drawChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
//        CommonFunction.DetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
   

}
extension LineChartVC: ChartViewDelegate{
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        print("chartValueSelected : x = \(highlight.x) y = \(highlight.y)")
        
//        let graphPoint = chartView.getMarkerPosition(entry: entry,  highlight: highlight)
        let graphPoint = chartView.getMarkerPosition(highlight: highlight)
        customMarkerView.center = CGPoint(x: highlight.x, y: highlight.y)
        customMarkerView.isHidden = false
        
//        customMarkerView.chartView = self.chartView
        self.chartView.marker = customMarkerView
//        self.chartView.drawMarkers = true

    }
}
