//
//  CryptoAddressesTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

class CryptoAddressesTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var addressNameLbl: UILabel!
    @IBOutlet var addresslbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


extension CryptoAddressesTVC{
    func configureWithData(data : Address?){
		self.coinImgView.sd_setImage(with: URL(string: CommonFunctions.getImage(id: data?.network?.decoderNetwork ?? "")))
        CommonUI.setUpLbl(lbl: self.addressNameLbl, text: data?.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addresslbl, text: data?.address , textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
    }
}
