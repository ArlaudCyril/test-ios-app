//
//  WithdrawRibTVC.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 15/03/2024.
//

import Foundation
import UIKit

class WithdrawRibTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var statusRibImgView: UIImageView!
    @IBOutlet var nameRibLbl: UILabel!
    
    @IBOutlet var ownerNameRibLbl: UILabel!
    @IBOutlet var ibanRibLbl: UILabel!
    
}

//Mark:- SetUpUI
extension WithdrawRibTVC{
    func configureWithData(data : RibData?){
        CommonUI.setUpLbl(lbl: self.nameRibLbl, text: data?.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.ownerNameRibLbl, text: data?.userName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.ibanRibLbl, text: data?.iban.addressFormat, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        if(data?.ribStatus == "PENDING"){
            self.statusRibImgView.image = Assets.pending_indicator.image()
        }else{
            self.statusRibImgView.image = Assets.accepted_indicator.image()
        }
    }
}

