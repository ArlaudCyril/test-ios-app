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
//    var chartData = ["1D","1W","1M","1Y","ALL"]
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
        var graphValues: [ChartDataEntry] = []
        graphValues.append(ChartDataEntry(x: 0, y: 0))
        for index in 1..<8 {
            let randomValue = Double(arc4random_uniform(15000))
            graphValues.append(ChartDataEntry(x: Double(index), y: randomValue ))
        }
        extractedFunc(graphValues, UIColor.PurpleColor)
        let lastPoint = chartView.getPosition(entry: graphValues[graphValues.count - 1], axis: .left)
        print("lastPoint : \(lastPoint)")
        self.customMarkerView.center = CGPoint(x: lastPoint.x, y: (lastPoint.y ))
        self.customMarkerView.contentView.isHidden = true
        self.hideShowBubble(xPixel: lastPoint.x, yPixel: lastPoint.y, xValue: graphValues[graphValues.count - 1].x, yValue: graphValues[graphValues.count - 1].y)
        
        
        
        CommonUI.setUpLbl(lbl: portfolioLbl, text: L10n.Portfolio.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: euroLbl, text: "\(CommonFunction.formattedCurrency(from: totalPortfolio ))€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
        
        
        self.profilePic.yy_setImage(with: URL(string: "\(ApiEnvironment.ImageUrl)\(userData.shared.profile_image)"), placeholder: UIImage(named: "profile"))
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.profilePicVw.layer.cornerRadius = self.profilePicVw.layer.bounds.height/2
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileAction))
        self.profilePic.addGestureRecognizer(profileTap)
        self.profilePic.isUserInteractionEnabled = true
//        self.profilePic.image = UIImage.gifImageWithName("Animation_1")
        
        self.chartView.delegate = self
//        self.customMarkerView.gifImg.image = UIImage.gifImageWithName("Animation_1")
        self.chartView.addSubview(customMarkerView)
//        self.playVideo()

    }
    
    fileprivate func extractedFunc(_ graphValues: [ChartDataEntry],_ graphColor : UIColor) {
        CommonFunction.drawDetailChart(with: graphValues, on: chartView, gradientColors: [graphColor, UIColor.whiteColor], lineColor: graphColor)
    }
    
    func playVideo(){
        guard let firstVideo = Bundle.main.path(forResource: "Animation_2", ofType:"mp4") else {
            debugPrint("Video not found")
            return
        }
        playerAV = AVPlayer(url: URL(fileURLWithPath: firstVideo))
        let playerLayerAV = AVPlayerLayer(player: playerAV)
        playerLayerAV.frame = self.customMarkerView.gifImg.bounds
        playerLayerAV.backgroundColor = UIColor.clear.cgColor
        self.customMarkerView.gifImg.layer.addSublayer(playerLayerAV)
//        playerLayerAV.videoGravity = .resizeAspectFill
        playerAV.play()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(animationDidFinish(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: playerAV.currentItem)
        
    }
    
    @objc func animationDidFinish(_ notification: NSNotification) {
            playerAV.seek(to: .zero)
            playerAV.play()
//            playerAV.pause()
            print(#function)
        }
}


extension PortfolioHomeTVC: ChartViewDelegate{
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
       print("nothing selected")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected : x = \(highlight.xPx) y = \(highlight.yPx)")
        self.customMarkerView.center = CGPoint(x: highlight.xPx, y: (highlight.yPx ))
        customMarkerView.isHidden = false
        
        let pixel: CGPoint = self.chartView.pixelForValues(x: highlight.x, y: highlight.y, axis: .left)
        print("pixel is : \(pixel)")
        self.hideShowBubble(xPixel: highlight.xPx, yPixel: highlight.yPx, xValue: highlight.x, yValue:highlight.y )
//        if highlight.yPx > self.chartView.layer.bounds.height/2{
//            customMarkerView.bottomBubble.isHidden = true
//            customMarkerView.topBubble.isHidden = false
//        }else{
//            customMarkerView.bottomBubble.isHidden = false
//            customMarkerView.topBubble.isHidden = true
//        }
       
    }

}

extension PortfolioHomeTVC{
    @objc func profileAction(){
        let vc = ProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.controller?.present(nav, animated: true, completion: nil)
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
        
        customMarkerView.graphLbl.text = "\(CommonFunction.formattedCurrency(from: yValue))€"
        customMarkerView.bottomEuroLbl.text = "\(CommonFunction.formattedCurrency(from: yValue))€"
        customMarkerView.dateTimeLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
        customMarkerView.bottomDateLbl.text = "\(CommonFunction.getCurrentDate(requiredFormat: "MMM dd, HH:mm"))"
    }
}
