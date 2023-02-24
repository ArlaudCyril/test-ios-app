//
//  AddressAddedPopUpVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

enum whiteListingPopUp{
    case detailAddress
    case confirmAddress
}
class AddressAddedPopUpVC: UIViewController {
    //MARK: - Variables
    var controller : AddCryptoAddressVC?
    var addressBookController : CryptoAddressBookVC?
    var cryptoAddressAdded : cryptoAddressModel?
    var popUpType : whiteListingPopUp?
    var addressId = String()
    var addressAddedPopUpVM = AddressAddedPopUpVM()
    var deleteCallback : (()->())?
    
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var addressView: UIView!
    
    @IBOutlet var networkLbl: UILabel!
    @IBOutlet var networkNameLbl: UILabel!
    
    @IBOutlet var addressOriginView: UIView!
    @IBOutlet var addresOriginLbl: UILabel!
    @IBOutlet var addressOriginNameLbl: UILabel!
    
    @IBOutlet var dateAddedLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    @IBOutlet var confirmBtn: LoadingButton!
    @IBOutlet var editBtn: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
       
    }

}

//MARK: - SetUpUI
extension AddressAddedPopUpVC{
    func setUpUI(){
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.headerView.headerLbl.text = cryptoAddressAdded?.addressName ?? ""
        
        CommonUI.setUpViewBorder(vw: self.addressView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.networkLbl, text: L10n.Network.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addresOriginLbl, text: "\(L10n.Address.description) \(L10n.Origin.description)", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: "Date added", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.networkNameLbl, text: cryptoAddressAdded?.network ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        if cryptoAddressAdded?.exchange == ""{
            self.addressOriginView.isHidden = true
        }
        CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: cryptoAddressAdded?.exchange ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.dateLbl, text: CommonFunctions.getCurrentDate(requiredFormat: "dd MMM yyyy"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpButton(btn: self.confirmBtn, text: L10n.Confirm.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: self.editBtn, text: L10n.Edit.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.editBtn.addTarget(self, action: #selector(editAct), for: .touchUpInside)
        self.confirmBtn.addTarget(self, action: #selector(confirmBtnAct), for: .touchUpInside)
        let tapp = UITapGestureRecognizer(target: self, action: #selector(outerTapped))
        self.outerView.addGestureRecognizer(tapp)
        
        if popUpType == .confirmAddress{
            
        }else if popUpType == .detailAddress{
            self.confirmBtn.setTitle(L10n.Delete.description, for: .normal)
            CommonFunctions.showLoader(self.bottomView)
            addressAddedPopUpVM.getAddressDetailApi(addressId: self.addressId, completion: {[weak self]response in
                CommonFunctions.hideLoader(self?.bottomView ?? UIView())
                self?.cryptoAddressAdded = cryptoAddressModel(addressName: response?.name ?? "", network: response?.network ?? "", address: response?.address ?? "", origin: response?.origin ?? "", exchange: response?.exchange ?? "", logo: response?.logo ?? "")
                self?.headerView.headerLbl.text = response?.name ?? ""
                self?.networkNameLbl.text = response?.network ?? ""
                self?.dateLbl.text = CommonFunctions.getDateFromUnixInterval(timeResult: Double(response?.createdAt ?? "") ?? 0, requiredFormat: "dd MMM yyyy")
                if response?.exchange == nil || response?.exchange == nil{
                    self?.addressOriginView.isHidden = true
                }else{
                    self?.addressOriginNameLbl.text = response?.exchange ?? ""
                    self?.addressOriginView.isHidden = false
                    
                }
                
            })
        }
    }
}

//MARK: - objective functions
extension AddressAddedPopUpVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func outerTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editAct(){
        if popUpType == .confirmAddress{
            self.dismiss(animated: true, completion: nil)
        }else if popUpType == .detailAddress{
                self.dismiss(animated: true, completion: nil)
                let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.isEditAddress = true
                self.cryptoAddressAdded?.addressId = addressId
                vc.cryptoAddress = self.cryptoAddressAdded
                self.addressBookController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func confirmBtnAct(){
        if popUpType == .confirmAddress{
            self.callConfirmApi()
        }else if popUpType == .detailAddress{
            self.callDeleteApi()
           
        }
    }
}

//MARK: - Other functions
extension AddressAddedPopUpVC{
    func callDeleteApi(){
        self.confirmBtn.showLoading(color: UIColor.PurpleColor)
        self.confirmBtn.isUserInteractionEnabled = false
        addressAddedPopUpVM.deleteAddressApi(addressId: self.addressId, completion: {[weak self]response in
            self?.confirmBtn.isUserInteractionEnabled = true
            self?.confirmBtn.hideLoading()
            self?.dismiss(animated: true, completion: nil)
            self?.deleteCallback?()
        })
    }
    
    func callConfirmApi(){
        self.confirmBtn.showLoading(color: UIColor.PurpleColor)
        self.confirmBtn.isUserInteractionEnabled = false
        addressAddedPopUpVM.addWhiteListingAddressApi(cryptoAddress: self.cryptoAddressAdded, completion: {[weak self]response in
            self?.confirmBtn.isUserInteractionEnabled = true
            self?.confirmBtn.hideLoading()
            if let response = response{
                self?.dismiss(animated: true, completion: nil)
                self?.controller?.navigationController?.popToViewController(ofClass: CryptoAddressBookVC.self)
            }
            
        })
    }
}
