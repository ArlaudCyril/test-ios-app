//
//  InvestMethodBottomVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit

class InvestMethodBottomVC: ViewController {
    //MARK: - Variables
    
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomStackVw: UIStackView!
    @IBOutlet var completeYourAccountVw: UIView!
    @IBOutlet var completeYourAccountLbl: UILabel!
    @IBOutlet var startInvestingLbl: UILabel!
    @IBOutlet var rightArrowBtn: UIButton!
    
    @IBOutlet var withdrawExchangeView: UIView!
    @IBOutlet var withDrawView: UIView!
    @IBOutlet var withdrawLbl: UILabel!
    @IBOutlet var assetToBankAccountLbl: UILabel!
    
    @IBOutlet var exchangeView: UIView!
    @IBOutlet var exchangeLbl: UILabel!
    @IBOutlet var tradeOneAssetsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        let tap = UITapGestureRecognizer(target: self, action:#selector(closeBottomSheet))
        self.outerView.addGestureRecognizer(tap)
        
        self.bottomStackVw.layer.cornerRadius = 32
        self.bottomStackVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        self.bottomStackVw.addGestureRecognizer(pan)
        self.completeYourAccountVw.layer.cornerRadius = 32
        
        CommonUI.setUpLbl(lbl: completeYourAccountLbl, text: CommonFunctions.localisation(key: "COMPLETE_YOUR_ACCOUNT"), textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: startInvestingLbl, text: CommonFunctions.localisation(key: "TO_START_INVESTING"), textColor: UIColor.whiteColor, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.withdrawExchangeView.isHidden = true
        self.withDrawView.layer.cornerRadius = 32
        self.withDrawView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        self.withDrawView.alpha = 0.6
        CommonUI.setUpLbl(lbl: withdrawLbl, text: CommonFunctions.localisation(key: "WITHDRAW"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: assetToBankAccountLbl, text: CommonFunctions.localisation(key: "YOUR_ASSETS_YOUR_BANK_ACCOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpLbl(lbl: exchangeLbl, text: CommonFunctions.localisation(key: "EXCHANGE"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: tradeOneAssetsLbl, text: CommonFunctions.localisation(key: "TRADE_ONE_ASSET_AGAINST_ANOTHER"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.rightArrowBtn.addTarget(self, action: #selector(rightBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension InvestMethodBottomVC{
    @objc func rightBtnAct(){
        self.withdrawExchangeView.isHidden = false
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.bottomStackVw)
        guard  translation.y >= 0 else { return }
        if sender.state == .changed{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                            self.bottomStackVw.transform = CGAffineTransform(translationX: 0, y: translation.y)
                        })
        }
        if sender.state == .ended{
            if translation.y < 120 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.bottomStackVw.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
    }
    
    @objc func closeBottomSheet(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}
