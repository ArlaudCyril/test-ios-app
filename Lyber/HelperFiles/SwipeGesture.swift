//
//  SwipeGesture.swift
//  Lyber
//
//  Created by sonam's Mac on 01/12/22.
//

import Foundation
import UIKit

class swipeGesture : UIViewController, UIGestureRecognizerDelegate{
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeToPop()
    }
    
    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
//            return false
//        }
        return true
    }
}

class notSwipeGesture: UIViewController, UIGestureRecognizerDelegate{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeToPop()
    }
    
    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
}
class NotSwipeGesture: UITabBarController, UIGestureRecognizerDelegate{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        swipeToPop()
    }
    
    func swipeToPop() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
}
