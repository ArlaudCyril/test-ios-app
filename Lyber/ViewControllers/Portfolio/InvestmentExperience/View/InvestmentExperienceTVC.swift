//
//  InvestmentExperienceTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class InvestmentExperienceTVC: UITableViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var experienceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Mark: - SetUpUI
extension InvestmentExperienceTVC{
    func setUpCell(data : String){
        CommonUI.setUpLbl(lbl: self.experienceLbl, text: data, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
    }
}
