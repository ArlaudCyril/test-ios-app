//
//  ProfileLogoutTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class ProfileLogoutTVC: UITableViewCell {
    var controller : ProfileVC?
    //MARK:- IB OUTLETS
    @IBOutlet var logOutBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileLogoutTVC{
    func setUpCell(){
        CommonUI.setUpButton(btn: logOutBtn, text: CommonFunctions.localisation(key: "LOG_OUT"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        logOutBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "LOG_OUT")), for: .normal)
        logOutBtn.addTarget(self, action: #selector(logOutAct), for: .touchUpInside)
        
    }
    
    @objc func logOutAct(){
        let alert = UIAlertController(title: Constants.AlertMessages.logOut, message: Constants.AlertMessages.sureLogOut, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.logOut, style: .destructive, handler: { (action: UIAlertAction!) in
            CommonFunctions.logout()
//            userData.shared.deleteData()
//            self.controller?.navigationController?.popToViewController(ofClass: LoginVC.self)
            
          }))
        alert.addAction(UIAlertAction(title: Constants.AlertMessages.Cancel, style: .cancel, handler: nil))
        self.controller?.present(alert, animated: true, completion: nil)
    }
}
