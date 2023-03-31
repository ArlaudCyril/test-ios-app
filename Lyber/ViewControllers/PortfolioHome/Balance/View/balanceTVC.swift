//
//  balanceTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 17/06/22.
//

import UIKit

class balanceTVC: UITableViewCell {
//MARK: - IB OUTLETS
    
    @IBOutlet var balanceView: UIView!
    @IBOutlet var boughtLbl: UILabel!
    @IBOutlet var creditCardLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension balanceTVC{
    func setUpCell(data : Transaction?){
        self.balanceView.layer.cornerRadius = 16
        CommonUI.setUpLbl(lbl: self.boughtLbl, text: CommonFunctions.localisation(key: "BOUGHT"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.creditCardLbl, text: "Credit card (***00103)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "20€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "0.0002 BTC", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        if data?.type == 1{    //exchange
            self.boughtLbl.text = "\(CommonFunctions.localisation(key: "EXCH")) \(data?.exchangeFrom ?? "")->\(data?.exchangeTo ?? "")"
            self.euroLbl.text = "\(data?.exchangeFromAmount ?? 0.0) \(data?.exchangeFrom ?? "")"
            self.noOfCoinLbl.text = "\(data?.exchangeToAmount ?? 0.0) \(data?.exchangeTo ?? "")"
        }else if data?.type == 2{           //deposite
            self.boughtLbl.text = CommonFunctions.localisation(key: "DEPOSIT")
        }else if data?.type == 3{               //withdraw
            self.boughtLbl.text = CommonFunctions.localisation(key: "WITHDRAWAL")
            self.euroLbl.text = "-\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunctions.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }else if data?.type == 4{                   //bought
            self.boughtLbl.text = CommonFunctions.localisation(key: "BOUGHT")
            self.euroLbl.text = "+\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunctions.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }
    }
}
