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
    var addressAddedPopUpVM = AddressAddedPopUpVM()
    var deleteCallback : (()->())?
	var type : AddressAddedPopUpModel = .addressAdded
	
	//Detail Strategy
	var executionId = ""
	var name = ""
	var typeStrategy = ""
	
	//Detail Order
	var orderId = ""
	var feesPaid = ""
	
	//Detail Deposit
	var network = ""
	var transactionHash = ""
	
	//Detail Order || Detail Deposit || Detail Withdrawal
	var transactionId = ""
	var status = ""
	var from = ""
	var to = ""
	var amount = ""
	var date = ""
	
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var bottomViewHeightConst: NSLayoutConstraint!
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var addressCopyLbl: UILabel!
    @IBOutlet var addressImg: UIImageView!
	
    @IBOutlet var networkLbl: UILabel!
    @IBOutlet var networkNameLbl: UILabel!
    
    @IBOutlet var addressOriginView: UIView!
    @IBOutlet var addressOriginLbl: UILabel!
    @IBOutlet var addressOriginNameLbl: UILabel!
	@IBOutlet var addressOriginImg: UIImageView!
	
	@IBOutlet var toView: UIView!
	@IBOutlet var toLbl: UILabel!
	@IBOutlet var toNameLbl: UILabel!
	
	@IBOutlet var feesPaidView: UIView!
	@IBOutlet var feesPaidLbl: UILabel!
	@IBOutlet var feesPaidNameLbl: UILabel!
    
	@IBOutlet var dateView: UIView!
    @IBOutlet var dateAddedLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
	@IBOutlet var dateImg: UIImageView!
	
	@IBOutlet var iconView: UIView!
    
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
		CommonUI.setUpViewBorder(vw: self.addressView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
		self.addressImg.isHidden = true
		self.addressOriginImg.isHidden = true
		self.dateImg.isHidden = true
		
		handleTypePopUp()
        
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.editBtn.addTarget(self, action: #selector(editAct), for: .touchUpInside)
        self.deleteBtn.addTarget(self, action: #selector(deleteBtnAct), for: .touchUpInside)
        let tapp = UITapGestureRecognizer(target: self, action: #selector(outerTapped))
        self.outerView.addGestureRecognizer(tapp)
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addressCopyLblTapped(_:)))
		addressCopyLbl.addGestureRecognizer(tapGesture)
		
		let tapAddressImg = UITapGestureRecognizer(target: self, action: #selector(addressCopyLblTapped))
		self.addressImg.addGestureRecognizer(tapAddressImg)
		
		let tapAddressOriginImg = UITapGestureRecognizer(target: self, action: #selector(addressOriginImgAction))
		self.addressOriginImg.addGestureRecognizer(tapAddressOriginImg)
		
		let tapDateImg = UITapGestureRecognizer(target: self, action: #selector(dateImgAction))
		self.dateImg.addGestureRecognizer(tapDateImg)
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
    
    @objc func deleteBtnAct(){
		self.callDeleteApi()
        
    }
	
	@objc func addressCopyLblTapped(_ gesture: UITapGestureRecognizer) {
		CommonFunctions.toster(CommonFunctions.localisation(key: "COPIED"))
		let pasteboard = UIPasteboard.general
		pasteboard.string = self.addressCopyLbl.text
	}
	
	@objc func addressOriginImgAction(_ gesture: UITapGestureRecognizer) {
		CommonFunctions.toster(CommonFunctions.localisation(key: "COPIED"))
		let pasteboard = UIPasteboard.general
		pasteboard.string = self.addressOriginNameLbl.text
	}
	
	@objc func dateImgAction(_ gesture: UITapGestureRecognizer) {
		CommonFunctions.toster(CommonFunctions.localisation(key: "COPIED"))
		let pasteboard = UIPasteboard.general
		pasteboard.string = self.dateLbl.text
	}
}

//MARK: - Other functions
extension AddressAddedPopUpVC{
	func handleTypePopUp(){
		if(type == .addressAdded){
			self.headerView.headerLbl.text = editAddress?.name ?? ""
			
			CommonUI.setUpLbl(lbl: self.addressLbl, text: self.editAddress?.address?.addressFormat, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressLbl.numberOfLines = 0
			CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: CommonFunctions.localisation(key: "COPY"), textColor: UIColor.purple_500, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: "\(CommonFunctions.localisation(key: "ADDRESS_ORIGIN"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: CommonFunctions.localisation(key: "DATE_ADDED"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.networkNameLbl, text: editAddress?.network?.uppercased() ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			if editAddress?.exchange == ""{
				self.addressOriginView.isHidden = true
			}
			CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: editAddress?.exchange ?? "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.dateLbl, text: CommonFunctions.getDateFormat(date: self.editAddress?.creationDate ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpButton(btn: self.deleteBtn, text: CommonFunctions.localisation(key: "DELETE"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			CommonUI.setUpButton(btn: self.editBtn, text: CommonFunctions.localisation(key: "EDIT"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			if self.editAddress?.exchange == nil || self.editAddress?.exchange == nil{
				self.addressOriginView.isHidden = true
			}else{
				self.addressOriginNameLbl.text = self.editAddress?.exchange ?? ""
				self.addressOriginView.isHidden = false
			}
			self.toView.isHidden = true
			self.feesPaidView.isHidden = true
		}else if(type == .order){
			self.headerView.headerLbl.text = CommonFunctions.localisation(key: "ORDER")
			
			CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "ORDER_ID"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: self.orderId.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "STATUS"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.networkNameLbl, text: self.status.decoderStatusOrder, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: "\(CommonFunctions.localisation(key: "FROM"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: self.from, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.toLbl, text: CommonFunctions.localisation(key: "TO"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.toNameLbl, text: self.to, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.feesPaidLbl, text: CommonFunctions.localisation(key: "FEES_PAID"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.feesPaidNameLbl, text: self.feesPaid, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: CommonFunctions.localisation(key: "DATE"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.dateLbl, text: CommonFunctions.getDateFormat(date: self.date, inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			self.iconView.isHidden = true
			
		}else if(type == .strategy){
			self.headerView.headerLbl.text = CommonFunctions.localisation(key: "STRATEGY")
			
			CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "EXECUTION_ID"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: self.executionId.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "NAME"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.networkNameLbl, text: self.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: "\(CommonFunctions.localisation(key: "TYPE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: self.typeStrategy, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			self.toView.isHidden = true
			self.feesPaidView.isHidden = true
			self.dateView.isHidden = true
			self.iconView.isHidden = true
			
			self.bottomView.layoutIfNeeded()
			
		}else if(type == .deposit){
			self.headerView.headerLbl.text = CommonFunctions.localisation(key: "DEPOSIT")
			
			CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "TRANSACTION_ID"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: self.transactionId.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "STATUS"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.networkNameLbl, text: self.status.decoderStatusDeposit, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: "\(CommonFunctions.localisation(key: "FROM"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: self.from.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			self.addressOriginImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.toLbl, text: CommonFunctions.localisation(key: "AMOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.toNameLbl, text: self.amount, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.feesPaidLbl, text: CommonFunctions.localisation(key: "NETWORK"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.feesPaidNameLbl, text: self.network, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: CommonFunctions.localisation(key: "TRANSACTION_HASH"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.dateLbl, text: self.transactionHash.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			self.dateLbl.numberOfLines = 0
			self.dateImg.isHidden = false
			
			self.iconView.isHidden = true
			
		}else if(type == .withdraw){
			self.headerView.headerLbl.text = CommonFunctions.localisation(key: "WITHDRAWAL")
			
			CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "TRANSACTION_ID"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressCopyLbl, text: self.transactionId.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.networkLbl, text: CommonFunctions.localisation(key: "STATUS"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.networkNameLbl, text: self.status.decoderStatusWithdraw, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.addressOriginLbl, text: CommonFunctions.localisation(key: "TO"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.addressOriginNameLbl, text: self.to.addressFormat, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			self.addressOriginImg.isHidden = false
			
			CommonUI.setUpLbl(lbl: self.feesPaidLbl, text: CommonFunctions.localisation(key: "AMOUNT"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.feesPaidNameLbl, text: self.amount, textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.dateAddedLbl, text: CommonFunctions.localisation(key: "DATE"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Large.sizeValue()))
			CommonUI.setUpLbl(lbl: self.dateLbl, text: CommonFunctions.getDateFormat(date: self.date, inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
			
			self.toView.isHidden = true
			self.iconView.isHidden = true
		}
	}
	
    func callDeleteApi(){
        self.deleteBtn.showLoading(color: UIColor.PurpleColor)
		addressAddedPopUpVM.deleteAddressApi(network: self.editAddress?.network ?? "", address: self.editAddress?.address ?? "", completion: {[weak self]response in
            self?.deleteBtn.hideLoading()
            self?.dismiss(animated: true)
            self?.deleteCallback?()
        })
    }
}
