//
//  CryptoAddressBookVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit
import IQKeyboardManagerSwift

class CryptoAddressBookVC: SwipeGesture {
    //MARK: - Variables
    var cryptoAddressBookVM = CryptoAddressBookVM()
    var cryptoAddressArray : [Address] = []
    var cryptoAddressArrayFiltered : [Address] = []
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var topAddressView: UIView!
    @IBOutlet var addressBookLbl: UILabel!
    @IBOutlet var addressBookDescLbl: UILabel!
    @IBOutlet var whitlistingView: UIView!
    @IBOutlet var whitlistingLbl: UILabel!
    @IBOutlet var activeDuringLbl: UILabel!
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var addAddressView: UIView!
    @IBOutlet var addNewAddressBtn: UIButton!
//    @IBOutlet var timeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enableAutoToolbar = true
        setUpUI()
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
		self.getWithdrawalAdresses()
		self.searchTF.text = ""
		self.setUpUI()
		self.tblView.reloadData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tblView.removeObserver(self, forKeyPath: "contentSize")
	}
	
	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
		self.searchTF.placeholder = CommonFunctions.localisation(key: "SEARCH")
        CommonUI.setUpLbl(lbl: self.addressBookLbl, text: CommonFunctions.localisation(key: "CRYPTO_ADRESS_BOOK"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressBookDescLbl, text: CommonFunctions.localisation(key: "ADDRESS_BOOK_ALLOW_CRYPTOCURRENCY"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.addressBookDescLbl, text: CommonFunctions.localisation(key: "ADDRESS_BOOK_ALLOW_CRYPTOCURRENCY"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpViewBorder(vw: self.whitlistingView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.whitlistingLbl, text: CommonFunctions.localisation(key: "WITHDRAWAL_SECURITY_SETTINGS"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.activeDuringLbl, text: "\(CommonFunctions.localisation(key: "SECURITY")) : 72H", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: searchView, radius: 12, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.searchTF.delegate = self
        
        CommonUI.setUpViewBorder(vw: addAddressView, radius: 32, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        self.addAddressView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        CommonUI.setUpButton(btn: self.addNewAddressBtn, text: CommonFunctions.localisation(key: "ADD_NEW_ADRESS"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
		if userData.shared.extraSecurity == "1d"{
			let attributedText = NSMutableAttributedString(string: "\(CommonFunctions.localisation(key: "ACTIVE_DURING")) : 24H")
			let range = (attributedText.string as NSString).range(of: "24H")
			attributedText.addAttribute(.foregroundColor, value: UIColor.Green_500, range: range)
			self.activeDuringLbl.attributedText = attributedText
			
		}else if userData.shared.extraSecurity == "3d"{
			let attributedText = NSMutableAttributedString(string: "\(CommonFunctions.localisation(key: "ACTIVE_DURING")) : 72H")
			let range = (attributedText.string as NSString).range(of: "72H")
			attributedText.addAttribute(.foregroundColor, value: UIColor.Green_500, range: range)
			self.activeDuringLbl.attributedText = attributedText
			
		}else if userData.shared.extraSecurity == "none"{
			self.activeDuringLbl.text = CommonFunctions.localisation(key: "NO_SECURITY")
        }
        
        self.searchTF.addTarget(self, action: #selector(searchtextChanged), for: .editingChanged)
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.addNewAddressBtn.addTarget(self, action: #selector(addNewAddressBtnAct), for: .touchUpInside)
		

		let whitlistingTap = UITapGestureRecognizer(target: self, action: #selector(whitelistingBtnAct))
		self.whitlistingView.addGestureRecognizer(whitlistingTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension CryptoAddressBookVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoAddressArrayFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoAddressesTVC", for: indexPath) as! CryptoAddressesTVC
        cell.configureWithData(data : cryptoAddressArrayFiltered[indexPath.row])
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.controller = self
		vc.editAddress = cryptoAddressArrayFiltered[indexPath.row]
        self.present(vc, animated: true, completion: nil)
        vc.deleteCallback = {[] in
            self.getWithdrawalAdresses()
            self.tblView.reloadData()
        }
    }
}

//MARK: - objective functions
extension CryptoAddressBookVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.3, animations: nil, completion: {_ in
            topAddressView.isHidden = true
//        })
       
    }
    
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchtextChanged(){
        if searchTF.text != ""{
            topAddressView.isHidden = true
			cryptoAddressArrayFiltered = cryptoAddressArray.filter({
				$0.name.lowercased().hasPrefix(searchTF.text?.lowercased() ?? "") ||
				$0.address?.lowercased().hasPrefix(searchTF.text?.lowercased() ?? "") ?? false
				
			})
        }else{
            topAddressView.isHidden = false
			cryptoAddressArrayFiltered = cryptoAddressArray
			
        }
		
		self.tblView.reloadData()
    }
    
    @objc func addNewAddressBtnAct(){
		let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func whitelistingBtnAct(sender : UIButton){
            let vc = EnableWhitelistingVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.timeCallBack = {[weak self]response in
                if response?.id == 1{               //72Hour
					let attributedText = NSMutableAttributedString(string: "\(CommonFunctions.localisation(key: "ACTIVE_DURING")) : 72H")
					let range = (attributedText.string as NSString).range(of: "72H")
					attributedText.addAttribute(.foregroundColor, value: UIColor.Green_500, range: range)
					self?.activeDuringLbl.attributedText = attributedText
                }else if response?.id == 2{         //24 Hour
					let attributedText = NSMutableAttributedString(string: "\(CommonFunctions.localisation(key: "ACTIVE_DURING")) : 24H")
					let range = (attributedText.string as NSString).range(of: "24H")
					attributedText.addAttribute(.foregroundColor, value: UIColor.Green_500, range: range)
					self?.activeDuringLbl.attributedText = attributedText
                }else{                              //No Extra Secuirty
                    self?.activeDuringLbl.text = CommonFunctions.localisation(key: "NO_SECURITY")
                }

            }
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        topAddressView.isHidden = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        topAddressView.isHidden = false
    }
}

//MARK: - Other functions
extension CryptoAddressBookVC{
    func getWithdrawalAdresses(){
        cryptoAddressBookVM.getWithdrawalAdressAPI(completion: {[weak self]response in
            if let response = response {
                self?.cryptoAddressArray = response.data ?? []
                self?.cryptoAddressArrayFiltered = response.data ?? []
                self?.tblView.reloadData()
            }
        })
    }
}

// MARK: - TABLE VIEW OBSERVER
extension CryptoAddressBookVC{
      
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if let obj = object as? UITableView {
          if obj == self.tblView && keyPath == "contentSize" {
            if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
              self.tblViewHeightConst.constant = newSize.height
            }
          }
      }
    }
}
