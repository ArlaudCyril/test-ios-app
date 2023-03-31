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

class AddCryptoAddressVC: ViewController {
    var addSelectedCoinAddress = false
    var assetData : Trending?
    var dropDown = DropDown(),exchangeDropDowm = DropDown()
    var addCryptoAddressVM = AddCryptoAddressVM()
    var networkValueArr : [String]? = []
    var networkIdArr : [String] = []
    var networkImgArr : [String]? = []
    var exchangeValueArr : [String]? = []
    var cryptoAddress : cryptoAddressModel?
    var selectedOrigin = UILabel()
    var selectedNetworkImg = String()
    var selectedNetworkId = String()
    var isEditAddress = false
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
    @IBOutlet var exchangeDownBtn: UIButton!
    
    @IBOutlet var noteView: UIView!
    @IBOutlet var noteLbl: UILabel!
    @IBOutlet var addAddressBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callNetworkApi()
        callExchangeApi()
        if isEditAddress{
            setData()
        }
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.addCryptoAddressLbl, text: CommonFunctions.localisation(key: "ADD_CRYPTO_ADRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressNameLbl, text: CommonFunctions.localisation(key: "ADRESS_NAME"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "ADDRESS"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.originLbl, text: CommonFunctions.localisation(key: "ORIGIN"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.selectExchangeLbl, text: CommonFunctions.localisation(key: "SELECT_EXCHANGE"), textColor: UIColor.Grey7B8094, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
        
        self.addressNameTF.font = UIFont.MabryPro(Size.Large.sizeValue())
        self.networkImgLblView.isHidden = true
        CommonUI.setUpLbl(lbl: self.networkValueLbl, text: "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkChooseLbl, text: CommonFunctions.localisation(key: "CHOOSE"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.addressErrorLbl, text: CommonFunctions.localisation(key: "ENTER_VALID_ADDRESS"), textColor: UIColor.red, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.addressErrorLbl.isHidden = true
        self.addressTF.delegate = self
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
        
        CommonUI.setUpLbl(lbl: self.exchangeLbl, text: CommonFunctions.localisation(key: "EXCHANGE"), textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.walletLbl, text: CommonFunctions.localisation(key: "WALLET"), textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.noteView, radius: 16, borderWidth: 0, borderColor: UIColor.borderColor.cgColor, backgroundColor: UIColor.ColorFFF2D9)
        CommonUI.setUpLbl(lbl: self.noteLbl, text: CommonFunctions.localisation(key: "IMPORTANT_NOTE"), textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Small.sizeValue()))
        self.noteLbl.attributedText = CommonUI.showAttributedString(firstStr: CommonFunctions.localisation(key: "IMPORTANT_NOTE"), secondStr: CommonFunctions.localisation(key: "YOUR_NOTE_GOES_HERE"), firstFont: UIFont.MabryProMedium(Size.Small.sizeValue()), secondFont: UIFont.MabryPro(Size.Small.sizeValue()), firstColor: UIColor.grey36323C, secondColor: UIColor.grey36323C)
        CommonUI.setUpButton(btn: self.addAddressBtn, text: CommonFunctions.localisation(key: "ADD_ADRESS"), textcolor: UIColor.whiteColor, backgroundColor: UIColor.PurpleColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if addSelectedCoinAddress == true{
            self.addCryptoAddressLbl.text = "Add a \(self.assetData?.name ?? "") address"
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
        
        let selectExchangeTap = UITapGestureRecognizer(target: self, action: #selector(selectExchangeTapped))
        self.selectExchangeView.addGestureRecognizer(selectExchangeTap)
        
        dropDown.layer.cornerRadius = 6
        dropDown.anchorView = networkview
        dropDown.bottomOffset = CGPoint(x: 0, y: networkChooseView.frame.height)
        dropDown.textFont = UIFont.MabryPro(Size.Large.sizeValue())
        dropDown.cellNib = UINib(nibName: "dropDownTableViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? dropDownTableViewCell else { return }
            cell.textLbl.text = item
            cell.imgVw.yy_setImage(with: URL(string: self.networkImgArr?[index] ?? ""), options: .progressiveBlur)
//            cell.imgVw.setSvgImage(from: URL(string: self.networkImgArr?[index] ?? ""))
        }
        dropDown.selectionAction = {[weak self] (index: Int,item: String) in
            self?.networkChooseView.isHidden = true
            self?.networkImgLblView.isHidden = false
            self?.selectedNetworkImg = self?.networkImgArr?[index] ?? ""
            self?.networkValueLbl.text = item
            self?.networkImgView.yy_setImage(with: URL(string: self?.networkImgArr?[index] ?? ""), options: .progressiveBlur)
            let str = (item).components(separatedBy: " (")
            self?.selectedNetworkId = str[1].replacingOccurrences(of: ")", with: "")
        }
        dropDown.cellHeight = 44

        self.exchangeDropDowm.anchorView = self.selectExchangeView
        self.exchangeDropDowm.bottomOffset = CGPoint(x: 0, y: self.selectExchangeView.frame.height )
        self.exchangeDropDowm.textFont = UIFont.MabryPro(Size.Large.sizeValue())
        self.exchangeDropDowm.selectionAction = {[weak self] (index: Int,item: String) in
            self?.ExchangeTF.text = item
        }
    }
    
    func setData(){
        self.addCryptoAddressLbl.text = CommonFunctions.localisation(key: "EDIT_CRYPTO_ADRESS")
        self.addressNameTF.text = cryptoAddress?.addressName ?? ""
        self.networkChooseView.isHidden = true
        self.networkImgLblView.isHidden = false
        self.networkImgView.yy_setImage(with: URL(string: cryptoAddress?.logo ?? ""), options: .progressiveBlur)
        self.selectedNetworkImg = cryptoAddress?.logo ?? ""
        self.networkValueLbl.text = cryptoAddress?.network ?? ""
        self.addressTF.text = cryptoAddress?.address ?? ""
        self.addAddressBtn.setTitle(CommonFunctions.localisation(key: "EDIT_ADRESS"), for: .normal)
//        let str = (cryptoAddress?.network ?? "").components(separatedBy: " (")
        self.selectedNetworkId = cryptoAddress?.network ?? ""
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
        if addSelectedCoinAddress == true{
            checkValidation(completion: {
                self.cryptoAddress = cryptoAddressModel(addressName: self.addressNameTF.text ?? "", network: self.selectedNetworkId , address: self.addressTF.text ?? "", origin: self.selectedOrigin.text?.uppercased() ?? "", exchange: self.ExchangeTF.text, logo: self.selectedNetworkImg)
                AddressAddedPopUpVM().addWhiteListingAddressApi(cryptoAddress: self.cryptoAddress, completion: {[weak self]response in
                    self?.navigationController?.popViewController(animated: true)
                })
            })
            
        }else{
            checkValidation(completion: {
                if self.isEditAddress{
                    self.cryptoAddress = cryptoAddressModel(addressName: self.addressNameTF.text ?? "", network: self.selectedNetworkId, address: self.addressTF.text ?? "", origin: self.selectedOrigin.text?.uppercased() ?? "", exchange: self.ExchangeTF.text, logo: self.selectedNetworkImg,addressId: self.cryptoAddress?.addressId ?? "")
                    self.addAddressBtn.showLoading()
                    self.addCryptoAddressVM.editWhiteListingAddressApi(cryptoAddress: self.cryptoAddress, completion: {[weak self]response in
                        self?.addAddressBtn.hideLoading()
                        if let _ = response{
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }else{
                    self.cryptoAddress = cryptoAddressModel(addressName: self.addressNameTF.text ?? "", network: self.networkValueLbl.text ?? "", address: self.addressTF.text ?? "", origin: self.selectedOrigin.text?.uppercased() ?? "", exchange: self.ExchangeTF.text, logo: self.selectedNetworkImg)
                    let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                    vc.popUpType = .confirmAddress
                    vc.controller = self
                    vc.cryptoAddressAdded = self.cryptoAddress
                    self.present(vc, animated: true, completion: nil)
                }
            })
            //            if addressNameTF.text == ""{
            //                CommonFunction.toster(Constants.AlertMessages.PleaseEnterYourAddressName)
            //            }else if networkValueLbl.text == ""{
            //                CommonFunction.toster(Constants.AlertMessages.PleaseSelectYourNetwork)
            //            }else if addressTF.text == ""{
            //                CommonFunction.toster(Constants.AlertMessages.PleaseEnterOrScanAnAddress)
            //            }else if ExchangeTF.text == ""{
            //                CommonFunction.toster(Constants.AlertMessages.PleaseSelectYourExchange)
            //            }else{
            //                if isEditAddress{
            //                    cryptoAddress = cryptoAddressModel(addressName: self.addressNameTF.text ?? "", network: networkValueLbl.text ?? "", address: addressTF.text ?? "", origin: selectedOrigin.text?.uppercased() ?? "", exchange: ExchangeTF.text, logo: self.selectedNetworkImg,addressId: cryptoAddress?.addressId ?? "")
            //                    self.addAddressBtn.showLoading()
            //                    addCryptoAddressVM.editWhiteListingAddressApi(cryptoAddress: cryptoAddress, completion: {[weak self]response in
            //                        self?.addAddressBtn.hideLoading()
            //                        if let _ = response{
            //                            self?.navigationController?.popViewController(animated: true)
            //                        }
            //                    })
            //                }else{
            //                    cryptoAddress = cryptoAddressModel(addressName: self.addressNameTF.text ?? "", network: networkValueLbl.text ?? "", address: addressTF.text ?? "", origin: selectedOrigin.text?.uppercased() ?? "", exchange: ExchangeTF.text, logo: self.selectedNetworkImg)
            //                    let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            //                    vc.popUpType = .confirmAddress
            //                    vc.controller = self
            //                    vc.cryptoAddressAdded = self.cryptoAddress
            //                    self.present(vc, animated: true, completion: nil)
            //                }
            //            }
        }
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
//        callNetworkApi()
        self.dropDown.show()
        
        
    }
    
    @objc func selectExchangeTapped(){
        callExchangeApi()
        self.exchangeDropDowm.show()
        
    }
    
    func selectOrigin(selectBtn : UIButton, unSelectBtn: UIButton,selectView : UIView, unSelectView : UIView){
        selectView.layer.borderColor = UIColor.PurpleColor.cgColor
        selectBtn.setImage(Assets.radio_select.image(), for: .normal)
        unSelectView.layer.borderColor = UIColor.borderColor.cgColor
        unSelectBtn.setImage(Assets.radio_unselect.image(), for: .normal)
    }
}

//MARK:- Text Field Delegates
extension AddCryptoAddressVC: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkAddressFormatvalidation()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
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
    func callNetworkApi(){
//        CommonFunction.showLoader(dropDown.anchorView as! UIView)
        addCryptoAddressVM.getNetworksDataApi(completion: {[weak self]response in
//            CommonFunction.hideLoader(self?.dropDown.anchorView as! UIView)
            if let response = response{
                for (index,value) in response.networks.enumerated() {
                    print(index,value)
                    self?.networkValueArr?.append("\(value.name ?? "") (\(value.assetID ?? ""))")
                    self?.networkIdArr.append(value.assetID ?? "")
                    self?.networkImgArr?.append(value.logo ?? "")
                }
                self?.dropDown.dataSource = self?.networkValueArr ?? []
            }
        })
    }
    
    func callExchangeApi(){
        addCryptoAddressVM.getExchangeApi(completion: {[weak self]response in
            if let response = response{
                for (index,value) in response.assets.enumerated() {
                    print(index,value)
                    self?.exchangeValueArr?.append("\(value.name ?? "")")
                }
                self?.exchangeDropDowm.dataSource = self?.exchangeValueArr ?? []
                
            }
        })
    }
    
    func checkValidation(completion : @escaping (()->()) ){
        if addressNameTF.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseEnterYourAddressName)
        }else if networkValueLbl.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseSelectYourNetwork)
        }else if addressTF.text == ""{
            CommonFunctions.toster(Constants.AlertMessages.PleaseEnterOrScanAnAddress)
        }else if checkAddressFormatvalidation() == false{
//            completion()
        }else if exchangeVw.isHidden{
            completion()
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
    
    func checkAddressFormatvalidation()->Bool{
        let tf = addressTF.text ?? ""
        if self.selectedNetworkId == "BTC"{
            if ((tf.hasPrefix("1") || tf.hasPrefix("3")) && (tf.count >= 28 && tf.count <= 35)) || ((tf.hasPrefix("bc1")) && (tf.count >= 30 && tf.count <= 37)){
                self.addressErrorLbl.isHidden = true
                return true
          }else{
//              CommonFunction.toster("Please enter the valid address")
              self.addressErrorLbl.isHidden = false
              return false
          }
        }else if self.selectedNetworkId == ""{
            return true
        }else{
            if (tf.hasPrefix("0x") && (tf.count == 42) && (tf.isValidHexNumber())){
                self.addressErrorLbl.isHidden = true
                return true
            }else{
//                CommonFunction.toster("Please enter the valid address")
                self.addressErrorLbl.isHidden = false
                return false
            }
        }
        
    }
}

