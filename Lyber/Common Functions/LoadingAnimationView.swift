//
//  LoadingAnimationView.swift
//  Lyber
//
//  Created by Elie Boyrivent on 19/12/2023.
//

import UIKit

class LoadingAnimationView: UIView {

    let svgLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let svgImage = UIImage(named: "logo_white") {
            svgLayer.contents = svgImage.cgImage
        }
        
        svgLayer.frame = bounds
        layer.addSublayer(svgLayer)
        
        startRotationAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = Double.pi * 2.0 // Une rotation complète
        rotationAnimation.duration = 2.0 // La durée de l'animation en secondes
        rotationAnimation.repeatCount = .infinity // Répéter indéfiniment
        svgLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

