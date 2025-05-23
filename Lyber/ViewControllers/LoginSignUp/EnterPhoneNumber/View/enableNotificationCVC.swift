//
//  enableNotificationCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class enableNotificationCVC: UICollectionViewCell {
    //MARK: - Variables
    var enterPhoneVM = EnterPhoneVM()
    var delegate : ViewController?
    //MARK:- IB OUTLETS
    @IBOutlet var enableNotifiLbl: UILabel!
    @IBOutlet var enableNotifyDescLbl: UILabel!
    @IBOutlet var activateBtn: PurpleButton!
    @IBOutlet var askMeLater: UIButton!
}

extension enableNotificationCVC{
    func setUpUI(){
        CommonUI.setUpLbl(lbl: enableNotifiLbl, text: CommonFunctions.localisation(key: "ENABLE_NOTIFICATIONS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: enableNotifyDescLbl, text: CommonFunctions.localisation(key: "DONT_MISS_ANY_UPDATE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: enableNotifyDescLbl, text: CommonFunctions.localisation(key: "DONT_MISS_ANY_UPDATE"), lineSpacing: 6, textAlignment: .left)
        
        self.activateBtn.setTitle(CommonFunctions.localisation(key: "ACTIVATE"), for: .normal)
        CommonUI.setUpButton(btn: self.askMeLater, text: CommonFunctions.localisation(key: "ASK_ME_LATER"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.activateBtn.addTarget(self, action: #selector(activateBtnAct), for: .touchUpInside)
        self.askMeLater.addTarget(self, action: #selector(askMeLaterAct), for: .touchUpInside)
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
		//just for simulator, normaly defined in app delegate
        CommonFunctions.enableNotifications(enable: enable)
        
        var vc : ViewController
        if(GlobalVariables.isRegistering == true)
        {
			userData.shared.stepRegisteringComplete = 1
            vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		}else{
			vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			CommonFunctions.loadingProfileApi()
		}
		userData.shared.is_push_enabled = enable
		userData.shared.dataSave()
        self.delegate?.navigationController?.pushViewController(vc, animated: false)
        
    }
}
