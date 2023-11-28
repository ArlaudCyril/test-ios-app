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
import SVGKit


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
        let vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        let navVC = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows[0].rootViewController = navVC
        UIApplication.shared.windows[0].makeKeyAndVisible()
        navVC.navigationController?.popToRootViewController(animated: true)
        navVC.setNavigationBarHidden(true , animated: true)
        userData.shared.disconnect()
    }
	
	static func deleteAccount(){
		let vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		let navVC = UINavigationController(rootViewController: vc)
		UIApplication.shared.windows[0].rootViewController = navVC
		UIApplication.shared.windows[0].makeKeyAndVisible()
		navVC.navigationController?.popToRootViewController(animated: true)
		navVC.setNavigationBarHidden(true , animated: true)
		userData.shared.deleteData()
    }
	
	static func stopRegistration(){
		let alert = UIAlertController(title: CommonFunctions.localisation(key: "STOP_REGISTRATION"), message: CommonFunctions.localisation(key: "PROGRESS_REGISTRATION_LOST"), preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "CANCEL"), style: .default, handler: {(action : UIAlertAction) in
			
		}))
		alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "OK"), style: .default, handler: {_ in
			self.deleteAccount()
		}))
		getTopMostViewController()?.present(alert, animated: true, completion: nil)
		
        
    }
	
	static func fatalErrorAction(){
		let vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		let navVC = UINavigationController(rootViewController: vc)
		UIApplication.shared.windows[0].rootViewController = navVC
		UIApplication.shared.windows[0].makeKeyAndVisible()
		navVC.navigationController?.popToRootViewController(animated: true)
		navVC.setNavigationBarHidden(true , animated: true)
		userData.shared.deleteData()
        
    }
	
	static func goHome(){
		let vc = LoginVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		let navVC = UINavigationController(rootViewController: vc)
		UIApplication.shared.windows[0].rootViewController = navVC
		UIApplication.shared.windows[0].makeKeyAndVisible()
		navVC.navigationController?.popToRootViewController(animated: true)
		navVC.setNavigationBarHidden(true , animated: true)
    }
	
	static func goToMaintenance(){
		let vc = MaintenanceVC.instantiateFromAppStoryboard(appStoryboard: .Main)
		let navVC = UINavigationController(rootViewController: vc)
		UIApplication.shared.windows[0].rootViewController = navVC
		UIApplication.shared.windows[0].makeKeyAndVisible()
		navVC.navigationController?.popToRootViewController(animated: true)
		navVC.setNavigationBarHidden(true , animated: true)
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
	
	static func showLoaderTransaction(_ onView : UIView){
        let topView = onView
		let loadingView = UIView(frame : CGRect(x: 16, y: topView.frame.height/10, width: topView.frame.width - 53, height: 36))
        loadingView.backgroundColor = UIColor.black
        loadingView.alpha = 0.6
		loadingView.layer.cornerRadius = 16
		let laodingFrame = SpinnerView(frame: CGRect(x: loadingView.frame.width/2 - 25, y: loadingView.frame.height/2 - 13, width: 25, height: 25))
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
	
	static func showLoaderWhite(_ onView : UIView){
		let topView = onView
		let loadingView = UIView(frame : CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height))
		loadingView.backgroundColor = UIColor.white
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
	
	
	static func showLoaderCheckbox(_ topView : UIView){
		
		
		let loadingView = UIView(frame : CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height))
	    
		loadingView.layer.addSublayer(CALayer())
		loadingView.backgroundColor = UIColor.dark_transparent
		loadingView.alpha = 0.9
		
		let loadingRect = UIView(frame : CGRect(x: topView.frame.width/2 - 60, y: topView.frame.height/2 - 60, width: 120, height: 120))
		loadingRect.backgroundColor = UIColor.white
		loadingView.addSubview(loadingRect)
		loadingView.layer.addSublayer(loadingRect.layer)
		loadingRect.layer.zPosition = 1

		
		let laodingFrame = SpinnerView(frame: CGRect(x: topView.frame.width/2 - 40, y: topView.frame.height/2 - 40, width: 80, height: 80))
		loadingView.addSubview(laodingFrame)
		loadingView.layer.addSublayer(laodingFrame.layer)
		laodingFrame.layer.zPosition = 1
		
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
	
	static func hideLoaderCheckbox(_ onView : UIView, success: Bool){
		
        let topView = onView
		var underView = UIImageView()
		if(success == true){
			underView = UIImageView(image:UIImage(asset: Assets.checkmark_color))
		}else{
			underView = UIImageView(image:UIImage(asset: Assets.close_color))
		}
		underView.frame = CGRect(x: topView.frame.width/2 - 40, y: topView.frame.height/2 - 40, width: 80, height: 80)
		
        for (num,subView) in topView.subviews.enumerated(){
			if subView.tag == 111{
				subView.addSubview(underView)
				subView.layer.addSublayer(underView.layer)
				underView.layer.zPosition = 1
				
				let launcher = Launcher(layer: subView.layer)
				if(success == true){
					launcher.setup(frame: topView.frame)
					subView.layer.addSublayer(launcher)
					launcher.zPosition = 0
					launcher.runCells()
				}
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					topView.subviews[num].removeFromSuperview()
					launcher.emitterCells?.removeAll()
				}
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
    //MARK: Img functions
    
    static func getImageUrl() -> String{
        return "ApiEnviorment.ImageUrl"
    }
	
	static func getImgFromUrl(urlString: String) -> UIImage {
		var imageReturned = UIImage()
		if let url = URL(string: urlString) {
			URLSession.shared.dataTask(with: url) { (data, response, error) in
				guard
					let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
					let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
					let data = data, error == nil,
					let receivedicon: SVGKImage = SVGKImage(data: data),
					let image = receivedicon.uiImage
				else { return }
				imageReturned = image
			}.resume()
		}
		return imageReturned
	}
	
	
	static func getImage(id: String) -> String{
		var idImage = id
		if(idImage == "bsc"){
			idImage = "bnb"
		}
		for currency in Storage.currencies {
			if(currency?.id == idImage){
				return currency?.imageUrl ?? ""
			}
		}
		return ""
	}
	static func getCurrency(id: String) -> AssetBaseData{
		for currency in Storage.currencies {
			if(currency?.id == id){
				return currency ?? AssetBaseData()
			}
		}
		return AssetBaseData()
	}
	
	static func callWalletGetBalance(){
		PortfolioHomeVM().callWalletGetBalanceApi(completion: {[]response in
			if response != nil {
				CommonFunctions.setBalances(balances: response ?? [])
			}
		})
	}
	
	static func getBalance(id: String) -> Balance?{
		for balance in Storage.balances {
			if(balance?.id == id){
				return balance ?? Balance()
			}
		}
		return nil
	}
    
	static func setBalances(balances: [Balance])
	{
		Storage.balances = balances.sorted(by: {Double($0.balanceData.euroBalance) ?? 0 > Double($1.balanceData.euroBalance) ?? 0})
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
        view.scaleYEnabled = false
        
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
        view.rightAxis.setLabelCount(3, force: true)
		view.rightAxis.axisMinimum = data.yMin
		view.rightAxis.axisMaximum = data.yMax
		view.rightAxis.decimals = 2
	
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.maximumFractionDigits = 2
		view.rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: numberFormatter)
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
	
	static func underlineStringInText(str: String, text: String) -> (NSAttributedString){
		var attributedString = NSMutableAttributedString()
		if let range = text.range(of: str) {
			let nsRange = NSRange(range, in: text)
			
			// Create an attributed string
			attributedString = NSMutableAttributedString(string: text)
			
			// Add underline attribute to the specific range
			attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
			
			// Add purple color to the specific range
			attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple_500, range: nsRange)
		}
		
		return attributedString
	}
    

    static func getDateFormat(date: String, inputFormat: String, outputFormat: String) -> String {
        
        guard date != "" else {return ""}
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
		let outputFormatter = DateFormatter()
		outputFormatter.dateFormat = outputFormat
		outputFormatter.configureLocale()
		
		let showDate = inputFormatter.date(from: date)
       
        let resultString = outputFormatter.string(from: showDate ?? Date())
        return resultString
    }
    
    static func getCurrentDate(requiredFormat : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = requiredFormat
        return dateFormatter.string(from: Date())
        
    }
    
    static func getTwoDecimalValue(number: Double) -> Double{
		if(number.isNaN)
		{
			return 0
		}
        let stringValue = String(format: "%.2f", number)
        return Double(stringValue)!
    }
	static func getTwoDecimalValueDecimal(number: Decimal) -> Decimal{
		let nsNumber = NSDecimalNumber(decimal: number)
		let handler = NSDecimalNumberHandler(roundingMode: .down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
		let roundedNumber = nsNumber.rounding(accordingToBehavior: handler)
		return roundedNumber.decimalValue
    }
	
	static func getFormatedPrice(number: Double) -> String{
		if(number.isNaN)
		{
			return "0.00"
		}
        let stringValue = String(format: "%.2f", number)
        return stringValue
    }
	
	static func getFormatedPriceDecimal(number: Decimal) -> String{
		if(number.isNaN)
		{
			return "0.00"
		}
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		
		return formatter.string(from: NSDecimalNumber(decimal: number)) ?? "0.00"
    }
    
    static func formattedCurrency(from value: Double?) -> String {
        guard value != nil else { return "0.00" }
        let formatter = NumberFormatter()


		if(value ?? 0 > 10000)
		{
			formatter.maximumFractionDigits = 0
			formatter.minimumFractionDigits =  0
		}else if(value ?? 0 > 1000){
			formatter.maximumFractionDigits = 1
			formatter.minimumFractionDigits =  1
		}else if(value ?? 0 > 10){
			formatter.maximumFractionDigits = 2
			formatter.minimumFractionDigits =  2
		}else if(value ?? 0 > 1){
			formatter.maximumFractionDigits = 2
			formatter.minimumFractionDigits =  2
		}else if(value ?? 0 > 0.1){
			formatter.maximumFractionDigits = 3
			formatter.minimumFractionDigits =  3
		}else if(value ?? 0 > 0.01){
			formatter.maximumFractionDigits = 4
			formatter.minimumFractionDigits =  4
		}else if(value ?? 0 > 0.001){
			formatter.maximumFractionDigits = 5
			formatter.minimumFractionDigits =  5
		}else if(value ?? 0 > 0.0001){
			formatter.maximumFractionDigits = 6
			formatter.minimumFractionDigits =  6
		}else if(value ?? 0 > 0.00001){
			formatter.maximumFractionDigits = 7
			formatter.minimumFractionDigits =  7
		}else if(value ?? 0 > 0.000001){
			formatter.maximumFractionDigits = 8
			formatter.minimumFractionDigits =  8
		}else if(value ?? 0 > 0.0000001){
			formatter.maximumFractionDigits = 9
			formatter.minimumFractionDigits =  9
		}else if(value ?? 0 > 0.00000001){
			formatter.maximumFractionDigits = 10
			formatter.minimumFractionDigits =  10
		}
      
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
//        formatter.numberStyle = .decimal
		let stringFormatted = formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "0"
		
		return stringFormatted
    }
	
	static func formattedDecimalForValue(from value: Decimal?, for result: Decimal?) -> String {
        guard value != nil else { return "0.00" }
        let formatter = NumberFormatter()


		if(value ?? 0 > 10000)
		{
			formatter.maximumFractionDigits = 0
			formatter.minimumFractionDigits =  0
		}else if(value ?? 0 > 1000){
			formatter.maximumFractionDigits = 1
			formatter.minimumFractionDigits =  1
		}else if(value ?? 0 > 10){
			formatter.maximumFractionDigits = 2
			formatter.minimumFractionDigits =  2
		}else if(value ?? 0 > 1){
			formatter.maximumFractionDigits = 2
			formatter.minimumFractionDigits =  2
		}else if(value ?? 0 > 0.1){
			formatter.maximumFractionDigits = 3
			formatter.minimumFractionDigits =  3
		}else if(value ?? 0 > 0.01){
			formatter.maximumFractionDigits = 4
			formatter.minimumFractionDigits =  4
		}else if(value ?? 0 > 0.001){
			formatter.maximumFractionDigits = 5
			formatter.minimumFractionDigits =  5
		}else if(value ?? 0 > 0.0001){
			formatter.maximumFractionDigits = 6
			formatter.minimumFractionDigits =  6
		}else if(value ?? 0 > 0.00001){
			formatter.maximumFractionDigits = 7
			formatter.minimumFractionDigits =  7
		}else if(value ?? 0 > 0.000001){
			formatter.maximumFractionDigits = 8
			formatter.minimumFractionDigits =  8
		}else if(value ?? 0 > 0.0000001){
			formatter.maximumFractionDigits = 9
			formatter.minimumFractionDigits =  9
		}else if(value ?? 0 > 0.00000001){
			formatter.maximumFractionDigits = 10
			formatter.minimumFractionDigits =  10
		}
      
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = "."
//        formatter.numberStyle = .decimal
		let stringFormatted = formatter.string(from: result! as NSNumber) ?? ""
		
		return stringFormatted
    }
	
	static func formattedAsset(from value: Double?, price: Double?, rounding : NumberFormatter.RoundingMode = .down) -> String {
		guard value != nil else { return "0.00" }
		guard (price != nil && price != 0 && ((price?.isNaN) != true)) else { return "0.00" }
		let formatter = NumberFormatter()
		
		//To find the precision, here X
		//Price * 10e-X >= 0.01(pennies)
		//=> X  >= -log(0,01/Price)
		let precision = Int(ceil(-log10(0.01/(price ?? 1))))
		if(precision > 0){
			formatter.maximumFractionDigits = precision
			formatter.minimumFractionDigits =  precision
		}else{
			formatter.maximumFractionDigits = 0
			formatter.minimumFractionDigits =  0
		}
		
		formatter.groupingSeparator = ","
		formatter.groupingSize = 3
		formatter.usesGroupingSeparator = true
		formatter.decimalSeparator = "."
		formatter.roundingMode = rounding
	
		//        formatter.numberStyle = .decimal
		let stringFormatted = formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "0"
		
		return stringFormatted
	}
	
	static func formattedAssetDecimal(from value: Decimal?, price: Decimal?, rounding : NumberFormatter.RoundingMode = .down) -> String {
		guard value != nil else { return "0.00" }
		guard (price != nil && price != 0 && ((price?.isNaN) != true)) else { return "0.00" }
		let formatter = NumberFormatter()
		
		//To find the precision, here X
		//Price * 10e-X >= 0.01(pennies)
		//=> X  >= -log(0,01/Price)
		let precision = Int(ceil(-log10(0.01/NSDecimalNumber(decimal: price ?? 1).doubleValue)))
		if(precision > 0){
			formatter.maximumFractionDigits = precision
			formatter.minimumFractionDigits =  precision
		}else{
			formatter.maximumFractionDigits = 0
			formatter.minimumFractionDigits =  0
		}
		
		formatter.groupingSeparator = ","
		formatter.groupingSize = 3
		formatter.usesGroupingSeparator = true
		formatter.decimalSeparator = "."
		formatter.roundingMode = rounding
	
		//        formatter.numberStyle = .decimal
		let stringFormatted = formatter.string(from: NSDecimalNumber(decimal: value ?? 0.00)) ?? "0"
		
		return stringFormatted
	}
	
    
    static func numberFormat(from value: Double?) -> String {
        guard value != nil else { return "0.00" }
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
        return formatter.string(from: NSNumber(value: value ?? 0.0)) ?? "\(value ?? 0)"
        
        
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
            return CommonFunctions.localisation(key: "DAILY")
        case "1w":
            return CommonFunctions.localisation(key: "WEEKLY")
        case "1m":
            return CommonFunctions.localisation(key: "MONTHLY")
        default:
            return ""
        }
    }
    
    //MARK: - Encoder
    static func frequenceEncoder(frequence : String?)->(String){
        switch frequence {
			case CommonFunctions.localisation(key: "ONCE"):
            return "now"
        case CommonFunctions.localisation(key: "DAILY"):
            return "1d"
        case CommonFunctions.localisation(key: "WEEKLY"):
            return "1w"
        case CommonFunctions.localisation(key: "MONTHLY"):
            return "1m"
        default:
            return ""
        }
    }
    
    static func enableNotifications(enable: Int)
    {
        if(enable == 1){
			
            UNUserNotificationCenter.current().requestAuthorization(options: [
				.badge, .sound, .alert
                ]) { granted, _ in
                  guard granted else { return }
					DispatchQueue.main.async {
						let application = UIApplication.shared
						application.registerForRemoteNotifications()
					}
                }
        }else if(enable == 2){
            //say to server that notifications are desactivated, no need to block on the phone
            userData.shared.is_push_enabled = 2
            userData.shared.dataSave()
        }
    }
	
	static func localisation(key : String, parameter : String = "") -> String{
		return String(format: NSLocalizedString(key, bundle: GlobalVariables.bundle, comment: ""), parameter)
	}
	
	static func getLocalizationKey(fromLocalizedText text: String, in language: String = "en") -> String {
		if let path = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: "\(language).lproj"),
		   let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
			if let key = dict.keys.first(where: { dict[$0] == text }) {
				return key
			}
		}
		
		return ""
	}
	
	static func translate(string : String) -> String{
		return self.localisation(key: self.getLocalizationKey(fromLocalizedText: string))
	}
    
    static func selectorStrategyColor(position : Int, totalNumber : Int) -> UIColor{
        if(totalNumber > 8)
        {
            let percentage = Double(position) / Double(totalNumber)
			let color = UIColor.purple_800.lighter(componentDelta: CGFloat(percentage))
            return color
        }
        else
        {
            switch totalNumber {
            case 1:
					return UIColor.purple_600
            case 2:
                switch position{
                case 0:
                    return UIColor.purple_600
                default:
						return UIColor.purple_400
                }
            case 3:
                switch position{
                case 0:
                    return UIColor.purple_600
                case 1:
                    return UIColor.purple_400
                default:
                    return UIColor.purple_200
                }
            case 4:
                switch position{
                case 0:
                    return UIColor.purple_800
                case 1:
                    return UIColor.purple_600
                case 2:
                    return UIColor.purple_400
                default:
                    return UIColor.purple_200
                }
            case 5:
                switch position{
                case 0:
                    return UIColor.purple_800
                case 1:
                    return UIColor.purple_600
                case 2:
                    return UIColor.purple_400
                case 3:
                    return UIColor.purple_200
                default:
						return UIColor.purple_00
                }
            case 6:
                switch position{
                case 0:
						return UIColor.purple_800
                case 1:
                    return UIColor.purple_600
                case 2:
                    return UIColor.purple_400
                case 3:
                    return UIColor.purple_200
                case 4:
                    return UIColor.purple_100
                default:
                    return UIColor.purple_00
                }
            case 7:
                switch position{
                case 0:
                    return UIColor.purple_800
                case 1:
                    return UIColor.purple_600
                case 2:
                    return UIColor.purple_400
                case 3:
                    return UIColor.purple_300
                case 4:
                    return UIColor.purple_200
                case 5:
                    return UIColor.purple_100
                default:
                    return UIColor.purple_00
                }
            case 8:
                switch position{
                case 0:
                    return UIColor.purple_800
                case 1:
                    return UIColor.purple_600
                case 2:
                    return UIColor.purple_500
                case 3:
                    return UIColor.purple_400
                case 4:
                    return UIColor.purple_300
                case 5:
                    return UIColor.purple_200
                case 6:
                    return UIColor.purple_100
                default:
                    return UIColor.purple_00
                }
                
            default:
                return UIColor.purple_400
            }
        }
        
    }
	
	
	static func nameLanguage() -> String{
		switch userData.shared.language {
			case "fr":
				return "Français"
			case "en":
				return "English"
			default:
				print("error, language not recognised")
				return ""
		}
	}
	
	static func loadingProfileApi(){
		ProfileVM().getProfileDataApi(completion: {[]response in
			if response != nil{
				//handle language
				if(response?.data?.language == ""){
					if(Bundle.main.preferredLocalizations.first == "fr")
					{
						userData.shared.language = "fr"
					}else{
						userData.shared.language = "en"
					}
				}else{
					userData.shared.language = response?.data?.language?.lowercased() ?? ""
				}
				userData.shared.firstname = response?.data?.firstName ?? ""
				
				userData.shared.lastname = response?.data?.lastName ?? ""
				userData.shared.registeredAt = response?.data?.registeredAt ?? ""
				userData.shared.has2FA = response?.data?.has2FA ?? false
				userData.shared.type2FA = response?.data?.type2FA ?? "none"
				userData.shared.phone_no = response?.data?.phoneNo ?? ""
				userData.shared.email = response?.data?.email ?? ""
				
				userData.shared.scope2FALogin = ((response?.data?.scope2FA.contains("login")) == true)
				userData.shared.scope2FAWhiteListing =  ((response?.data?.scope2FA.contains("whitelisting")) == true)
				userData.shared.scope2FAWithdrawal = ((response?.data?.scope2FA.contains("withdrawal")) == true)
				userData.shared.profile_image = response?.data?.avatar ?? ""
				
				userData.shared.dataSave()
			}
		})
	}
	
	static func handleErrors(caller: String, code: String, error: String, controller: UIViewController = UIViewController()){
		switch code {
			case "-1":
				CommonFunctions.toster(CommonFunctions.localisation(key: "UNKNOWN_ERROR"))
				break
			case "15", "25", "28", "30", "34", "40", "41", "42", "45", "50":
				CommonFunctions.toster(CommonFunctions.localisation(key: "UNKNOWN_ERROR_PARAMETER", parameter: code))
				break
			case "1":
				CommonFunctions.toster(CommonFunctions.localisation(key: "PHONE_ALREADY_REGISTERED"))
				break
			case "3", "8", "9", "26", "29", "46", "52":
				CommonFunctions.toster(CommonFunctions.localisation(key: "FATAL_ERROR", parameter: code))
				CommonFunctions.fatalErrorAction()
				break
			case "5":
				CommonFunctions.toster(CommonFunctions.localisation(key: "EMAIL_ALREADY_EXIST"))
				break
			case "6", "7":
				CommonFunctions.toster(CommonFunctions.localisation(key: "UNKNOWN_ERROR_PARAMETER", parameter: code))
				controller.dismiss(animated: false)
				break
			case "10":
				CommonFunctions.toster(CommonFunctions.localisation(key: "NO_USER_EMAIL"))
				break
			case "11":
				CommonFunctions.toster(CommonFunctions.localisation(key: "NO_USER_PHONE"))
				break
			case "12":
				CommonFunctions.toster(CommonFunctions.localisation(key: "USER_BLOCKED_FROM_LOGIN"))
				break
			case "14":
				CommonFunctions.toster(CommonFunctions.localisation(key: "WRONG_PASSWORD"))
				break
			case "18":
				CommonFunctions.toster(CommonFunctions.localisation(key: "CODE_ALREADY_USED"))
				break
			case "24":
				CommonFunctions.toster(CommonFunctions.localisation(key: "INCORRECT_OTP"))
				break
			case "27":
				CommonFunctions.goHome()
				CommonFunctions.toster(CommonFunctions.localisation(key: "UNKNOWN_ERROR_PARAMETER", parameter: code))
				break
			case "35":
				CommonFunctions.toster(CommonFunctions.localisation(key: "TOO_MANY_OTP_FAILURE"))
				break
			case "37", "44":
				self.loadingProfileApi()
				CommonFunctions.toster(CommonFunctions.localisation(key: "UNKNOWN_ERROR_PARAMETER", parameter: code))
				break
			case "47":
				CommonFunctions.toster(CommonFunctions.localisation(key: "FAILED_RESET_PASSWORD"))
				break
			case "51":
				CommonFunctions.toster(CommonFunctions.localisation(key: "KYC_NOT_OK"))
				let vc = IdentityVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				controller.navigationController?.pushViewController(vc, animated: false)
				break
			case "13014":
				break
			case "19002", "19003": // DEPRECATED_API_VERSION = 19002, UNDER_MAINTENANCE = 19003
				CommonFunctions.goToMaintenance()
				break
				
			default:
				CommonFunctions.toster(error)
		}
	}
	
}

enum MyError: Error {
	case description(String)
}
