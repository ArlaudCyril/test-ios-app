//
//  AddCryptoAddressVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit
import DropDown
import SVGKit
import Alamofire
import IQKeyboardManagerSwift

class AddCryptoAddressVC: SwipeGesture {
    var addSelectedCoinAddress = false
    var networkDropdown = DropDown()
    var addCryptoAddressVM = AddCryptoAddressVM()
    var networkValueArr : [String]? = []
    var networkImgArr : [String]? = []
    var exchangeValueArr : [String]? = []
    var cryptoAddress : Address?
    var selectedOrigin = UILabel()
    var selectedNetworkImg = String()
    var selectedNetworkId = String()
    var isEditAddress = false
	
	//withdraw
	var network = ""
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var addCryptoAddressLbl: UILabel!
    @IBOutlet var addressNameLbl: UILabel!
    @IBOutlet var addressNameView: UIView!
    @IBOutlet var addressNameTF: UITextField!
    
    @IBOutlet var networkLbl: UILabel!
    @IBOutlet var networkview: UIView!
    @IBOutlet var networkDownBtn: UIButton!
    @IBOutlet var networkImgLblView: UIView!
    @IBOutlet var networkImgView: UIImageView!
    @IBOutlet var networkValueLbl: UILabel!
    @IBOutlet var networkChooseView: UIView!
    @IBOutlet var networkChooseLbl: UILabel!
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressTF: UITextField!
    @IBOutlet var addressErrorLbl: UILabel!
    @IBOutlet var addressScanBtn: UIButton!
    
    @IBOutlet var originLbl: UILabel!
    @IBOutlet var exchangeView: UIView!
    @IBOutlet var exchangeRadioBtn: UIButton!
    @IBOutlet var exchangeLbl: UILabel!
    @IBOutlet var walletView: UIView!
    @IBOutlet var walletRadioBtn: UIButton!
    @IBOutlet var walletLbl: UILabel!
    
    @IBOutlet var exchangeVw: UIView!
    @IBOutlet var selectExchangeLbl: UILabel!
    @IBOutlet var selectExchangeView: UIView!
    @IBOutlet var ExchangeTF: UITextField!
    
    @IBOutlet var noteView: UIView!
    @IBOutlet var noteLbl: UILabel!
    @IBOutlet var addAddressBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getNetworkData()
        if isEditAddress{
            setData()
		}
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.addCryptoAddressLbl, text: CommonFunctions.localisation(key: "ADD_ADRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
		self.addCryptoAddressLbl.numberOfLines = 0
        CommonUI.setUpLbl(lbl: self.addressNameLbl, text: CommonFunctions.localisation(key: "ADRESS_NAME"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "ADDRESS"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.originLbl, text: CommonFunctions.localisation(key: "ORIGIN"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.selectExchangeLbl, text: CommonFunctions.localisation(key: "WRITE_EXCHANGE"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        
        self.addressNameTF.font = UIFont.MabryPro(Size.Large.sizeValue())
        self.addressNameTF.placeholder = CommonFunctions.localisation(key: "ADRESS_NAME")
        self.networkImgLblView.isHidden = true
        CommonUI.setUpLbl(lbl: self.networkValueLbl, text: "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkChooseLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.addressErrorLbl, text: CommonFunctions.localisation(key: "ENTER_VALID_ADDRESS"), textColor: UIColor.red, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.addressErrorLbl.isHidden = true
        self.addressTF.delegate = self
        self.addressTF.placeholder = CommonFunctions.localisation(key: "ENTER_SCAN_ADDRESS")
        self.addressTF.font = UIFont.MabryPro(Size.Medium.sizeValue())
        self.ExchangeTF.font = UIFont.MabryPro(Size.Large.sizeValue())
        
        let views = [addressNameView,networkview,addressView,exchangeView,walletView,selectExchangeView]
        for view in views{
            CommonUI.setUpViewBorder(vw: view ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        }
		
//        self.exchangeView.layer.borderColor = UIColor.PurpleColor.cgColor
//        self.exchangeRadioBtn.setImage(Assets.radio_select.image(), for: .normal)
        selectOrigin(selectBtn: self.exchangeRadioBtn, unSelectBtn: self.walletRadioBtn, selectView: self.exchangeView, unSelectView: self.walletView)
        selectedOrigin = exchangeLbl
        
        CommonUI.setUpLbl(lbl: self.exchangeLbl, text: CommonFunctions.localisation(key: "EXCHANGE_PLATFORM"), textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.exchangeLbl.numberOfLines = 0
        CommonUI.setUpLbl(lbl: self.walletLbl, text: CommonFunctions.localisation(key: "WALLET"), textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.noteView, radius: 16, borderWidth: 0, borderColor: UIColor.borderColor.cgColor, backgroundColor: UIColor.ColorFFF2D9)
		
		
		// for the moment we don't use notelbl
		self.noteView.isHidden = true
        /*CommonUI.setUpLbl(lbl: self.noteLbl, text: CommonFunctions.localisation(key: "IMPORTANT_NOTE"), textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))
        self.noteLbl.attributedText = CommonUI.showAttributedString(firstStr: CommonFunctions.localisation(key: "IMPORTANT_NOTE"), secondStr: CommonFunctions.localisation(key: "YOUR_NOTE_GOES_HERE"), firstFont: UIFont.MabryProMedium(Size.Small.sizeValue()), secondFont: UIFont.MabryPro(Size.Small.sizeValue()), firstColor: UIColor.grey36323C, secondColor: UIColor.grey36323C)*/
		
        CommonUI.setUpButton(btn: self.addAddressBtn, text: CommonFunctions.localisation(key: "ADD_ADRESS"), textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if network != ""{
			self.addCryptoAddressLbl.text = "\(CommonFunctions.localisation(key: "ADD_CRYPTO_ADDRESS_PART1")) \(self.network.uppercased()) \(CommonFunctions.localisation(key: "ADD_CRYPTO_ADDRESS_PART2"))"
            self.addAddressBtn.setTitle(CommonFunctions.localisation(key: "ADD_USE_ADRESS"), for: .normal)
        }
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.addAddressBtn.addTarget(self, action: #selector(addAddressBtnAct), for: .touchUpInside)
        self.addressScanBtn.addTarget(self, action: #selector(addressScanBtnAct), for: .touchUpInside)
        
        let exchangeTap = UITapGestureRecognizer(target: self, action: #selector(exchangeTappped))
        self.exchangeView.addGestureRecognizer(exchangeTap)
        
        let walletTap = UITapGestureRecognizer(target: self, action: #selector(walletTappped))
        self.walletView.addGestureRecognizer(walletTap)
        
        let networkTap = UITapGestureRecognizer(target: self, action: #selector(networkTappped))
        self.networkview.addGestureRecognizer(networkTap)
        
        networkDropdown.layer.cornerRadius = 6
        networkDropdown.anchorView = networkview
        networkDropdown.bottomOffset = CGPoint(x: 0, y: networkChooseView.frame.height)
        networkDropdown.textFont = UIFont.MabryPro(Size.Large.sizeValue())
        networkDropdown.cellNib = UINib(nibName: "dropDownTableViewCell", bundle: nil)
        networkDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? dropDownTableViewCell else { return }
            cell.textLbl.text = item
            cell.imgVw.sd_setImage(with: URL(string: self.networkImgArr?[index] ?? ""))
        }
        networkDropdown.selectionAction = {[weak self] (index: Int,item: String) in
            self?.networkChooseView.isHidden = true
            self?.networkImgLblView.isHidden = false
            self?.selectedNetworkImg = self?.networkImgArr?[index] ?? ""
			self?.networkValueLbl.text = item//.sd_setImage(with: URL(string: coin.imageUrl ?? ""))

            self?.networkImgView.sd_setImage(with: URL(string: self?.networkImgArr?[index] ?? ""))
            let str = (item).components(separatedBy: " (")
            self?.selectedNetworkId = str[1].replacingOccurrences(of: ")", with: "")
        }
        networkDropdown.cellHeight = 44
    }
    
    func setData(){
        self.addCryptoAddressLbl.text = CommonFunctions.localisation(key: "EDIT_CRYPTO_ADRESS")
        self.addressNameTF.text = cryptoAddress?.name ?? ""
		self.networkChooseView.isHidden = true
		self.networkImgLblView.isHidden = false
		self.selectedNetworkId = self.cryptoAddress?.network ?? ""
		self.selectedNetworkImg = CommonFunctions.getImage(id: self.selectedNetworkId)
		self.networkValueLbl.text = self.selectedNetworkId.uppercased()
		self.networkImgView.sd_setImage(with: URL(string: self.selectedNetworkImg))
		
		//we can't change the address and the network
		self.addressTF.text = cryptoAddress?.address ?? ""
		self.addressView.isUserInteractionEnabled = false
		self.addressView.backgroundColor = UIColor.greyDisabled
		self.networkview.backgroundColor = UIColor.greyDisabled
		self.networkview.isUserInteractionEnabled = false
		self.networkImgLblView.backgroundColor = UIColor.greyDisabled
		
        self.addAddressBtn.setTitle(CommonFunctions.localisation(key: "EDIT_ADRESS"), for: .normal)
        if cryptoAddress?.origin == "WALLET"{
            self.exchangeVw.isHidden = true
            selectOrigin(selectBtn: self.walletRadioBtn, unSelectBtn: self.exchangeRadioBtn, selectView: self.walletView, unSelectView: self.exchangeView)
        }else{
            selectOrigin(selectBtn: self.exchangeRadioBtn, unSelectBtn: self.walletRadioBtn, selectView: self.exchangeView, unSelectView: self.walletView)
            self.exchangeVw.isHidden = false
            self.ExchangeTF.text = cryptoAddress?.exchange ?? ""
        }
    }
    
}


//MARK: - objective functions
extension AddCryptoAddressVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addressScanBtnAct(){
        let vc = QRCodeScanVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.navigationController?.pushViewController(vc, animated: true)
        vc.getQRString = {address in
            self.addressTF.text = address
        }
    }
    
    @objc func addAddressBtnAct(){
		checkValidation(completion: {
			self.addCryptoAddressVM.getNetworkByIdApi(id: self.selectedNetworkId.lowercased(), completion: {response in
				let regexPattern = response?.data.addressRegex
				let text = self.addressTF.text ?? ""
				
				do {
					let regex = try NSRegularExpression(pattern: regexPattern ?? "")
					let range = NSRange(text.startIndex..<text.endIndex, in: text)
					let match = regex.firstMatch(in: text, options: [], range: range)
					
					if match != nil {
						var originValue = "wallet"
						if(self.exchangeRadioBtn.isSelected){
							originValue = "exchange"
						}
						self.cryptoAddress = Address(address: self.addressTF.text ?? "", network: self.selectedNetworkId, name: self.addressNameTF.text ?? "", origin: originValue, exchange: self.ExchangeTF.text, creationDate: "")
						self.addAddressBtn.showLoading()
						CryptoAddressBookVM().createWithdrawalAddress(cryptoAddress: self.cryptoAddress, completion: {[weak self]response in
							self?.addAddressBtn.hideLoading()
							self?.navigationController?.popViewController(animated: true)
							
						})
					}else {
						CommonFunctions.toster(Constants.AlertMessages.PleaseEnterValidAddress)
					}
				} catch {
					print("error : \(error)")
				}
			})
		})
    }
    
    @objc func exchangeTappped(view: UITapGestureRecognizer){
        selectedOrigin = exchangeLbl
        self.exchangeVw.isHidden = false
        selectOrigin(selectBtn: self.exchangeRadioBtn, unSelectBtn: self.walletRadioBtn, selectView: self.exchangeView, unSelectView: self.walletView)
    }
    
    @objc func walletTappped(){
        selectedOrigin = walletLbl
        self.exchangeVw.isHidden = true
        self.ExchangeTF.text = ""
        selectOrigin(selectBtn: self.walletRadioBtn, unSelectBtn: self.exchangeRadioBtn, selectView: self.walletView, unSelectView: self.exchangeView)
    }
    
    @objc func networkTappped(){
        self.networkDropdown.show()
        
        
    }
    
    func selectOrigin(selectBtn : UIButton, unSelectBtn: UIButton,selectView : UIView, unSelectView : UIView){
        selectView.layer.borderColor = UIColor.PurpleColor.cgColor
        selectBtn.setImage(Assets.radio_select.image(), for: .normal)
		selectBtn.isSelected = true
        unSelectView.layer.borderColor = UIColor.borderColor.cgColor
        unSelectBtn.setImage(Assets.radio_unselect.image(), for: .normal)
		unSelectBtn.isSelected = false
    }
}

//MARK: - Text Field Delegates
extension AddCryptoAddressVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		if string == UIPasteboard.general.string {
			return true
		}
        if textField == addressTF{
            let tf = textField.text ?? ""
            let validString = NSCharacterSet(charactersIn: " !@#$%^&*()_+{}[]|\"<>,.~`/:;?-=\\¥'£•¢€₹")
            // restrict special char in test field
            if let range = string.rangeOfCharacter(from: validString as CharacterSet){
                print(range)
                return false
            }
            
            if self.selectedNetworkId == "BTC"{
                if ((tf.hasPrefix("1")) || (tf.hasPrefix("3"))){
                    return (newString.length <= 35 )
                }else if (tf.hasPrefix("bc1")){
                    return (newString.length <= 37)
                }else{
                    return (newString.length <= 37)
                }
            }else if self.selectedNetworkId == ""{
                
            }else{
                return (newString.length <= 42 )
                
            }
        }
        return true
    }
}


//MARK: - Other functions
extension AddCryptoAddressVC{
    func getNetworkData(){
        for network in Storage.networks{
            if(self.network != "")
            {
                if(network.id == self.network){
                    self.networkValueArr?.append("\(network.fullName ?? "") (\(network.id.uppercased() ))")
                    self.networkImgArr?.append(network.imageUrl ?? "")
                }
                
            }
            else{
                self.networkValueArr?.append("\(network.fullName ?? "") (\(network.id.uppercased() ))")
                self.networkImgArr?.append(network.imageUrl ?? "")
            }
        }
        self.networkDropdown.dataSource = self.networkValueArr ?? []
        if(self.network != "")
        {
            CommonUI.setUpViewBorder(vw: self.networkImgLblView ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.greyDisabled.cgColor)
            self.networkDropdown.selectionAction!(0, self.networkDropdown.dataSource[0])
            self.networkview.backgroundColor = UIColor.greyDisabled
            self.networkview.isUserInteractionEnabled = false
            self.networkImgLblView.backgroundColor = UIColor.greyDisabled
        }
    }
    
    func checkValidation(completion : @escaping (()->()) ){
        if addressNameTF.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseEnterYourAddressName)
        }else if networkValueLbl.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseSelectYourNetwork)
        }else if addressTF.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseEnterOrScanAnAddress)
        }else if exchangeVw.isHidden == false{
            if ExchangeTF.text == ""{
                CommonFunctions.toster(Constants.AlertMessages.PleaseSelectYourExchange)
            }else{
                completion()
            }
        }else{
            completion()
        }
    }
    
}

