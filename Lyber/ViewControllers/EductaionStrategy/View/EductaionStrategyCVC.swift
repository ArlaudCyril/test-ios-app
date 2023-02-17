//
//  EductaionStrategyCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import UIKit
import Lottie

class EductaionStrategyCVC: UICollectionViewCell {
    //MARK: - Variables
    let animationView = AnimationView()
    //MARK:- IB OUTLETS
//    @IBOutlet var ImgVw: UIImageView!
    @IBOutlet var animationVw: AnimationView!
    @IBOutlet var descLbl: UILabel!
    @IBOutlet var subDescLbl: UILabel!
    
}

extension EductaionStrategyCVC{
    func setUpUI(){
        
        
        
    }
    
    func configureWithData(data : educationModel,index : Int){
        if index == 2{
            
        }
//        animationVw.backgroundBehavior = .pauseAndRestore
//        animationVw = AnimationView(name: "Boat_Loader")
//        animationVw.loopMode = .loop
//        animationVw.animationSpeed = 0.01
//        self.animationVw.play()
        
        
        
        animationView.animation = Animation.named("portfolio")
        animationView.frame.size = animationVw.frame.size
        animationView.contentMode = .scaleToFill
        animationVw.loopMode = .autoReverse
        
        animationVw.addSubview(animationView)
        animationView.backgroundBehavior = .pauseAndRestore
        
        playAnimation()
        CommonUI.setUpLbl(lbl: descLbl, text: data.desc, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: subDescLbl, text: data.subDesc, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.subDescLbl, text: data.subDesc, lineSpacing: 6, textAlignment: .left)
    }
    
    func playAnimation() {
        self.animationView.play(completion: { played in
            if played == false {
                print("Navigate here")
            }else {
                self.playAnimation()
            }
        })
    }
}
