//
//  ProfilePaymentTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class ProfilePaymentTVC: UITableViewCell {
    //MARK: - Variables
    var controller : ProfileVC?
    
    //MARK: - IB OUTLETS
    @IBOutlet var stackView: UIStackView!
//    @IBOutlet var cardImgView: UIView!
//    @IBOutlet var cardImg: UIImageView!
    @IBOutlet var ibanView: UIView!
    @IBOutlet var cardTypeLbl: UILabel!
    @IBOutlet var cardNumberLbl: UILabel!
    
    @IBOutlet var bicView: UIView!
    @IBOutlet var bicLbl: UILabel!
    @IBOutlet var bicNumberLbl: UILabel!
    @IBOutlet var addPaymentVw: UIView!
    @IBOutlet var addPaymentBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfilePaymentTVC{
    func setUpCell(data : buyDepositeModel?,row : Int,lastIndex : Int){
//        cardImgView.layer.cornerRadius = self.cardImgView.layer.bounds.height/2
//        cardImg.image = data?.icon
        CommonUI.setUpLbl(lbl: cardTypeLbl, text: L10n.IBANumber.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: cardNumberLbl, text: userData.shared.iban, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: bicLbl, text: L10n.BICNumber.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: bicNumberLbl, text: userData.shared.bic, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: addPaymentBtn, text: L10n.AddPaymentMethod.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        addPaymentBtn.setAttributedTitle(CommonFunction.underlineString(str: L10n.AddPaymentMethod.description), for: .normal)
        addPaymentBtn.addTarget(self, action: #selector(addPaymentBtnAction), for: .touchUpInside)
        
        stackView.layer.cornerRadius = 16
        if userData.shared.iban == "" && userData.shared.bic == ""{
            self.ibanView.isHidden = true
            self.bicView.isHidden = true
            addPaymentVw.isHidden = false
        }else{
            self.ibanView.isHidden = false
            self.bicView.isHidden = false
            addPaymentVw.isHidden = true
        }
    }
}

//MARK: - objective functions
extension ProfilePaymentTVC{
    @objc func addPaymentBtnAction(){
        let vc = AddPaymentMethodVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
