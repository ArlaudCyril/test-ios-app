//
//  ProfileTransactionTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class ProfileTransactionTVC: UITableViewCell {
    //MARK: - Variables
    var controller : ProfileVC?
    //MARK: - IB OUTLETS
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var transactionTypeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    
    @IBOutlet var viewAllVw: UIView!
    @IBOutlet var viewAllBtn: UIButton!
    
    @IBOutlet var noTransactionVw: UIView!
    @IBOutlet var noTransactionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileTransactionTVC{
    func setUpCell(data : Transaction?,row : Int,lastIndex : Int){
        CommonUI.setUpLbl(lbl: transactionTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: euroLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: dateLbl, text: CommonFunctions.getDateFromUnixInterval(timeResult: Double(data?.createdAt ?? "") ?? 0, requiredFormat: "dd/MM/yyyy"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: noOfCoinLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        if data?.type == 1{  //exchange
            self.coinImg.image = Assets.exchange.image()
            self.transactionTypeLbl.text = "\(L10n.Exch.description) \(data?.exchangeFrom ?? "")->\(data?.exchangeTo ?? "")"
            self.euroLbl.text = "\(data?.exchangeFromAmount ?? 0.0) \(data?.exchangeFrom ?? "")"
            self.noOfCoinLbl.text = "\(data?.exchangeToAmount ?? 0.0) \(data?.exchangeTo ?? "")"
        }else if data?.type == 2{      //deposite
            self.transactionTypeLbl.text = "\(L10n.Deposit.description) \(data?.assetID ?? "")"
        }else if data?.type == 3{       //withdraw
            self.coinImg.image = Assets.withdraw.image()
            self.transactionTypeLbl.text = L10n.Withdrawal.description
            self.euroLbl.text = "-\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunctions.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }else if data?.type == 4{     //bought
            self.coinImg.image = Assets.money_deposit.image()
            self.transactionTypeLbl.text = "\(L10n.Bought.description) \(data?.assetID ?? "")"
            self.euroLbl.text = "+\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunctions.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }
        
        
        CommonUI.setUpButton(btn: viewAllBtn, text: L10n.ViewAll.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        viewAllBtn.setAttributedTitle(CommonFunctions.underlineString(str: L10n.ViewAll.description), for: .normal)
        viewAllBtn.addTarget(self, action: #selector(viewAllBtnAction), for: .touchUpInside)
        
        if row == 0{
            viewAllVw.isHidden = true
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if row == lastIndex{
            viewAllVw.isHidden = false
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
            viewAllVw.isHidden = true
        }
        
        if row == lastIndex{
            viewAllVw.isHidden = false
        }
        self.noTransactionVw.isHidden = true
    }
}

//MARK: - objective functions
extension ProfileTransactionTVC{
    @objc func viewAllBtnAction(){
        let vc = TransactionVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
