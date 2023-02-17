//
//  enableNotificationCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import UIKit

class enableNotificationCVC: UICollectionViewCell {
    //MARK: - Variables
    var enterPhoneVM = EnterPhoneVM()
    var delegate : EnterPhoneVC?
    var enableNotificationCallBack : (()->())?
    //MARK:- IB OUTLETS
    @IBOutlet var enableNotifiLbl: UILabel!
    @IBOutlet var enableNotifyDescLbl: UILabel!
    @IBOutlet var activateBtn: PurpleButton!
    @IBOutlet var askMeLater: UIButton!
    @IBOutlet var srollVw: UIScrollView!
}

extension enableNotificationCVC{
    func setUpUI(){
        CommonUI.setUpLbl(lbl: enableNotifiLbl, text: L10n.EnableNotifications.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: enableNotifyDescLbl, text: L10n.dontMissAnyUpdate.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: enableNotifyDescLbl, text: L10n.dontMissAnyUpdate.description, lineSpacing: 6, textAlignment: .left)
        
        self.activateBtn.setTitle(L10n.Activate.description, for: .normal)
        CommonUI.setUpButton(btn: self.askMeLater, text: L10n.AskMeLater.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.activateBtn.addTarget(self, action: #selector(activateBtnAct), for: .touchUpInside)
        self.askMeLater.addTarget(self, action: #selector(askMeLaterAct), for: .touchUpInside)
    }
    
    func configureWithData(){
        
    }
}


extension enableNotificationCVC{
    @objc func activateBtnAct(){
        self.enableNotification(enable: 1)
    }
    
    @objc func askMeLaterAct(){
        self.enableNotification(enable: 2)
    }
    
    func enableNotification(enable : Int){
//        if enable == 1{
//            self.activateBtn.showLoading()
//            self.activateBtn.isUserInteractionEnabled = false
//        }
//        self.delegate?.enterPhoneVM.enableNotificationApi(enable: enable, completion: {[weak self]response in
//            self?.activateBtn.hideLoading()
//            self?.activateBtn.isUserInteractionEnabled = true
//            if let response = response{
//                print(response)
                userData.shared.is_push_enabled = enable
                userData.shared.isAccountCreated = true
                userData.shared.dataSave()
                let vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                self.delegate?.navigationController?.pushViewController(vc, animated: true)
//            }
//        })
    }
}
