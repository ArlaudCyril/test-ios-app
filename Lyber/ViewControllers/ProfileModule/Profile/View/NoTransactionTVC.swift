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
    func setUpCell(){
        self.noTransactionVw.layer.cornerRadius = 16
        CommonUI.setUpLbl(lbl: self.notransactionLbl, text: CommonFunctions.localisation(key: "NO_TRANSACTION"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
    }
}
