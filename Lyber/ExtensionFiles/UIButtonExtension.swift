//
//  UIButtonExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit


extension UIButton{
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal) ?? UIColor.white, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal) ?? UIColor.white, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func applyGradient(colors: [CGColor], isHorizontal: Bool) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        var gradientLayer = CAGradientLayer()
        if let sublayers = layer.sublayers {
              for sublayer in sublayers {
                if let gLayer = sublayer as? CAGradientLayer {
                    gradientLayer = gLayer
                  break
                }
              }
            }
        gradientLayer.colors = colors
        
        if (isHorizontal) {
            gradientLayer.startPoint = CGPoint(x: 0.15, y: 0.4)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.2)
            gradientLayer.endPoint = CGPoint (x: 0.6, y: 1)
        }
        
//        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = bounds
        self.clipsToBounds = true
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientLayer(){
        self.layoutIfNeeded()
        if let sublayers = layer.sublayers {
              for sublayer in sublayers {
                if let gLayer = sublayer as? CAGradientLayer {
                    gLayer.removeFromSuperlayer()
                  break
                }
              }
            }
    }
}

class LoadingButton: UIButton {
    var originalButtonText: String?
    var originalButtonImage: UIImage?
    var activityIndicator: UIActivityIndicatorView!
    
    func showLoading(color: UIColor = .white) {
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.currentImage
        self.setTitle("", for: .normal)
        self.setImage(nil, for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator(color: color )
        }
        showSpinning()
    }
    
    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        self.setImage(originalButtonImage, for: .normal)
        if activityIndicator != nil{
            activityIndicator.stopAnimating()
        }
    }
    
    private func createActivityIndicator(color: UIColor = .white) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = color
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    
}


class PurpleButton: LoadingButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 12
        self.titleLabel?.font = UIFont.MabryProMedium(Size.XLarge.sizeValue())
        self.setTitleColor(UIColor.whiteColor, for: .normal)
        self.backgroundColor = UIColor.PurpleColor
    }
    
   
}
