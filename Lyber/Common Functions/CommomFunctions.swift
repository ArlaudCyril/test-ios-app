//
//  CommomFunctions.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit
import SwiftEntryKit
import Charts
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class EntryAttributeWrapper {
    var attributes: EKAttributes
    init(with attributes: EKAttributes) {
        self.attributes = attributes
    }
}

class CommonFunctions{
    var attributes = EKAttributes()
    
    static func toster(_ txt : String){
        let attributesWrapper: EntryAttributeWrapper = {
            var attributes = EKAttributes()
            attributes.positionConstraints = .fullWidth
            attributes.hapticFeedbackType = .success
            attributes.positionConstraints.safeArea = .empty(fillSafeArea: true)
            attributes.entryBackground = .visualEffect(style: .dark)
            attributes.displayDuration = 3
            return EntryAttributeWrapper(with: attributes)
        }()
        let title = EKProperty.LabelContent(
            text: txt,
            style: EKProperty.LabelStyle(font: UIFont.boldSystemFont(ofSize: 16), color: EKColor.white, alignment: NSTextAlignment.center, displayMode: .light, numberOfLines: 0)
        )
        let description = EKProperty.LabelContent(
            text: "",
            style: EKProperty.LabelStyle(
                font: UIFont.systemFont(ofSize: 1, weight: .light),
                color: .black
            )
        )
        let simpleMessage = EKSimpleMessage(
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributesWrapper.attributes)
    }

    static func logout(){
//        let vc = CommonFunction.getTopMostViewController()
//        vc?.dismiss(animated: true, completion: {
            let vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
            let navVC = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows[0].rootViewController = navVC
            UIApplication.shared.windows[0].makeKeyAndVisible()
            navVC.navigationController?.popToRootViewController(animated: true)
            navVC.setNavigationBarHidden(true , animated: true)
            userData.shared.deleteData()
            
//        })
        
    }
    
    static func showLoader(){
        let topView = getTopMostViewController()?.view
        let loadingView = UIView(frame : CGRect(x: 0, y: 0, width: topView?.frame.width ?? 0, height: topView?.frame.height ?? 0))
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.6
        
        
//        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "biercelona-beer", withExtension: "gif")!)
//        let advTimeGif = UIImage.gifImageWithData(data: imageData! as NSData)
//        let imageView = UIImageView(image: advTimeGif)
//        imageView.frame = CGRect(x: (topView?.frame.width ?? 0)/2 - 20, y: (topView?.frame.height ?? 0)/2 - 20, width: 40, height: 40)
                
        
        let laodingFrame = SpinnerView(frame: CGRect(x: (topView?.frame.width ?? 0)/2 - 20, y: (topView?.frame.height ?? 0)/2 - 20, width: 40, height: 40))
        loadingView.addSubview(laodingFrame)
        loadingView.tag = 111
        var present = false
        if topView != nil{
            for (_,subView) in topView!.subviews.enumerated(){
                if subView.tag == 111 || subView.tag == 191 {
                    present = true
                }
            }
        }
        if !present{
            topView?.addSubview(loadingView)
        }
    }
    
    static func showLoader(_ onView : UIView){
        let topView = onView
        let loadingView = UIView(frame : CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height))
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.6
        let laodingFrame = SpinnerView(frame: CGRect(x: topView.frame.width/2 - 20, y: topView.frame.height/2 - 20, width: 40, height: 40))
        loadingView.addSubview(laodingFrame)
        loadingView.tag = 111
        var present = false
        for (_,subView) in topView.subviews.enumerated(){
            if subView.tag == 111 {
                present = true
            }
        }
        if !present{
            topView.addSubview(loadingView)
        }
    }
    
    static func hideLoader(){
        let topView = getTopMostViewController()?.view
        if topView != nil{
            for (num,subView) in topView!.subviews.enumerated(){
                if subView.tag == 111{
                    topView!.subviews[num].removeFromSuperview()
                }
            }
        }
    }
    
    static func hideLoader(_ onView : UIView){
        let topView = onView
        for (num,subView) in topView.subviews.enumerated(){
            if subView.tag == 111{
                topView.subviews[num].removeFromSuperview()
            }
        }
    }
    
    // for getting top most view controller
    static func getTopMostViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
            // topController should now be your topmost view controller
        }
        return nil
    }
    
    
    static func getImageUrl() -> String{
        return "ApiEnviorment.ImageUrl"
    }
    
    
    //MARK: - Line Chart
    
    static func drawChart(with data: [ChartDataEntry], on view: LineChartView, gradientColors: [UIColor], lineColor: UIColor){
        view.rightAxis.enabled = false
        view.xAxis.enabled = false
        view.leftAxis.enabled = false
        view.legend.enabled = false
        view.pinchZoomEnabled = false
        view.doubleTapToZoomEnabled = false
        view.scaleXEnabled = false
        view.scaleYEnabled = false
        //        view.animate(xAxisDuration: 0.2)
        
        let set1 = LineChartDataSet(entries: data, label: "")
        set1.mode = .horizontalBezier
        set1.lineWidth = 1
        set1.drawCirclesEnabled = false
        set1.highlightEnabled = false
        set1.colors = [lineColor]
        
        let gradientColors = [gradientColors[0].cgColor, gradientColors[1].cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set1.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)    // Set the Gradient
        set1.drawFilledEnabled = true // Draw the Gradient
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        view.data = data
    }
    
    static func drawDetailChart(with data: [ChartDataEntry], on view: LineChartView, gradientColors: [UIColor], lineColor: UIColor){
        view.xAxis.enabled = false
        view.minOffset = 0
        view.leftAxis.drawLabelsEnabled = false
        
        view.leftAxis.enabled = false
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawAxisLineEnabled = false
        view.legend.enabled = false
//        view.pinchZoomEnabled = false
//        view.doubleTapToZoomEnabled = false
        view.scaleXEnabled = false
        view.scaleYEnabled = true
        
        view.leftAxis.gridColor = lineColor
        view.extraTopOffset = 8
        view.extraLeftOffset = 24
        view.extraRightOffset = 24
        view.extraBottomOffset = 4
        
        view.leftAxis.labelFont = .MabryPro(Size.Medium.sizeValue())
        view.leftAxis.labelTextColor = .primaryTextcolor
        view.dragEnabled = true
        view.dragXEnabled = true
        view.dragYEnabled = true
        view.doubleTapToZoomEnabled = false
//        view.setVisibleXRangeMaximum(30)
//        view.setVisibleXRange(minXRange: 20, maxXRange: 100)
        
        //        let valFormatter = NumberFormatter()
        //        valFormatter.numberStyle = .currency
        //        valFormatter.maximumFractionDigits = 0
        //        valFormatter.currencySymbol = "$"
        //        view.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valFormatter)
        //
        //        view.animate(xAxisDuration: 0.2)
        
        let set1 = LineChartDataSet(entries: data, label: "")
        set1.mode = .linear
        set1.lineWidth = 3
        set1.drawHorizontalHighlightIndicatorEnabled = false // hide horizontal line
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.highlightEnabled = true
        set1.highlightLineDashLengths = [8.0, 4.0]
        set1.highlightLineWidth = 2.0
        set1.highlightColor = UIColor.PurpleColor
        set1.colors = [lineColor]
        set1.drawCirclesEnabled = false
    
//        set1.setColor(lineColor,alpha: 1)
//        set1.circleColors = [lineColor]
//        set1.circleHoleRadius = 1
//        set1.circleRadius = 3.5
//        set1.drawCirclesEnabled = true
//        set1.drawCircleHoleEnabled = true
//        set1.circleHoleColor = UIColor.whiteColor
        
//        let gradientColors = [gradientColors[0].cgColor, gradientColors[1].cgColor] as CFArray // Colors of the gradient
//        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
//        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
//        set1.fill = LinearGradientFill(gradient: gradient!, angle: 90.0)  // Set the Gradient
//        set1.drawFilledEnabled = true // Draw the Gradient
        
//        let data = LineChartData(dataSets: [set1])
        let data = LineChartData(dataSet: set1)
        data.isHighlightEnabled = true
        data.setDrawValues(false)
        data.setValueTextColor(UIColor.PurpleColor)
        data.setValueFont(UIFont.MabryProMedium(Size.Medium.sizeValue()))
        data.maxEntryCountSet?.drawIconsEnabled = true
        view.data = data
        
        view.rightAxis.enabled = true
        view.rightAxis.labelPosition = .outsideChart
        view.rightAxis.drawGridLinesEnabled = false
        
        view.rightAxis.labelCount = 3
        view.rightAxis.axisMaxLabels = 3
        view.rightAxis.setLabelCount(3, force: true)
        
    }
    
    static func invalidPassTyp(_ checkpass:String) -> Bool{
        let passwordCheck = "(?=.*[A-Z])(?=.*[d$@$!%*?&#.><,)/+*(])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let password = NSPredicate(format:"SELF MATCHES %@", passwordCheck)
        return password.evaluate(with: checkpass)
    }

    //MARK: - String
    
    static func underlineString(str: String) -> (NSAttributedString){
        let myAttribute = [ NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue]
        let myString = NSMutableAttributedString(string: str, attributes: myAttribute)
        return myString
    }
    
    static func removeUnderlineString(str: String) -> (NSAttributedString){
        let myAttribute = [ NSAttributedString.Key.underlineStyle : 0]
        let myString = NSMutableAttributedString(string: str, attributes: myAttribute)
        myString.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSRange(location: 0, length: myString.length))
        return myString
    }
    
    
    static func getDateFormat(date: String, format: String, rqrdFormat: String) -> String {
        
        guard date != "" else {return ""}
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        //        (selectedLanguage.code == "en") ? (inputFormatter.locale = Locale(identifier: "en")) : (inputFormatter.locale = Locale(identifier: "ar"))
        let showDate = inputFormatter.date(from: date)
        inputFormatter.dateFormat = rqrdFormat
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    static func getCurrentDate(requiredFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = requiredFormat
        return dateFormatter.string(from: Date())
        
    }
    
    static func getTwoDecimalValue(number: Double) -> Double{
        let stringValue = String(format: "%.2f", number)
        return Double(stringValue)!
    }
    
    static func formattedCurrency(from value: Double?) -> String {
        guard value != nil else { return "$0.00" }
//        let doubleValue = Double(value!) ?? 0.0
        let formatter = NumberFormatter()
//        formatter.currencyCode = "EUR"
//        formatter.currencySymbol = "€"
//        formatter.locale = Locale(identifier: "es_ES")
        

        if(value ?? 0 > 10000)
        {
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits =  0
        }
        else if(value ?? 0 > 1000){
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits =  1
        }
        else{
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits =  2
        }
      
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
//        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "$\(value ?? 0)"
    }
    
    static func numberFormat(from value: Double?) -> String {
        guard value != nil else { return "$0.00" }
        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: "US")
//        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 0
        
//        formatter.minimumFractionDigits = ((value!.description.contains(".0")) || !(value!.description.contains("."))) ? 2 : 0
        formatter.maximumFractionDigits = 8
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "$\(value ?? 0)"
        
        
//        guard value != nil else { return "$0.00" }
//        let formatter = NumberFormatter()
//        formatter.currencyCode = "EUR"
//        formatter.currencySymbol = "€"
//        //        formatter.locale = .current
//        formatter.minimumFractionDigits = ((value!.contains(0.00)) || !(value!.contains("."))) ? 0 : 2
//        formatter.maximumFractionDigits = 2
//        formatter.numberStyle = .currencyAccounting
//        return formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "$\(value ?? 0)"
    }
    
    static func getDateFromUnixInterval(timeResult : Double,requiredFormat : String)->(String){
        let date = Date(timeIntervalSince1970: TimeInterval(timeResult)/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = .current
        dateFormatter.dateFormat = requiredFormat
        let localDate = dateFormatter.string(from: date)
        print(localDate)
        return localDate
    }
    
    static func getDate(date : Date)->(String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        let resultString = dateFormatter.string(from: date)
        print(resultString)
        return resultString
    }
    
    //MARK: - Decoder
    static func frequenceDecoder(frequence : String?)->(String){
        switch frequence {
        case "1d":
            return L10n.Daily.description
        case "1w":
            return L10n.Weekly.description
        case "1m":
            return L10n.Monthly.description
        default:
            return ""
        }
    }
    
    //MARK: - Encoder
    static func frequenceEncoder(frequence : String?)->(String){
        switch frequence {
        case L10n.Once.description:
            return "1d"
        case L10n.Daily.description:
            return "1d"
        case L10n.Weekly.description:
            return "1w"
        case L10n.Monthly.description:
            return "1m"
        default:
            return ""
        }
    }
    
    static func selectorStrategyColor(position : Int, totalNumber : Int) -> UIColor{
        if(totalNumber > 8)
        {
            let percentage = Double(position) / Double(totalNumber)
            let color = UIColor(named: "purple_800")?.lighter(componentDelta: CGFloat(percentage)) ?? UIColor()
            return color
        }
        else
        {
            switch totalNumber {
            case 1:
                return UIColor(named: "purple_600") ?? UIColor()
            case 2:
                switch position{
                case 0:
                    return UIColor(named: "purple_600") ?? UIColor()
                default:
                    return UIColor(named: "purple_400") ?? UIColor()
                }
            case 3:
                switch position{
                case 0:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_400") ?? UIColor()
                default:
                    return UIColor(named: "purple_200") ?? UIColor()
                }
            case 4:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                default:
                    return UIColor(named: "purple_200") ?? UIColor()
                }
            case 5:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_200") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 6:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 7:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_300") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 5:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
            case 8:
                switch position{
                case 0:
                    return UIColor(named: "purple_800") ?? UIColor()
                case 1:
                    return UIColor(named: "purple_600") ?? UIColor()
                case 2:
                    return UIColor(named: "purple_500") ?? UIColor()
                case 3:
                    return UIColor(named: "purple_400") ?? UIColor()
                case 4:
                    return UIColor(named: "purple_300") ?? UIColor()
                case 5:
                    return UIColor(named: "purple_200") ?? UIColor()
                case 6:
                    return UIColor(named: "purple_100") ?? UIColor()
                default:
                    return UIColor(named: "purple_00") ?? UIColor()
                }
                
            default:
                return UIColor(named: "purple_400") ?? UIColor()
            }
        }
        
    }

}
