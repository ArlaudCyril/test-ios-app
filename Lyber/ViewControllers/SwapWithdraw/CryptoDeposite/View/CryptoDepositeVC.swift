//
//  CryptoDepositeVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/08/22.
//

import UIKit
import DropDown

class CryptoDepositeVC: UIViewController {
    //MARK: - Variables
    var selectedAssetName : String = "bitcoin"
    var availableAssets : [GetAssetsAPIElement]? = []
    var assetValueArr : [String]? = []
    var assetImgArr : [String]? = []
    var dropDown = DropDown()
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var cryptoAssetLbl: UILabel!
    @IBOutlet var assetView: UIView!
    @IBOutlet var assetLbl: UILabel!
    @IBOutlet var assetImgVw: UIImageView!
    @IBOutlet var assetNameLbl: UILabel!
    @IBOutlet var assetDropdownBtn: UIButton!
    
    @IBOutlet var depositeAddressLbl: UILabel!
    @IBOutlet var depositeAddressVw: UIView!
    @IBOutlet var depositeAddresTextVw: UITextView!
    @IBOutlet var scanBtn: UIButton!
    
    @IBOutlet var sendOnlyAssetView: UIView!
    @IBOutlet var sendOnlyAssetLbl: UILabel!
    
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var buyCoinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
//        callNetworkApi()
        callAssetsApi()
        // Do any additional setup after loading the view.
    }

}

//MARK: - SetUpUI
extension CryptoDepositeVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: cryptoAssetLbl, text: L10n.CryptoAssetDeposit.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.assetLbl, text: L10n.asset.description, textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.depositeAddressLbl, text: L10n.DepositAdress.description, textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: assetView ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: depositeAddressVw ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        self.assetImgVw.image = Assets.bitcoin.image()
        CommonUI.setUpLbl(lbl: assetNameLbl, text: "Bitcoin (BTC)", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        self.depositeAddresTextVw.textColor = UIColor.ThirdTextColor
        self.depositeAddresTextVw.font = UIFont.MabryPro(Size.Large.sizeValue())
        
        CommonUI.setUpViewBorder(vw: self.sendOnlyAssetView, radius: 16, borderWidth: 0, borderColor: UIColor.ColorFFF2D9.cgColor, backgroundColor: UIColor.ColorFFF2D9)
        CommonUI.setUpLbl(lbl: sendOnlyAssetLbl, text: L10n.sendOnlyBitcoin.description, textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: orLbl, text: "Or", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: buyCoinBtn, text: L10n.BuyBitcoinOnLyber.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        dropDown.layer.cornerRadius = 6
        dropDown.anchorView = assetView
        dropDown.bottomOffset = CGPoint(x: 0, y: assetView.frame.height)
        dropDown.textFont = UIFont.MabryPro(Size.Large.sizeValue())
        dropDown.cellNib = UINib(nibName: "dropDownTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? dropDownTableViewCell else { return }
            cell.textLbl.text = item
            cell.imgVw.sd_setImage(with: URL(string: self.assetImgArr?[index] ?? ""))
        }
        dropDown.selectionAction = {[weak self] (index: Int,item: String) in
            self?.assetNameLbl.text = item
            self?.selectedAssetName = self?.availableAssets?[index].assetID ?? ""
            self?.assetImgVw.sd_setImage(with: URL(string: self?.assetImgArr?[index] ?? ""))
        }
        dropDown.cellHeight = 44
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.buyCoinBtn.addTarget(self, action: #selector(buyCoinBtnAct), for: .touchUpInside)
        let assetTap = UITapGestureRecognizer(target: self, action: #selector(assetSelect))
        self.assetView.addGestureRecognizer(assetTap)
    }
}

//MARK: - objective functions
extension CryptoDepositeVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func assetSelect(){
        self.dropDown.show()
    }
    
    @objc func buyCoinBtnAct(){
        self.callCoinInfoApi(assetName: self.selectedAssetName)
    }
}

//MARK: - Other functions
extension CryptoDepositeVC{
    func callAssetsApi(){
        SearchAssetVM().getAssetsApi(searchText: "", completion: {[weak self]response in
            if let response = response{
                self?.availableAssets = response
                for (index,value) in response.enumerated() {
                    print(index,value)
                    self?.assetValueArr?.append("\(value.assetName ?? "") (\(value.symbol?.uppercased() ?? ""))")
                    self?.assetImgArr?.append(value.image ?? "")
                }
                self?.dropDown.dataSource = self?.assetValueArr ?? []
            }
        })
    }
    
    func callCoinInfoApi(assetName: String){
        CommonFunctions.showLoader(self.view)
        PortfolioDetailVM().getCoinInfoApi(Asset: assetName, completion: {[weak self]response in
            CommonFunctions.hideLoader(self?.view ?? UIView())
            let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
//            vc.assetsData = response
            vc.strategyType = .singleCoin
            self?.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
