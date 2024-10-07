//
//  WithdrawSendTVC.swift
//  Lyber
//
//  Created by Elie Boyrivent on 27/09/2024.
//

import UIKit

class WithdrawSendTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var withdrawSendImg: UIImageView!
    @IBOutlet var withdrawSendNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}

//Mark:- SetUpUI
extension WithdrawSendTVC{
    func configureWithData(data : String?){
        let (name, image) = getSendMean(data: data)
        CommonUI.setUpLbl(lbl: self.withdrawSendNameLbl, text: name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.withdrawSendImg.image = image
    }
    
    func getSendMean(data: String?) -> (String, UIImage){
        if(data == "phone"){
            return (CommonFunctions.localisation(key: "WITHDRAW_CONTROLLER_SEND_PHONE"), Assets.send_phone.image())
            
        }else if(data == "QRCode"){
            return (CommonFunctions.localisation(key: "WITHDRAW_CONTROLLER_SEND_QRCODE"), Assets.send_QRCode.image())
        }else{
            return (CommonFunctions.localisation(key: "WITHDRAW_CONTROLLER_SEND_NFC"), Assets.send_NFC.image())
        }
    }
}


