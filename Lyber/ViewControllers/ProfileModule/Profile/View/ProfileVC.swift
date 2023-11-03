//
//  ProfileVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit
import ExpandableLabel
import NVActivityIndicatorView
class ProfileVC: SwipeGesture {
    //MARK: - Variables
    var imagePicker = UIImagePickerController(),selectedProfile : SelectedProfileVC?
	var headerData : [String] = []
    var transactionData : [Transaction] = []
    var paymentData : [buyDepositeModel] = []
    var AccountData : [SecurityModel] = []
    var securityData : [SecurityModel] = []
	var transactionsLoaded = false

    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var profileOuterVw: UIView!
    @IBOutlet var profileInnverVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var transactionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.callTransactionApi()
    }

    
    override func setUpUI(){

		//Writings
		//self.headerData = [CommonFunctions.localisation(key: "OPERATIONS"),CommonFunctions.localisation(key: "PAYMENT_METHOD"),CommonFunctions.localisation(key: "ACCOUNT"),CommonFunctions.localisation(key: "SECURITY"),""]
		self.headerData = [CommonFunctions.localisation(key: "OPERATIONS"),CommonFunctions.localisation(key: "ACCOUNT"),CommonFunctions.localisation(key: "SECURITY"),""]
		self.paymentData = [
			buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "CREDIT_CARD"), subName: "***0103", rightBtnName: "")
		]
		self.AccountData = [SecurityModel(name: CommonFunctions.localisation(key: "ACTIVITY_LOGS"), desc: ""),SecurityModel(name: CommonFunctions.localisation(key: "LANGUAGE"), desc: ""),SecurityModel(name: CommonFunctions.localisation(key: "EXPORT"), desc: "")]
		self.securityData = [SecurityModel(name: CommonFunctions.localisation(key: "STRONG_AUTHENTIFICATION"), desc: CommonFunctions.localisation(key: "ENABLED_FEMININE")),
			SecurityModel(name: CommonFunctions.localisation(key: "CRYPTO_ADRESS_BOOK"), desc: "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "DISABLED"))"),
			SecurityModel(name: CommonFunctions.localisation(key: "CHANGE_PASSWORD"), desc: ""),
			SecurityModel(name: CommonFunctions.localisation(key: "CHANGE_PIN"), desc: ""),
			SecurityModel(name: CommonFunctions.localisation(key: "CONTACT_FORM"), desc: ""),
			SecurityModel(name: CommonFunctions.localisation(key: "FACE_ID"), desc: ""),
            SecurityModel(name: CommonFunctions.localisation(key: "CLOSE_ACCOUNT"), desc: "")]
            
        
		if userData.shared.extraSecurity == "none"{
			self.securityData[1].desc = "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "DISABLED"))"
		}else{
			self.securityData[1].desc = "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "ENABLED"))"
		}
		if userData.shared.type2FA == "none" {
			self.securityData[0].desc = CommonFunctions.localisation(key: "DISABLED_FEMININE")
		}
		
		
		//Views
        self.headerView.headerLbl.isHidden = true
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        CommonUI.setUpLbl(lbl: nameLbl, text: userData.shared.firstname, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
		self.nameLbl.numberOfLines = 0
        CommonUI.setUpLbl(lbl: emailLbl, text: userData.shared.email, textColor: UIColor.grey877E95 , font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.profileOuterVw.layer.cornerRadius = self.profileOuterVw.layer.bounds.height/2
        self.profileInnverVw.layer.cornerRadius = self.profileInnverVw.layer.bounds.height/2
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        tblView.delegate = self
        tblView.dataSource = self
        
       
		self.nameLbl.text = "\(userData.shared.firstname) \(userData.shared.lastname)"
		self.emailLbl.text = userData.shared.email
	
		
		self.profilePic.contentMode = .scaleAspectFit
		self.profilePic.image = self.profilePic.image?.roundedImageWithBorder(width: 18, color: UIColor.clear)
		self.profilePic.image = UIImage(asset: Assets(rawValue: userData.shared.profile_image) ?? Assets.chick_egg)
		
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        self.profileOuterVw.addGestureRecognizer(profileTap)
    }
}

//MARK: - table view delegates and dataSource
extension ProfileVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if transactionData.count >= 3{
                return 3
            }else{
                return transactionData.count == 0 ? 1: transactionData.count
            }
//        }else if section == 1{
//            return paymentData.count
        }else if section == 1{
            return AccountData.count
        }else if section == 2{
            return securityData.count
        }else if section == 3{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if transactionData.count != 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTransactionTVC")as! ProfileTransactionTVC
                cell.setUpCell(data: transactionData[indexPath.row], row: indexPath.row,lastIndex: transactionData.count >= 3 ? 2 : (transactionData.count - 1) )
                cell.controller = self
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoTransactionTVC")as! NoTransactionTVC
				cell.setUpCell(loaded: self.transactionsLoaded)
                return cell
            }
//        }else if indexPath.section == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePaymentTVC")as! ProfilePaymentTVC
//            cell.setUpCell(data: paymentData[indexPath.row], row: indexPath.row,lastIndex: paymentData.count - 1 )
//            cell.controller = self
//            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAccountTVC")as! ProfileAccountTVC
            cell.setUpCell(data: AccountData[indexPath.row], index: indexPath,lastIndex: AccountData.count - 1 )
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAccountTVC")as! ProfileAccountTVC
            cell.setUpCell(data: securityData[indexPath.row], index: indexPath,lastIndex: securityData.count - 1 )
            cell.controller = self
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLogoutTVC")as! ProfileLogoutTVC
            cell.setUpCell()
            cell.controller = self
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3{
            return UIView()
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTVC")as! ProfileHeaderTVC
            cell.setUpCell(data: headerData[section],section : section)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 4 ? 20 : 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
			if(indexPath.row == 0){
				let vc = NotificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
			}else if(indexPath.row == 1){
				let vc = LanguageVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
			}else if(indexPath.row == 2){
				let vc = ExportVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
			}
        }
        if indexPath.section == 2{
            if indexPath.row == 0{
                let vc = StrongAuthVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                let vc = CryptoAddressBookVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2{
				let vc = ChangePasswordVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 3{
				let vc = ChangePinVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				let nav = UINavigationController(rootViewController: vc)
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: true, completion: nil)
            }else if indexPath.row == 4{
				let vc = ContactFormVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: false)
            }else if indexPath.row == securityData.count - 1{
                self.presentAlertCloseAccount()
            }
        }
    }
}

//MARK: - objective functions
extension ProfileVC{
    @objc func cancelBtnAct(){
		self.navigationController?.popViewController(animated: true)
    }
    
    @objc func profileTapped(){
		let vc = DefaultPictureVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
		self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - TABLE VIEW OBSERVER
extension ProfileVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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

//MARK: - objective functions
extension ProfileVC{
    func callTransactionApi(){
		TransactionVM().getTransactionsApi(limit: 3, offset: 0, completion: {[]response in
            if let response = response{
                self.transactionData = response.data ?? []
				self.transactionsLoaded = true
                self.tblView.reloadData()
            }
        })
    }
    
    func selectImageFrom(_ source: ImageSourcee){
            imagePicker =  UIImagePickerController()
            //imagePicker.delegate = self
            switch source {
            case .camera:
                imagePicker.sourceType = .camera
            case .photoLibrary:
                imagePicker.sourceType = .photoLibrary
            }
            present(imagePicker, animated: true, completion: nil)
        }
    
    func presentAlertCloseAccount(){
        let alert = UIAlertController(title: CommonFunctions.localisation(key: "CLOSE_ACCOUNT"), message: CommonFunctions.localisation(key: "CLOSE_ACCOUNT_MESSAGE"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "CANCEL"), style: .default, handler: {(action : UIAlertAction) in
        }))
        alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "CONFIRM"), style: .default, handler: {_ in
            ConfirmInvestmentVM().userGetOtpApi(action: "close-account", completion: {[weak self]response in
                if response != nil{
                    let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                    vc.typeVerification = userData.shared.type2FA
                    vc.action = "close-account"
                    vc.controller = self ?? ConfirmInvestmentVC()
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

