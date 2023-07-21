//
//  CryptoDepositeVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/08/22.
//

import UIKit
import DropDown

class CryptoDepositeVC: ViewController {
    //MARK: - Variables
    var selectedAsset : AssetBaseData?
    var availableAssets : [AssetBaseData?] = []
    var assetValueArr : [String]? = []
    var assetImgArr : [String]? = []
	var networkArray : [NetworkAsset] = []
    var dropDownAsset = DropDown()
    var dropDownProtocol = DropDown()
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var cryptoAssetLbl: UILabel!
	
    @IBOutlet var assetView: UIView!
    @IBOutlet var assetLbl: UILabel!
    @IBOutlet var assetImgVw: UIImageView!
    @IBOutlet var assetNameLbl: UILabel!
    @IBOutlet var assetDropdownBtn: UIButton!
    
	@IBOutlet var protocolView: UIView!
	@IBOutlet var protocolLbl: UILabel!
	@IBOutlet var protocolNameLbl: UILabel!
	@IBOutlet var protocolDropdownBtn: UIButton!
	
    @IBOutlet var depositeAddressLbl: UILabel!
    @IBOutlet var depositeAddressVw: UIView!
    @IBOutlet var depositeAddresTextVw: UITextView!
    @IBOutlet var scanBtn: UIButton!
    @IBOutlet var copyBtn: UIButton!
    
    @IBOutlet var sendOnlyAssetView: UIView!
    @IBOutlet var sendOnlyAssetLbl: UILabel!
    
    @IBOutlet var orLbl: UILabel!
    @IBOutlet var buyCoinBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getAssetsDetail()
		callCoinInfoApi(assetId: self.selectedAsset?.id ?? "")
    }



	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: cryptoAssetLbl, text: CommonFunctions.localisation(key: "CRYPTO_ASSET_DEPOSIT"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.depositeAddressLbl, text: CommonFunctions.localisation(key: "DEPOSIT_ADRESS"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        
        
        CommonUI.setUpViewBorder(vw: depositeAddressVw ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
		
		
									
        self.depositeAddresTextVw.textColor = UIColor.ThirdTextColor
        self.depositeAddresTextVw.font = UIFont.MabryPro(Size.Large.sizeValue())
        
        CommonUI.setUpViewBorder(vw: self.sendOnlyAssetView, radius: 16, borderWidth: 0, borderColor: UIColor.ColorFFF2D9.cgColor, backgroundColor: UIColor.ColorFFF2D9)
		CommonUI.setUpLbl(lbl: orLbl, text: CommonFunctions.localisation(key: "OR"), textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.buyCoinBtn.addTarget(self, action: #selector(buyCoinBtnAct), for: .touchUpInside)
        self.copyBtn.addTarget(self, action: #selector(copyBtnAct), for: .touchUpInside)
        self.scanBtn.addTarget(self, action: #selector(scanBtnAct), for: .touchUpInside)
		
		//asset Dropdown
		dropdownAssetConfiguration()
		
        let assetTap = UITapGestureRecognizer(target: self, action: #selector(assetSelect))
        self.assetView.addGestureRecognizer(assetTap)
        self.assetDropdownBtn.addTarget(self, action: #selector(assetDropdownBtnAct), for: .touchUpInside)
		
		//protocol Dropdown
		dropdownProtocolConfiguration()
		let protocolTap = UITapGestureRecognizer(target: self, action: #selector(protocolSelect))
		self.protocolView.addGestureRecognizer(protocolTap)
		self.protocolDropdownBtn.addTarget(self, action: #selector(protocolDropdownBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension CryptoDepositeVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func assetSelect(){
        self.dropDownAsset.show()
    }
	@objc func assetDropdownBtnAct(){
		assetSelect()
	}
	
	@objc func protocolSelect(){
		self.dropDownProtocol.show()
	}
	@objc func protocolDropdownBtnAct(){
		protocolSelect()
	}
    
    @objc func buyCoinBtnAct(){
		//TODO: Later
        //self.callCoinInfoApi(assetName: self.selectedAssetName)
    }
	@objc func copyBtnAct(){
		UIPasteboard.general.string = self.depositeAddresTextVw.text
		CommonFunctions.toster(CommonFunctions.localisation(key: "COPIED"))
    }
	@objc func scanBtnAct(){
		if(self.depositeAddresTextVw.text != ""){
			let vc = QrCodeVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
			vc.urlQrCode = self.depositeAddresTextVw.text
			let nav = UINavigationController(rootViewController: vc)
			nav.modalPresentationStyle = .fullScreen
			nav.navigationBar.isHidden = true
			self.present(nav, animated: true, completion: nil)
		}
    }
}

//MARK: - Other functions
extension CryptoDepositeVC{
    func getAssetsDetail(){
		self.availableAssets = Storage.currencies.filter{$0?.isDepositActive ?? false}
		
		for (_,value) in self.availableAssets.enumerated() {
			self.assetValueArr?.append("\(value?.fullName ?? "") (\(value?.id?.uppercased() ?? ""))")
			self.assetImgArr?.append(value?.imageUrl ?? "")
		}
		self.dropDownAsset.dataSource = self.assetValueArr ?? []
        
    }
    
	
	func callCoinInfoApi(assetId: String){
		let textBuyCoinBtn = "\(CommonFunctions.localisation(key: "BUY")) \(self.selectedAsset?.fullName ?? "") \(CommonFunctions.localisation(key: "ON_LYBER"))"
		
		CommonUI.setUpButton(btn: self.buyCoinBtn ?? UIButton(), text: textBuyCoinBtn, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonFunctions.showLoader()
        PortfolioDetailVM().getCoinInfoApi(Asset: assetId, isNetwork: true, completion: {[weak self]response in
			CommonFunctions.hideLoader()
			self?.dropDownProtocol.dataSource = []
			
			for network in response?.data?.networks ?? []{
				if(network.isDepositActive == true){
					self?.networkArray.append(network)
				}
			}
			
			let indexNative = self?.networkArray.firstIndex(where: {$0.id == response?.data?.defaultDepositNetwork})
			
			if(indexNative != nil){
				self?.networkArray.move(fromOffsets: IndexSet(integer: indexNative ?? 0) , toOffset: 0)
			}
			for network in self?.networkArray ?? []{
				self?.dropDownProtocol.dataSource.append(network.fullName ?? "" )
			}
			
			if(self?.networkArray.count ?? 0 > 0){
				CommonUI.setUpLbl(lbl: self?.protocolNameLbl ?? UILabel(), text: self?.dropDownProtocol.dataSource[0] ?? "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
			
				self?.callGetWalletAdressApi(assetId: self?.selectedAsset?.id ?? "", networkLabel: self?.dropDownProtocol.dataSource[0] ?? "", networkId: self?.networkArray[0].id ?? "")
			}
			else{
				let textSendOnlyAssetLbl = "\(CommonFunctions.localisation(key: "NETWORKS_ASSET_DEACTIVATED"))."
				
				CommonUI.setUpLbl(lbl: self?.sendOnlyAssetLbl ?? UILabel(), text: textSendOnlyAssetLbl, textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Small.sizeValue()))
			}
			
        })
    }
	
	func callGetWalletAdressApi(assetId: String, networkLabel: String, networkId: String){
		let textSendOnlyAssetLbl = "\(CommonFunctions.localisation(key: "SEND_ONLY")) \(self.assetNameLbl.text ?? "") \(CommonFunctions.localisation(key: "ADDRESS_USING")) \(networkLabel) \(CommonFunctions.localisation(key: "PROTOCOL_CHAIN"))."
		
		CommonUI.setUpLbl(lbl: self.sendOnlyAssetLbl ?? UILabel(), text: textSendOnlyAssetLbl, textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Small.sizeValue()))
		
		self.depositeAddresTextVw.text = ""
		CommonFunctions.showLoaderWhite(self.depositeAddresTextVw)
		CryptoDepositeVM().getWalletAdressApi(assetId: assetId, network: networkId, completion: {[weak self]response in
			CommonFunctions.hideLoader(self?.depositeAddresTextVw ?? UIView())
			self?.depositeAddresTextVw.text = response?.data?.address
			
			
		})
	}
	
	func dropdownAssetConfiguration(){
		CommonUI.setUpViewBorder(vw: assetView ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
		
		CommonUI.setUpLbl(lbl: self.assetLbl, text: CommonFunctions.localisation(key: "ASSET"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
		
		self.assetImgVw.sd_setImage(with: URL(string: CommonFunctions.getImage(id: selectedAsset?.id ?? "")))
		
		CommonUI.setUpLbl(lbl: assetNameLbl, text: "\(selectedAsset?.fullName ?? "") (\(selectedAsset?.id ?? ""))", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
		
		dropDownAsset.cellHeight = 44
		dropDownAsset.anchorView = assetView
		dropDownAsset.bottomOffset = CGPoint(x: 0, y: assetView.frame.height)
		dropDownAsset.textFont = UIFont.MabryPro(Size.Large.sizeValue())
		dropDownAsset.cellNib = UINib(nibName: "dropDownTableViewCell", bundle: nil)
		
		//configuration printing dropdown
		dropDownAsset.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			guard let cell = cell as? dropDownTableViewCell else { return }
			cell.textLbl.text = item
			cell.imgVw.sd_setImage(with: URL(string: self.assetImgArr?[index] ?? ""))
		}
		
		
		//when one option is selected
		dropDownAsset.selectionAction = {[weak self] (index: Int,item: String) in
			self?.assetNameLbl.text = item
			self?.assetImgVw.sd_setImage(with: URL(string: self?.assetImgArr?[index] ?? ""))
			self?.selectedAsset = self?.availableAssets[index] ?? nil
			self?.callCoinInfoApi(assetId: self?.availableAssets[index]?.id ?? "")
		}
		
	}
	
	func dropdownProtocolConfiguration(){
		CommonUI.setUpViewBorder(vw: protocolView ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
		
		CommonUI.setUpLbl(lbl: self.protocolLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
		
		dropDownProtocol.cellHeight = 44
		dropDownProtocol.anchorView = protocolView
		dropDownProtocol.bottomOffset = CGPoint(x: 0, y: protocolView.frame.height)
		dropDownProtocol.textFont = UIFont.MabryPro(Size.Large.sizeValue())
		dropDownProtocol.backgroundColor = UIColor.PurpleGrey_50
		dropDownProtocol.cornerRadius = 8

		//configuration printing dropdown
		dropDownProtocol.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			cell.optionLabel.text = item
		}
		
		//when one option is selected
		dropDownProtocol.selectionAction = {[weak self] (index: Int,item: String) in
			self?.protocolNameLbl.text = item
			self?.callGetWalletAdressApi(assetId: self?.selectedAsset?.id ?? "", networkLabel: item, networkId: self?.networkArray[index].id ?? "")
		}
		
	}
}
