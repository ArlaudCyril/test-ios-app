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
    func setUpCell(data : Transaction?){
//        coinImg.image = data?.coinImg
        CommonUI.setUpLbl(lbl: transactionTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: euroLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: dateLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: noOfCoinLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        coinImgVw.layer.cornerRadius = self.coinImgVw.layer.bounds.height/2
        
        
        if data?.type == "order"{
            self.coinImg.image = Assets.exchange.image()
			//self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "EXCH")) \(data?.fromAsset?.uppercased() ?? "") -> \(data?.toAsset?.uppercased() ?? "")"
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "EXCHANGE_NOUN"))"
			self.dateLbl.text = "\(data?.fromAsset?.uppercased() ?? "") -> \(data?.toAsset?.uppercased() ?? "")"
			self.euroLbl.text = "-\(data?.fromAmount ?? "") \(data?.fromAsset?.uppercased() ?? "")"
			self.noOfCoinLbl.text = "+\(data?.toAmount ?? "") \(data?.toAsset?.uppercased() ?? "")"
        }else if data?.type == "deposit"{
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "DEPOSIT")) \(data?.asset?.uppercased() ?? "")"
			self.euroLbl.text = "+\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
        }else if data?.type == "withdraw"{
            self.coinImg.image = Assets.withdraw.image()
            self.transactionTypeLbl.text = CommonFunctions.localisation(key: "WITHDRAWAL")
			self.euroLbl.text = "-\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
        }
    }
    
}
