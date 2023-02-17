//
//  UiViewExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import Foundation
import UIKit
extension UIView{
    func addShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.grey36323C.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
    }
    func threeDotButtonShadow(){
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.Grey423D33.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 1)
        
    }
}
