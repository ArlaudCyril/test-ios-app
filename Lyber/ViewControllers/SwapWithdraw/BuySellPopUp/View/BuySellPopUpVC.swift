//
//  BuySellPopUpVC.swift
//  Lyber
//
//  Created by sonam's Mac on 29/08/22.
//

import UIKit

class BuySellPopUpVC: ViewController {
    //MARK: - Variables
    var popUpType : confirmationPopUp?
    var assetData : Trending?
    var coinInvest : String?
    //MARK:- IB OUTLETS
    @IBOutlet var PopupView: UIView!
    @IBOutlet var successfullylbl: UILabel!
    @IBOutlet var assetView: UIView!
    @IBOutlet var assetImg: UIImageView!
    @IBOutlet var assetNameLbl: UILabel!
    @IBOutlet var ownLbl: UILabel!
    @IBOutlet var dismissLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.PopupView.layer.cornerRadius = 32
        CommonUI.setUpLbl(lbl: self.successfullylbl, text: "Successfully bought", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.ownLbl, text: "You now own \(self.assetData?.symbol?.uppercased() ?? "") \(self.coinInvest ?? "")", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.dismissLbl, text: "Tap anywhere to dismiss", textColor: UIColor.primaryTextcolor, font: UIFont.MabryProBold(Size.Medium.sizeValue()))
        
        self.assetView.layer.cornerRadius = self.assetView.layer.bounds.height/2
        self.assetImg.yy_setImage(with: URL(string: self.assetData?.image ?? ""), options: .progressiveBlur)
        CommonUI.setUpLbl(lbl: self.assetNameLbl, text: self.coinInvest ?? "", textColor: UIColor.whiteColor, font: UIFont.MabryProBold(Size.Medium.sizeValue()))
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTapped))
        self.view.addGestureRecognizer(tap)
        
        if popUpType == .Buy{
            self.successfullylbl.text = "Successfully bought"
        }else if popUpType == .Sell{
            self.successfullylbl.text = "Successfully Sold"
        }
    }
    
}

//MARK:- objective functions
extension BuySellPopUpVC{
    @objc func dismissTapped(){
//        self.dismiss(animated: true, completion: nil)
        let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		self.navigationController?.pushViewController(vc, animated: true)
    }
}
