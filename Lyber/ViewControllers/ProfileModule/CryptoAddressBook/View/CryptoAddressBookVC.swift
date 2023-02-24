//
//  CryptoAddressBookVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit
import IQKeyboardManagerSwift

class CryptoAddressBookVC: UIViewController {
    //MARK: - Variables
    var cryptoAddressBookVM = CryptoAddressBookVM()
    var whiteListAddress : [Address] = []
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var topAddressView: UIView!
    @IBOutlet var addressBookLbl: UILabel!
    @IBOutlet var addressBookDescLbl: UILabel!
    @IBOutlet var whitlistingView: UIView!
    @IBOutlet var whitlistingLbl: UILabel!
    @IBOutlet var activeDuringLbl: UILabel!
    @IBOutlet var whitlistingBtn: UISwitch!
    
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
    
}

//MARK: - SetUpUI
extension CryptoAddressBookVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.addressBookLbl, text: L10n.CryptoAdressBook.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressBookDescLbl, text: L10n.viewAndAddfavouriteCryptoAddressesHere.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.addressBookDescLbl, text: L10n.viewAndAddfavouriteCryptoAddressesHere.description, lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpViewBorder(vw: self.whitlistingView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.whitlistingLbl, text: L10n.Whitelisting.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.activeDuringLbl, text: "\(L10n.Security.description) : 72H", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.activeDuringLbl.isHidden = true
        
        CommonUI.setUpViewBorder(vw: searchView, radius: 12, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.searchTF.delegate = self
        
        CommonUI.setUpViewBorder(vw: addAddressView, radius: 32, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        self.addAddressView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        CommonUI.setUpButton(btn: self.addNewAddressBtn, text: L10n.AddNewAdress.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if userData.shared.enableWhiteListing {
            self.whitlistingBtn.isOn = true
            self.activeDuringLbl.isHidden = false
            if userData.shared.extraSecurity == "24_HOURS"{
                self.activeDuringLbl.text = "\(L10n.Security.description) : 24H"
            }else if userData.shared.extraSecurity == "72_HOURS"{
                self.activeDuringLbl.text = "\(L10n.Security.description) : 72H"
            }else if userData.shared.extraSecurity == "NO_EXTRA_SECURITY"{
                self.activeDuringLbl.text = "\(L10n.Security.description) : No Security"
            }
        }else{
            self.whitlistingBtn.isOn = false
            self.activeDuringLbl.isHidden = true
        }
        
//
//        if self.whitlistingBtn.isOn{
//            self.timeBtn.isHidden = false
//        }else{
//            self.timeBtn.isHidden = true
//        }
        
        self.searchTF.addTarget(self, action: #selector(searchtextChanged), for: .editingChanged)
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.addNewAddressBtn.addTarget(self, action: #selector(addNewAddressBtnAct), for: .touchUpInside)
        self.whitlistingBtn.addTarget(self, action: #selector(whitelistingBtnAct), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension CryptoAddressBookVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whiteListAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoAddressesTVC", for: indexPath) as! CryptoAddressesTVC
        cell.configureWithData(data : whiteListAddress[indexPath.row])
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddressAddedPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.addressBookController = self
        vc.popUpType = .detailAddress
        vc.addressId = whiteListAddress[indexPath.row].id ?? ""
        self.present(vc, animated: true, completion: nil)
        vc.deleteCallback = {[] in
            self.getWhiteListedAddreses()
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            cell.alpha = 1
        })
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
        }else{
            topAddressView.isHidden = false
        }
        cryptoAddressBookVM.getWhiteListingAddressApi(searchText: searchTF.text, completion: {[weak self]response in
            if let response = response {
                self?.whiteListAddress = response.addresses ?? []
                self?.tblView.reloadData()
            }
        })
    }
    
    @objc func addNewAddressBtnAct(){
        if userData.shared.enableWhiteListing == false {
            CommonFunctions.toster(Constants.AlertMessages.PleaseEnableWhitelistingAddress)
        }else{
            let vc = AddCryptoAddressVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func whitelistingBtnAct(sender : UISwitch){
//        if sender.isOn == true{
//            print("on")
            let vc = EnableWhitelistingVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.timeCallBack = {[weak self]response in
                self?.whitlistingBtn.isOn = true
                self?.activeDuringLbl.isHidden = false
                if response?.id == 1{               //72Hour
                    self?.activeDuringLbl.text = "\(L10n.Security.description) : 72H"
                }else if response?.id == 2{         //24 Hour
                    self?.activeDuringLbl.text = "\(L10n.Security.description) : 24H"
                }else{                              //No Extra Secuirty
                    self?.activeDuringLbl.text = "\(L10n.Security.description) : No Security"
                }
//                self?.timeBtn.isHidden = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            print("off")
//
//        }
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
    func getWhiteListedAddreses(){
        cryptoAddressBookVM.getWhiteListingAddressApi(searchText: searchTF.text, completion: {[weak self]response in
            if let response = response {
                self?.whiteListAddress = response.addresses ?? []
                self?.tblView.reloadData()
            }
        })
    }
}

// MARK: - TABLE VIEW OBSERVER
extension CryptoAddressBookVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      self.getWhiteListedAddreses()
        self.searchTF.text = ""
      self.setUpUI()
      self.tblView.reloadData()
    }
      
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.tblView.removeObserver(self, forKeyPath: "contentSize")
    }
      
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
