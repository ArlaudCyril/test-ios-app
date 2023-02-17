//
//  SearchAssetTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 25/08/22.
//

import UIKit

class SearchAssetTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var assetImgVw: UIImageView!
    @IBOutlet var assetNameLbl: UILabel!
    @IBOutlet var assetSymbolLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - SetUpUI
extension SearchAssetTVC{
    func setUpCell(data : GetAssetsAPIElement?){
        self.assetImgVw.yy_setImage(with: URL(string: data?.image ?? ""), options: .progressiveBlur)
        CommonUI.setUpLbl(lbl: self.assetNameLbl, text: data?.assetName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.assetSymbolLbl, text: data?.symbol?.uppercased() ?? "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
    }
}
