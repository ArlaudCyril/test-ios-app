//
//  strategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import UIKit

class strategyVC: UIViewController {
    
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var ownStrategyLbl: UILabel!
    @IBOutlet var ownStrategyDescLbl: UILabel!
    @IBOutlet var addAssetBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomStrategyBtn: UIButton!
    @IBOutlet var minimumStrategyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }

}

//MARK: - SetUpUI
extension strategyVC{
    func setUpUI(){
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: ownStrategyLbl, text: L10n.BuildMyOwnStrategy.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: ownStrategyDescLbl, text: L10n.AddManyAssetsAsYouWish.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: self.addAssetBtn, text: L10n.AddAnAsset.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: bottomView, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        CommonUI.setUpButton(btn: self.bottomStrategyBtn, text: L10n.SauvegarderMaStratégie.description, textcolor: UIColor.white, backgroundColor: UIColor.grey877E95, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: minimumStrategyLbl, text: L10n.VousDevezAjouter.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        self.addAssetBtn.addTarget(self, action: #selector(addAssetBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension strategyVC{
    @objc func addAssetBtnAct(){
        let vc = AddAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
