//
//  EnableWhitelistingTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

class EnableWhitelistingTVC: UITableViewCell {
    //MARK: - IB OUTLETS
    @IBOutlet var TimeView: UIView!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var radioBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EnableWhitelistingTVC{
    func configureWithData(data : SecurityTime){
        CommonUI.setUpLbl(lbl: self.timeLbl, text: data.time, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.TimeView.layer.cornerRadius = 16
        CommonUI.setUpViewBorder(vw: self.TimeView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
    }
}
