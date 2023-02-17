//
//  UIFontsExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit


internal enum Size : CGFloat{
    case VSmall = 10.0
    case Small = 12.0
    case Medium = 14.0
    case Large = 16.0
    case XLarge = 18.0
    case XXlarge = 22.0
    case XXXLarge = 24.0
    case Header = 20.0
    case XVLarge = 32.0
    case extraLarge = 36.0
    case sixty = 60.0

    func sizeValue() -> CGFloat{
        return self.rawValue
    }
}


extension UIFont {

    class func AtypDisplayBold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypDisplay-Bold", size: size) ?? UIFont()
    }
    class func AtypDisplayMedium(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypDisplay-Medium", size: size) ?? UIFont()
    }
    class func AtypDisplayRegular(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypDisplay-Regular", size: size) ?? UIFont()
    }
    class func AtypDisplaySemibold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypDisplay-Semibold", size: size) ?? UIFont()
    }
    class func MabryProBold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "Mabry Pro Bold", size: size) ?? UIFont()
    }
    class func MabryProMedium(_ size:CGFloat) -> UIFont {
        return UIFont(name: "Mabry Pro Medium", size: size) ?? UIFont()
    }
    class func MabryProLight(_ size:CGFloat) -> UIFont {
        return UIFont(name: "Mabry Pro Light", size: size) ?? UIFont()
    }
    class func AtypTextBold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypText-Bold", size: size) ?? UIFont()
    }
    class func AtypTextMedium(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypText-Medium", size: size) ?? UIFont()
    }
    class func AtypTextRegular(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypText-Regular", size: size) ?? UIFont()
    }
    class func AtypTextSemibold(_ size:CGFloat) -> UIFont {
        return UIFont(name: "AtypText-Semibold", size: size) ?? UIFont()
    }
    class func MabryPro(_ size:CGFloat) -> UIFont {
        return UIFont(name: "Mabry Pro", size: size) ?? UIFont()
    }
//    class func MontSemiBold(_ size:CGFloat) -> UIFont {
//        return UIFont(name: "Mont-SemiBold", size: size)!
//    }
//    class func MontSemiBoldItalic(_ size:CGFloat) -> UIFont {
//        return UIFont(name: "Mont-SemiBoldItalic", size: size)!
//    }
//    class func MontThin(_ size:CGFloat) -> UIFont {
//        return UIFont(name: "Mont-Thin", size: size)!
//    }
//    class func MontThinItalic(_ size:CGFloat) -> UIFont {
//        return UIFont(name: "Mont-ThinItalic", size: size)!
//    }
}
