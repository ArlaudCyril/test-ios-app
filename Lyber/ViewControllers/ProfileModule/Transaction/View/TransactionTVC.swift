//
//  TransactionTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class TransactionTVC: UITableViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var coinImgVw: UIView!
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var transactionTypeVw: UIView!
    @IBOutlet var transactionTypeLbl: UILabel!
    @IBOutlet var dateVw: UIView!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var euroVw: UIView!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinVw: UIView!
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
extension TransactionTVC{
    func setUpCell(data : Transaction?,section : Int,row : Int){
//        coinImg.image = data?.coinImg
        CommonUI.setUpLbl(lbl: transactionTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: euroLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: dateLbl, text: "15/04/2022", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: noOfCoinLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        coinImgVw.layer.cornerRadius = self.coinImgVw.layer.bounds.height/2
        
        
        if data?.type == 1{    //exchange
            self.coinImg.image = Assets.exchange.image()
            self.transactionTypeLbl.text = "\(L10n.Exch.description) \(data?.exchangeFrom ?? "")->\(data?.exchangeTo ?? "")"
            self.euroLbl.text = "\(data?.exchangeFromAmount ?? 0.0) \(data?.exchangeFrom ?? "")"
            self.noOfCoinLbl.text = "\(data?.exchangeToAmount ?? 0.0) \(data?.exchangeTo ?? "")"
        }else if data?.type == 2{           //deposite
            self.transactionTypeLbl.text = "\(L10n.Deposit.description) \(data?.assetID ?? "")"
        }else if data?.type == 3{               //withdraw
            self.coinImg.image = Assets.withdraw.image()
            self.transactionTypeLbl.text = L10n.Withdrawal.description
            self.euroLbl.text = "-\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunction.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }else if data?.type == 4{                   //bought
            self.coinImg.image = Assets.money_deposit.image()
            self.transactionTypeLbl.text = "\(L10n.Bought.description) \(data?.assetID ?? "")"
            self.euroLbl.text = "+\(data?.amount ?? 0.0)€"
            self.noOfCoinLbl.text = "\(CommonFunction.getTwoDecimalValue(number: (data?.assetAmoount ?? 0)))\(data?.assetID ?? "")"
        }
        
        
        if section == 2{
            if row == 0{
                noOfCoinVw.isHidden = true
            }else{
                noOfCoinVw.isHidden = false
            }
        }else{
            self.dateVw.isHidden = true
        }
    }
    
}
