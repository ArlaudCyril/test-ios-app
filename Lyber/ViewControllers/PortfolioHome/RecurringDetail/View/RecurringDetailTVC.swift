//
//  RecurringDetailTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/09/22.
//

import UIKit

class RecurringDetailTVC: UITableViewCell {

    @IBOutlet var boughtLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var coinLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecurringDetailTVC{
    func configureWithData(data : History?){
        CommonUI.setUpLbl(lbl: self.boughtLbl, text: L10n.Bought.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunctions.formattedCurrency(from: data?.amount ?? 0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.coinLbl, text: "\(CommonFunctions.formattedCurrency(from: data?.assetAmount ?? 0)) \(data?.assetID ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
       
    }
}
