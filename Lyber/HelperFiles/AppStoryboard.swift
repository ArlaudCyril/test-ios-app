//
//  AppStoryboard.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Main = "Main"
    case Portfolio = "Portfolio"
    case Strategies = "Strategies"
    case InvestStrategy = "InvestStrategy"
    case SwapWithdraw = "SwapWithdraw"
    case Profile = "Profile"

    var instance: UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass : T.Type) -> T{
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController?{
        return instance.instantiateInitialViewController()
    }
}


extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self{
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
