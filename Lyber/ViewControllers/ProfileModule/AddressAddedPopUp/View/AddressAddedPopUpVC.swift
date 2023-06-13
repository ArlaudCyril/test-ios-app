//
//  AddressAddedPopUpVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

class AddressAddedPopUpVC: ViewController {
    //MARK: - Variables
    var controller : AddCryptoAddressVC?
    var addressBookController : CryptoAddressBookVC?
    var editAddress : Address?
    var addressId = String()//TODO: Delete addressId
    var addressAddedPopUpVM = AddressAddedPopUpVM()
    var deleteCallback : (()->())?
    
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var addressView: UIView!
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var addressCopyLbl: UILabel!
	
    @IBOutlet var networkLbl: UILabel!
    @IBOutlet var networkNameLbl: UILabel!
    
    @IBOutlet var addressOriginView: UIView!
    @IBOutlet var addressOriginLbl: UILabel!
    @IBOutlet var addressOriginNameLbl: UILabel!
    
    @IBOutlet var dateAddedLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    @IBOutlet var deleteBtn: LoadingButton!
    @IBOutlet var editBtn: LoadingButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
       
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.headerView.headerLbl.text = editAddress?.name ?? ""
        
        CommonUI.setUpViewBorder(vw: self.addressView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
		
		CommonUI.setUpLbl(lbl: self.addressLbl, text: self.editAddress?.address, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.addressLbl.numberOfLines = 0
		CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: CommonFunctions.localisation(key: "COPY"), textColor: UIColor.purple_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: "\(CommonFunctions.localisation(key: "ADDRESS_ORIGIN"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: "Date added", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
		CommonUI.setUpLbl(lbl: self.networkNameLbl, text: editAddress?.network?.uppercased() ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        if editAddress?.exchange == ""{
            self.addressOriginView.isHidden = true
        }
        CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: editAddress?.exchange ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))

        CommonUI.setUpLbl(lbl: self.dateLbl, text: CommonFunctions.getDateFormat(date: self.editAddress?.creationDate ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpButton(btn: self.deleteBtn, text: CommonFunctions.localisation(key: "DELETE"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpButton(btn: self.editBtn, text: CommonFunctions.localisation(key: "EDIT"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.editBtn.addTarget(self, action: #selector(editAct), for: .touchUpInside)
        self.deleteBtn.addTarget(self, action: #selector(confirmBtnAct), for: .touchUpInside)
        let tapp = UITapGestureRecognizer(target: self, action: #selector(outerTapped))
        self.outerView.addGestureRecognizer(tapp)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressCopyLblTapped(_:)))
		addressCopyLbl.addGestureRecognizer(tapGesture)
	
		
		if self.editAddress?.exchange == nil || self.editAddress?.exchange == nil{
			self.addressOriginView.isHidden = true
		}else{
			self.addressOriginNameLbl.text = self.editAddress?.exchange ?? ""
			self.addressOriginView.isHidden = false
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
		self.dismiss(animated: true, completion: nil)
		let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		vc.isEditAddress = true
		vc.cryptoAddress = self.editAddress
		self.addressBookController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func confirmBtnAct(){
		self.callDeleteApi()
        
    }
	
	@objc func addressCopyLblTapped(_ gesture: UITapGestureRecognizer) {
		CommonFunctions.toster(CommonFunctions.localisation(key: "ADDRESS_COPIED"))
		let pasteboard = UIPasteboard.general
		pasteboard.string = self.addressLbl.text
	}
}

//MARK: - Other functions
extension AddressAddedPopUpVC{
    func callDeleteApi(){
        self.deleteBtn.showLoading(color: UIColor.PurpleColor)
        self.deleteBtn.isUserInteractionEnabled = false
        addressAddedPopUpVM.deleteAddressApi(addressId: self.addressId, completion: {[weak self]response in
            self?.deleteBtn.isUserInteractionEnabled = true
            self?.deleteBtn.hideLoading()
            self?.dismiss(animated: true, completion: nil)
            self?.deleteCallback?()
        })
    }
}
