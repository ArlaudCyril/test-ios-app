//
//  customMarker.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import Foundation
import UIKit
import Charts
import NVActivityIndicatorView

class customMarker : MarkerView{
    
    var activityIndicator : NVActivityIndicatorView!
    
    @IBOutlet var topBubble: UIStackView!
 
    @IBOutlet var gifBtn: UIButton!
    @IBOutlet var gifImg: UIImageView!
    @IBOutlet var euroView: UIStackView!
    @IBOutlet var graphLbl: UILabel!
    @IBOutlet var dateTimeLbl: UILabel!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var markerDotVw: UIView!
    @IBOutlet var outerMarkerView: UIView!
    @IBOutlet var centerWhiteVw: UIView!
    @IBOutlet var outerMarkerViewWidthConst: NSLayoutConstraint!
    
    @IBOutlet var imageViewCenterTopBubbleConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewCenterBottomBubbleConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomBubble: UIStackView!
    @IBOutlet var bottomEuroLbl: UILabel!
    @IBOutlet var bottomDateLbl: UILabel!
    
    @IBOutlet var centerDot: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func initUI() {
        
        Bundle.main.loadNibNamed("customMarker", owner: self, options: nil)
        self.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        self.offset = CGPoint(x: (-((self.frame.width/2))), y: -((75)))
        addSubview(contentView)
        self.euroView.layer.cornerRadius = 4
        self.centerDot.layer.cornerRadius = 6
        
        CommonUI.setUpLbl(lbl: self.graphLbl, text: "", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.dateTimeLbl, text: "", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Small.sizeValue()))
        
        self.bottomBubble.layer.cornerRadius = 4
        CommonUI.setUpLbl(lbl: self.bottomEuroLbl, text: "", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.bottomDateLbl, text: "", textColor: UIColor.PurpleColor, font: UIFont.AtypTextMedium(Size.Small.sizeValue()))
        contentView.backgroundColor = .clear
        
        
        
        self.gifImg.layer.cornerRadius = 15
        let frames = CGRect(x: 0 , y: 0, width: self.gifImg.bounds.width, height: self.gifImg.bounds.height)
        activityIndicator = NVActivityIndicatorView(frame: frames)
        activityIndicator.type = .ballScale // add your type
        activityIndicator.color = UIColor.PurpleColor // add your color

        self.gifImg.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
}
