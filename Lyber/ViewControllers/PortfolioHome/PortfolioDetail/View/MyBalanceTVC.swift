//
//  MyBalanceTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import DropDown

class MyBalanceTVC: UITableViewCell {
    var assetId = String()
	var controller = PortfolioDetailVC()
	var balanceDropdown = DropDown()
    //MARK:- IB OUTLETS
    @IBOutlet var assetsView: UIView!
    @IBOutlet var singleAssetVw: UIView!
    @IBOutlet var coinImgView: UIImageView!
    @IBOutlet var coinTypeLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
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


//Mark:- SetUpUI
extension MyBalanceTVC{
    func setUpCell(assetId : String?){
		let balance = CommonFunctions.getBalance(id: assetId ?? "")
		let priceCoin = (Double(balance.balanceData.euroBalance ) ?? 0)/(Double(balance.balanceData.balance ) ?? 1)
        self.assetsView.layer.cornerRadius = 16
        self.singleAssetVw.layer.cornerRadius = 16
        
        CommonUI.setUpLbl(lbl: self.coinTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(Double(balance.balanceData.euroBalance) ?? 0)€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: CommonFunctions.formattedAsset(from: Double(balance.balanceData.balance), price: priceCoin, rounding: .down), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.percentageLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.percentageLbl.isHidden = true
        for coin in coinDetailData{
            if coin.id == assetId {
                self.coinTypeLbl.text = "\(coin.fullName ?? "")"
                self.coinImgView.sd_setImage(with: URL(string: coin.imageUrl ?? ""), completed: nil)
            }
        }
		
		//balance Dropdown
		balanceDropdownConfiguration()
		let exportTap = UITapGestureRecognizer(target: self, action: #selector(exportSelect))
		self.singleAssetVw.addGestureRecognizer(exportTap)
    }
}

//MARK: Other functions
extension MyBalanceTVC{
	
	@objc func exportSelect(){
		self.balanceDropdown.show()
	}
	
	func balanceDropdownConfiguration(){
		
		balanceDropdown.cellHeight = 80
		balanceDropdown.anchorView = singleAssetVw
		balanceDropdown.bottomOffset = CGPoint(x: 0, y: singleAssetVw.frame.height)
		balanceDropdown.height = 320
		balanceDropdown.topOffset = CGPoint(x: 0, y:-singleAssetVw.frame.height)
		balanceDropdown.textFont = UIFont.MabryPro(Size.Large.sizeValue())
		balanceDropdown.backgroundColor = UIColor.greyColor
		balanceDropdown.selectionBackgroundColor = UIColor.greyColor
		
		balanceDropdown.cornerRadius = 8
		balanceDropdown.cellNib = UINib(nibName: "myBalanceTableViewCell", bundle: nil)
		
		self.balanceDropdown.dataSource = Storage.balances.map{$0?.id ?? ""}
		self.balanceDropdown.dataSource.remove(self.assetId)

		//configuration printing dropdown
		balanceDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			guard let cell = cell as? myBalanceTableViewCell else { return }
			let balance = CommonFunctions.getBalance(id: item)
			let currency = CommonFunctions.getCurrency(id: item)
			let priceCoin = (Double(balance.balanceData.euroBalance ) ?? 0)/(Double(balance.balanceData.balance ) ?? 1)
			
			CommonUI.setUpLbl(lbl: cell.euroLbl, text: "\(Double(balance.balanceData.euroBalance) ?? 0)€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: cell.nbOfCoinLbl, text: CommonFunctions.formattedAsset(from: Double(balance.balanceData.balance), price: priceCoin, rounding: .down), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
			
			CommonUI.setUpLbl(lbl: cell.optionLabel, text: currency.fullName, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			cell.coinImgVw.sd_setImage(with: URL(string: currency.imageUrl ?? ""), completed: nil)
		}
		
		//when one option is selected
		balanceDropdown.selectionAction = {[weak self] (index: Int,item: String) in
			let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			vc.assetId = item
			self?.controller.navigationController?.pushViewController(vc, animated: true)
		}
		
	}
}
