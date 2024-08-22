//
//  NoTransactionTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 12/09/22.
//

import UIKit

class NoTransactionTVC: UITableViewCell {

    @IBOutlet var noTransactionVw: UIView!
    @IBOutlet var notransactionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NoTransactionTVC{
	func setUpCell(loaded: Bool){
        self.notransactionLbl.text = ""
		if(!loaded){
			CommonFunctions.showLoaderTransaction(self.noTransactionVw)
		}else{
			CommonFunctions.hideLoader(self.noTransactionVw)
            self.noTransactionVw.layer.cornerRadius = 16
            CommonUI.setUpLbl(lbl: self.notransactionLbl, text: CommonFunctions.localisation(key: "NO_TRANSACTIONS"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		}
    }
}
