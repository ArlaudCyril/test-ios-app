//
//  ProfileVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit
import ExpandableLabel
import NVActivityIndicatorView
class ProfileVC: ViewController {
    //MARK: - Variables
    var imagePicker = UIImagePickerController(),selectedProfile : SelectedProfileVC?
	var headerData : [String] = []
    var transactionData : [Transaction] = []
    var paymentData : [buyDepositeModel] = []
    var AccountData : [SecurityModel] = []
    var securityData : [SecurityModel] = []

    var faceIdEnable = 0
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var emailLbl: UILabel!
    @IBOutlet var profileOuterVw: UIView!
    @IBOutlet var profileInnverVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.callTransactionApi()
    }

    
    override func setUpUI(){

		//Writings
		self.headerData = [CommonFunctions.localisation(key: "TRANSACTION"),CommonFunctions.localisation(key: "PAYMENT_METHOD"),CommonFunctions.localisation(key: "ACCOUNT"),CommonFunctions.localisation(key: "SECURITY"),""]
		self.paymentData = [
			buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "CREDIT_CARD"), subName: "***0103", rightBtnName: "")
		]
		self.AccountData = [SecurityModel(name: CommonFunctions.localisation(key: "NOTIFICATIONS"), desc: ""),SecurityModel(name: CommonFunctions.localisation(key: "LANGUAGE"), desc: "")]
		self.securityData = [SecurityModel(name: CommonFunctions.localisation(key: "STRONG_AUTHENTIFICATION"), desc: CommonFunctions.localisation(key: "DISABLED")),
			SecurityModel(name: CommonFunctions.localisation(key: "CRYPTO_ADRESS_BOOK"), desc: "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "DISABLED"))"),
			SecurityModel(name: CommonFunctions.localisation(key: "CHANGE_PIN"), desc: ""),
			SecurityModel(name: CommonFunctions.localisation(key: "FACE_ID"), desc: "")]
        
		if userData.shared.enableWhiteListing{
			self.securityData[1].desc = "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "ENABLED"))"
		}else{
			self.securityData[1].desc = "\(CommonFunctions.localisation(key: "WHITELISTING")) \(CommonFunctions.localisation(key: "DISABLED"))"
		}
		if userData.shared.strongAuthVerified {
			self.securityData[0].desc = CommonFunctions.localisation(key: "ENABLED")
		}else{
			self.securityData[0].desc = CommonFunctions.localisation(key: "DISABLED")
		}
		
		
		//Views
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: nameLbl, text: userData.shared.firstname, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: emailLbl, text: userData.shared.email, textColor: UIColor.grey877E95 , font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.profileOuterVw.layer.cornerRadius = self.profileOuterVw.layer.bounds.height/2
        self.profileInnverVw.layer.cornerRadius = self.profileInnverVw.layer.bounds.height/2
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.faceIdEnable = userData.shared.faceIdEnabled
        tblView.delegate = self
        tblView.dataSource = self
        
       
		self.nameLbl.text = "\(userData.shared.firstname) \(userData.shared.lastname)"
		self.emailLbl.text = userData.shared.email
		
		//self.profilePic.yy_setImage(with: URL(string: userData.shared.profile_image), placeholder: UIImage(named: "profile"))
		
		if userData.shared.profilePicType == "DEFAULT"{
			self.profilePic.contentMode = .scaleAspectFit
			self.profilePic.image = self.profilePic.image?.roundedImageWithBorder(width: 18, color: UIColor.clear)
		}else{
			self.profilePic.contentMode = .scaleAspectFill
		}
		
		//Interactions
		
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(profileTapped))
        self.profileOuterVw.addGestureRecognizer(profileTap)
    }
}

//MARK: - table view delegates and dataSource
extension ProfileVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if transactionData.count >= 3{
                return 3
            }else{
                return transactionData.count == 0 ? 1: transactionData.count
            }
        }else if section == 1{
            return paymentData.count
        }else if section == 2{
            return AccountData.count
        }else if section == 3{
            return securityData.count
        }else if section == 4{
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
                cell.setUpCell()
                return cell
            }
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePaymentTVC")as! ProfilePaymentTVC
            cell.setUpCell(data: paymentData[indexPath.row], row: indexPath.row,lastIndex: paymentData.count - 1 )
            cell.controller = self
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAccountTVC")as! ProfileAccountTVC
            cell.setUpCell(data: AccountData[indexPath.row], index: indexPath,lastIndex: AccountData.count - 1 )
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAccountTVC")as! ProfileAccountTVC
            cell.setUpCell(data: securityData[indexPath.row], index: indexPath,lastIndex: securityData.count - 1 )
            cell.controller = self
            return cell
        }else if indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLogoutTVC")as! ProfileLogoutTVC
            cell.setUpCell()
            cell.controller = self
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 4{
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
        if indexPath.section == 2{
			if(indexPath.row == 0){
				let vc = NotificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
			}else if(indexPath.row == 1){
				let vc = LanguageVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				self.navigationController?.pushViewController(vc, animated: true)
			}
            
        }
        if indexPath.section == 3{
            if indexPath.row == 0{
                let vc = StrongAuthVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1{
                let vc = CryptoAddressBookVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2{
                /*CommonFunctions.showLoader(self.view)
                ChangePinVM().sendOtpApi(completion: {[]response in
                    CommonFunctions.hideLoader(self.view)
                    if let response = response{
                        print(response)
                        let vc = ChangePinVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                        let nav = UINavigationController(rootViewController: vc)
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    }
                })*/
				let vc = ChangePinVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
				let nav = UINavigationController(rootViewController: vc)
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: true, completion: nil)
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
        let vc = FrequencyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popUpType = .changeProfile
        vc.frequencySelectedCallback = {[weak self] value in
            print(value)
            self?.dismiss(animated: true, completion: nil)
            if value == CommonFunctions.localisation(key: "CAMERA"){
                guard UIImagePickerController.isSourceTypeAvailable(.camera) else{ return}
                self?.selectImageFrom(.camera)
            }else if value == CommonFunctions.localisation(key: "SELECT_FROM_GALLERY"){
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else{ return}
                self?.selectImageFrom(.photoLibrary)
            }else if value == CommonFunctions.localisation(key: "SET_DEFAULT_PICTURES"){
                let vc = DefaultPictureVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - TABLE VIEW OBSERVER
extension ProfileVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.profilePic.yy_setImage(with: URL(string: "\(ApiEnvironment.ImageUrl)\(userData.shared.profile_image)"), placeholder: UIImage(named: "profile"))
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
//        CommonFunction.showLoader(self.view)
        TransactionVM().getAllTransactionsApi(completion: {[]response in
//            CommonFunction.hideLoader(self.view)
            if let response = response{
                print(response)
                self.transactionData = response.transactions ?? []
                self.tblView.reloadData()
            }
        })
    }
    
    func selectImageFrom(_ source: ImageSourcee){
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            switch source {
            case .camera:
                imagePicker.sourceType = .camera
            case .photoLibrary:
                imagePicker.sourceType = .photoLibrary
            }
            present(imagePicker, animated: true, completion: nil)
        }
}

//MARK :- Image Picker Delegates
extension ProfileVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        let vc = SelectedProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.profilePicImg = selectedImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
