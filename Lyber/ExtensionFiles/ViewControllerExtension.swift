//
//  ViewControllerExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
	  
	  if let vc = viewControllers.first(where: { $0.isKind(of: ofClass) }) {
		  popToViewController(vc, animated: animated)
	  }
  }
	
	func popToPortfolioHomeOrPortfolioDetail(animated: Bool = false) {
		  
		if let vc = viewControllers.last(where: { $0.isKind(of: PortfolioHomeVC.self) || $0.isKind(of: PortfolioDetailVC.self) }) {
			  popToViewController(vc, animated: animated)
		  }
	  }
	
	func deleteToPortfolioHomeOrPortfolioDetail(animated: Bool = false) {
		for i in (1...viewControllers.count-2).reversed() {
			print(type(of: viewControllers[i]))
			if(viewControllers[i].isKind(of: PortfolioHomeVC.self) || viewControllers[i].isKind(of: PortfolioDetailVC.self)){
				return
			}else{
				viewControllers.remove(at: i)
			}
		}
	  }
	
	func popToPortfolioHomeOrAllAsset(animated: Bool = false) {
		  
		if let vc = viewControllers.last(where: { $0.isKind(of: PortfolioHomeVC.self) || ($0 as? AllAssetsVC)?.screenType == .portfolio }) {
			// Pop to the found view controller
			popToViewController(vc, animated: animated)
		}
	  }
	
	func deleteToPortfolioHomeOrAllAsset(animated: Bool = false) {
		for i in (1...viewControllers.count-2).reversed() {
			print(type(of: viewControllers[i]))
			if(viewControllers[i].isKind(of: PortfolioHomeVC.self) || (viewControllers[i] as? AllAssetsVC)?.screenType == .portfolio){
				return
			}else{
				viewControllers.remove(at: i)
			}
		}
	  }
	
	
	func deleteToViewController(ofClass: AnyClass) {
		if(ofClass == AllAssetsVC.self){
			for i in (1...viewControllers.count-2).reversed() {
				if(viewControllers[i].isKind(of: AllAssetsVC.self)){
					let allAssetController = viewControllers[i] as! AllAssetsVC
					if(allAssetController.screenType == .portfolio){
						return
					}
				}
				viewControllers.remove(at: i)
			}
		}else{
			for i in (1...viewControllers.count-2).reversed() {
				print(type(of: viewControllers[i]))
				if(viewControllers[i].isKind(of: ofClass)){
					return
				}else{
					viewControllers.remove(at: i)
				}
			}
		}
	}
}
