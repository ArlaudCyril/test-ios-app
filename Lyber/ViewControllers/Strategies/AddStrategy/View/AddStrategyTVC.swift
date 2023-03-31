//
//  AddStrategyTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit
import Charts
import YYWebImage
import SVGKit

class AddStrategyTVC: UITableViewCell {
    var controller : AddStrategyVC?
    var percentage = String()
    //MARK: - IB OUTLETS
    @IBOutlet var assetsView: UIView!
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var coinNameLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    
    @IBOutlet var graphVw: UIImageView!
    @IBOutlet var allocationLbl: UILabel!
    @IBOutlet var percentageView: UIView!
    @IBOutlet var autoPercentageLbl: UILabel!
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
extension AddStrategyTVC{
    func setUpCell(data: priceServiceResume?,index : Int, allocation: Int){
        //get all informations of the currency
        let currencyDetail : AssetBaseData? = Storage.getCurrency(asset : data)
        
        self.coinImg.layer.cornerRadius = self.coinImg.bounds.height/2
        self.coinImg.sd_setImage(with: URL(string: currencyDetail?.image ?? ""))

        CommonUI.setUpLbl(lbl: self.coinNameLbl, text: currencyDetail?.fullName ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: (data?.lastPrice ?? "0.00")+" €", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.percentageLbl, text: (data?.change ?? "0.00")+" %", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.allocationLbl, text: CommonFunctions.localisation(key: "ALLOCATION"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
       
        if(data?.isAuto == true)
        {
            self.autoPercentageLbl.attributedText = CommonUI.showAttributedString(firstStr: CommonFunctions.localisation(key: "AUTO"), secondStr: " (\(allocation) %)", firstFont: UIFont.MabryPro(Size.XLarge.sizeValue()), secondFont: UIFont.MabryPro(Size.XLarge.sizeValue()), firstColor: UIColor.primaryTextcolor, secondColor: UIColor.SecondarytextColor)
        }
        else{
            CommonUI.setUpLbl(lbl: self.autoPercentageLbl, text: " \(allocation) %", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        }
        
                                                                                                                                
        CommonUI.setUpViewBorder(vw: assetsView, radius: 16, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        CommonUI.setUpViewBorder(vw: percentageView, radius: 12, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        let percentageTap = UITapGestureRecognizer(target: self, action: #selector(selectAllocation))
        self.percentageView.addGestureRecognizer(percentageTap)
        self.percentageView.tag = index
        self.graphVw.sd_setImage(with: URL(string: data?.squiggleURL ?? ""))
      
    }
}

//MARK: - objective functions
extension AddStrategyTVC{
    @objc func selectAllocation(){
        let vc = AllocationVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        self.controller?.present(vc, animated: true, completion: nil)
		if(self.controller?.allocation[self.percentageView.tag] == 0){
			vc.allocationSelected = "5%"
		}else{
			vc.allocationSelected = "\(self.controller?.allocation[self.percentageView.tag] ?? 0)%"
		}
        
        
        vc.allocationCallBack = { [weak self] allocation in
            self?.controller?.allocation[self?.percentageView.tag ?? 0] = Int(allocation.replacingOccurrences(of: "%", with: "")) ?? 0
            self?.controller?.assetsData[self?.percentageView.tag ?? 0]?.isAuto = false
        
            self?.controller?.handleAllocationPercentage(asset : self?.controller?.assetsData[self?.percentageView.tag ?? 0])
          
            self?.controller?.tblView.reloadData()
            self?.controller?.handleAllocationPercentageView()
        }
    }
}
