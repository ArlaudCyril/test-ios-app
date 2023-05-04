//
//  AddStrategyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import UIKit
import Charts
import YYWebImage
import SDWebImage
import SVGKit
import CoreMedia


class AddAssetsTVC: UITableViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var coinFullNameLbl: UILabel!
    @IBOutlet var coinNamelbl: UILabel!
    @IBOutlet var assetImage : UIImageView!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//Mark:- SetUpUI
extension AddAssetsTVC{
    func configureWithData(data : PriceServiceResume?){
        
        CommonUI.setUpLbl(lbl: self.coinFullNameLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.coinNamelbl, text: data?.id.uppercased() ?? "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunctions.formattedCurrency(from: Double(data?.priceServiceResumeData.lastPrice ?? "")))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.percentageLbl, text: "\(CommonFunctions.formattedCurrency(from: Double(data?.priceServiceResumeData.change ?? "")))%", textColor: (Double(data?.priceServiceResumeData.change ?? "") ?? 0)<0 ? UIColor.RedDF5A43 : UIColor.GreenColor, font: UIFont.MabryPro(Size.Small.sizeValue()))
        for coin in coinDetailData{
            if data?.id == coin.id{
                self.coinImg.sd_setImage(with: URL(string: coin.image ?? ""))
                self.coinFullNameLbl.text = coin.fullName ?? ""
            }
		}
		/*if let data = try? Data(contentsOf: URL(fileURLWithPath:data?.squiggleURL ?? "")) {
			if let image = UIImage(data: data) {
				DispatchQueue.main.async {
					self.assetImage.image = image
				}
			}
		}*/
		//self.assetImage.image = UIImage(data: Data(contentsOf:URL(string:data?.squiggleURL ?? "") ?? URL(fileURLWithPath:data?.squiggleURL ?? "")))
		let options: SDWebImageOptions = [.refreshCached]
		self.assetImage.sd_setImage(with: URL(string:data?.priceServiceResumeData.squiggleURL ?? ""), placeholderImage: nil, options: options)
	
        
    }
}
