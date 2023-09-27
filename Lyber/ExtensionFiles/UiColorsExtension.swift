//
//  UiColorsExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit

extension UIColor{
	public class var greyColor : UIColor{
        get {
            return UIColor(named: "greyColor") ?? UIColor.gray
        }
    }
	public class var LightPurple : UIColor{
        get {
            return UIColor(named: "LightPurple") ?? UIColor.purple
        }
    }
	public class var primaryTextcolor : UIColor{
        get {
            return UIColor(named: "primaryTextcolor") ?? UIColor.black
        }
    }
	public class var PurpleColor : UIColor{
        get {
            return UIColor(named: "PurpleColor") ?? UIColor.purple
        }
    }
	public class var Purple35126D : UIColor{
        get {
            return UIColor(named: "Purple#35126D") ?? UIColor.purple
        }
    }
	public class var dark_transparent : UIColor{
        get {
            return UIColor(named: "dark_transparent") ?? UIColor.purple
        }
    }
	public class var PurpleGrey_500 : UIColor{
		get {
			return UIColor(named: "PurpleGrey_500") ?? UIColor.purple
		}
	}
	public class var PurpleGrey_100 : UIColor{
		get {
			return UIColor(named: "PurpleGrey_100") ?? UIColor.purple
		}
	}
	public class var PurpleGrey_50 : UIColor{
		get {
			return UIColor(named: "purpleGrey_50") ?? UIColor.purple
		}
	}
	public class var SecondarytextColor : UIColor{
        get {
            return UIColor(named: "SecondarytextColor") ?? UIColor.black
        }
    }
	public class var ThirdTextColor : UIColor{
        get {
            return UIColor(named: "ThirdTextColor") ?? UIColor.black
        }
    }
	public class var whiteColor : UIColor{
        get {
            return UIColor(named: "whiteColor") ?? UIColor.white
        }
    }
	public class var grey877E95 : UIColor{
        get {
            return UIColor(named: "grey#877E95") ?? UIColor.gray
        }
    }
	public class var grey36323C : UIColor{
        get {
            return UIColor(named: "grey#36323C") ?? UIColor.gray
        }
    }
	public class var greyDisabled : UIColor{
        get {
            return UIColor(named: "PurpleGrey_100") ?? UIColor.gray
        }
    }
	public class var Green_500 : UIColor{
        get {
            return UIColor(named: "Green_500") ?? UIColor.green
        }
    }
	public class var borderColor : UIColor{
        get {
            return UIColor(named: "borderColor") ?? UIColor.gray
        }
    }
	public class var TFplaceholderColor : UIColor{
        get {
            return UIColor(named: "TFplaceholderColor") ?? UIColor.gray
        }
    }
	public class var Grey7B8094 : UIColor{
        get {
            return UIColor(named: "Grey#7B8094") ?? UIColor.gray
        }
    }
	public class var Orange_500 : UIColor{
		get {
			return UIColor(named: "Orange_500") ?? UIColor.gray
		}
	}
	public class var RedDF5A43 : UIColor{
        get {
            return UIColor(named: "Red#DF5A43") ?? UIColor.gray
        }
    }
	public class var Red_500 : UIColor{
        get {
            return UIColor(named: "Red_500") ?? UIColor.gray
        }
    }
	public class var Grey423D33 : UIColor{
        get {
            return UIColor(named: "Grey#423D33") ?? UIColor.gray
        }
    }
	public class var GreenColor : UIColor{
        get {
            return UIColor(named: "GreenColor") ?? UIColor.green
        }
    }
	public class var PurpleAC82F2 : UIColor{
        get {
            return UIColor(named: "Purple#AC82F2") ?? UIColor.green
        }
    }
	public class var purple_00 : UIColor{
        get {
			return UIColor(named: "purple_00") ?? UIColor.purple
        }
    }
	public class var purple_100 : UIColor{
        get {
			return UIColor(named: "purple_100") ?? UIColor.purple
        }
    }
	public class var purple_200 : UIColor{
        get {
			return UIColor(named: "purple_200") ?? UIColor.purple
        }
    }
	public class var purple_300 : UIColor{
        get {
			return UIColor(named: "purple_300") ?? UIColor.purple
        }
    }
	public class var purple_400 : UIColor{
        get {
			return UIColor(named: "purple_400") ?? UIColor.purple
        }
    }
	public class var purple_500 : UIColor{
		get {
			return UIColor(named: "purple_500") ?? UIColor.purple
		}
	}
	public class var purple_600 : UIColor{
		get {
			return UIColor(named: "purple_600") ?? UIColor.purple
		}
	}
	public class var purple_700 : UIColor{
		get {
			return UIColor(named: "purple_700") ?? UIColor.purple
		}
	}
	public class var purple_800 : UIColor{
		get {
			return UIColor(named: "purple_800") ?? UIColor.purple
		}
	}
	public class var ColorFFF2D9 : UIColor{
        get {
            return UIColor(named: "Color#FFF2D9") ?? UIColor.green
        }
    }
	public class var blue_500 : UIColor{
        get {
            return UIColor(named: "blue_500") ?? UIColor.green
        }
    }
    
    private func makeColor(componentDelta: CGFloat) -> UIColor {
            var red: CGFloat = 0
            var blue: CGFloat = 0
            var green: CGFloat = 0
            var alpha: CGFloat = 0
            
            // Extract r,g,b,a components from the
            // current UIColor
            getRed(
                &red,
                green: &green,
                blue: &blue,
                alpha: &alpha
            )
            
            // Create a new UIColor modifying each component
            // by componentDelta, making the new UIColor either
            // lighter or darker.
            return UIColor(
                red: add(componentDelta, toComponent: red),
                green: add(componentDelta, toComponent: green),
                blue: add(componentDelta, toComponent: blue),
                alpha: alpha
            )
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    
    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
