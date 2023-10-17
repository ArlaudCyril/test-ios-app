//
//  EnterPhoneVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import JWTDecode
import BigNum
import CryptoKit
import LocalAuthentication

class EnterPhoneVC: ViewController {
    //MARK: - Variables
    var verifyPin = false
    var enterPhoneVM = EnterPhoneVM()
    var phoneNumber = String() ,password = String(), countryCode = "+33", enteredPin = String(), email = String(), emailPassword = String()
    var currentPage : Int? = 0
    var indicatorView : [UIView]!
    var indicatorViewsWidth : [NSLayoutConstraint]!
	var isDoubleAuthentified = false
	var enterNumberCVC : enterNumberCVC?
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerVw: HeaderView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextBtnView: UIView!
    @IBOutlet var nextButton: PurpleButton!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    @IBOutlet var collViewBtmconst: NSLayoutConstraint!
    @IBOutlet var viewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var viewTopConst: NSLayoutConstraint!
    
    @IBOutlet var indicator1: UIView!
    @IBOutlet var indicator2: UIView!
    @IBOutlet var indicator3: UIView!
    @IBOutlet var indicator4: UIView!
    @IBOutlet var indicator5: UIView!
    @IBOutlet var indicatorViewsWidth1: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth2: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth3: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth4: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth5: NSLayoutConstraint!
    
	override func viewDidLoad() {
		super.viewDidLoad()
		IQKeyboardManager.shared.enable = false
		setUpUI()
		if(GlobalVariables.isRegistering == true){
			if userData.shared.enterPhoneStepComplete == 1{
				DispatchQueue.main.async {
					let indexPath = NSIndexPath(item: 1, section: 0)
					self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
				}
			}
			else if(userData.shared.enterPhoneStepComplete == 2){
				DispatchQueue.main.async {
					let indexPath = NSIndexPath(item: 2, section: 0)
					self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
				}
			}
		}else if(GlobalVariables.isLogin == true){
			if(self.isDoubleAuthentified == true){
				DispatchQueue.main.async {
					let indexPath = NSIndexPath(item: 2, section: 0)
					self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
				}
			}
		}
		
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func setUpUI(){
        //        self.hideKeyboardWhenTappedAround()
        self.headerVw.headerLbl.isHidden = true
		self.headerVw.backBtn.setImage(Assets.back.image(), for: .normal)
		
		let EmailAddressNib : UINib =  UINib(nibName: "EmailAddressXib", bundle: nil)
		self.collView.register(EmailAddressNib, forCellWithReuseIdentifier: "emailAddressCVC")
		
        self.collView.delegate = self
        self.collView.dataSource = self
        indicatorView = [indicator1,indicator2,indicator3,indicator4,indicator5]
        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3,indicatorViewsWidth4,indicatorViewsWidth5]
        self.collView.layer.cornerRadius = 32
        self.collView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.setIndicatorViews()
        self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        self.headerVw.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
		
        self.headerVw.closeBtn.addTarget(self, action: #selector(closeBtnAct), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension EnterPhoneVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enterNumberCVC", for: indexPath as IndexPath) as! enterNumberCVC
            cell.controller = self
            cell.setUpUI()
			self.enterNumberCVC = cell
            if currentPage == 0{
                DispatchQueue.main.async {
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
                }
            }else{
                cell.endEditing(true)
            }
            return cell
		}else if indexPath.item == 1{
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emailAddressCVC", for: indexPath as IndexPath) as! emailAddressCVC
			cell.controller = self
			return cell
		}else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createPinCVC", for: indexPath as IndexPath) as! createPinCVC
            cell.setUpUI()
            cell.pinCreatedDelegate = {[]pin in
                self.enteredPin = pin
                self.GotoNextIndex()
            }
            if currentPage == 2{
				DispatchQueue.main.async {
					cell.pinTF1.becomeFirstResponder()
					IQKeyboardManager.shared.shouldResignOnTouchOutside = false
				}
            }else{
                cell.endEditing(true)
            }
            return cell
        }else if indexPath.item == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmPinCVC", for: indexPath as IndexPath) as! ConfirmPinCVC
            cell.setUpUI(verifyPin : verifyPin)
            cell.pinConfirmDelegate = {[]pin in
				
				if userData.shared.logInPinSet != 0{
					if userData.shared.logInPinSet != Int(pin){
						CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
					}else{
						let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
						self.navigationController?.pushViewController(vc, animated: true)
					}
				}else{
					if self.enteredPin != pin{
						CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
						cell.pinTF1.becomeFirstResponder()
					}else{
						self.setLoginPin(enteredPin: pin)
					}
				}
				
                
            }
            
            if currentPage == 3{
                DispatchQueue.main.async {
                    cell.pinTF1.becomeFirstResponder()
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = false
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        }else if indexPath.item == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enableNotificationCVC", for: indexPath as IndexPath) as! enableNotificationCVC
            cell.setUpUI()
            cell.delegate = self
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.layer.bounds.width, height: collView.layer.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
}

//MARK: - objective functions
extension EnterPhoneVC{
    @objc func backBtnAct(){
		if self.currentPage ?? 0 == 0{
			self.navigationController?.popToViewController(ofClass: LoginVC.self)
		}else{
            let indexPath = NSIndexPath(item: (currentPage ?? 0) - 1, section: 0)
            self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        }
    }
	
	@objc func closeBtnAct(){
		CommonFunctions.stopRegistration()
    }
    
    @objc func nextBtnAct(){
		if(currentPage == 0){
			self.checkValidationOnPhoneNumber()
		}else if currentPage == 1{
			checkEmailAddressValidation()
		}
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
		if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue) != nil{
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        stackViewBottomConst.constant = 12
    }
}

//MARK: - SCROLLVIEW DELEGATES FUNTION
extension EnterPhoneVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x + scrollView.frame.width/2)/scrollView.frame.width
        if Int(value) != self.currentPage{
            self.currentPage = (Int(value))
            self.setIndicatorViews()
        }
        collView.reloadData()
    }
}

//MARK: - OTHER FUNCTION
extension EnterPhoneVC{
    
    func GotoNextIndex(){
        let indexPath = NSIndexPath(item: (self.currentPage ?? 0) + 1, section: 0)
        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
    }
    
    func setIndicatorViews(){
        for (num,vw) in indicatorView.enumerated(){
            vw.layer.cornerRadius = 2
            if num == self.currentPage{
                vw.backgroundColor = UIColor.PurpleColor
                self.indicatorViewsWidth[num].constant = 32
            }else{
                vw.backgroundColor = UIColor.PurpleColor.withAlphaComponent(0.2)
                self.indicatorViewsWidth[num].constant = 4
            }
			if(GlobalVariables.isRegistering){
				self.headerVw.closeBtn.isHidden = false
			}
			
			self.headerVw.backBtn.isHidden = true
			if self.currentPage ?? 0 == 0{
				self.nextBtnView.isHidden = false
				self.headerVw.backBtn.isHidden = false
			}else if self.currentPage ?? 0 == 2{
				self.nextBtnView.isHidden = true
			}else if self.currentPage ?? 0 == 3{
				self.headerVw.backBtn.isHidden = false
			}
        }
    }
    
    func checkValidationOnPhoneNumber(){
        if phoneNumber == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterPhoneNumber)
        }else if phoneNumber.count < 7 {
            CommonFunctions.toster(Constants.AlertMessages.enterValidPhoneNumber)
        }else{
			if GlobalVariables.isLogin == false{
                self.nextButton.isUserInteractionEnabled = false
                self.nextButton.showLoading()
                self.enterPhoneVM.SignUpApi(phoneNumber: self.phoneNumber, countryCode: self.countryCode, completion: { [weak self] response in
                    self?.nextButton.hideLoading()
                    self?.nextButton.isUserInteractionEnabled = true
                    if let response = response{
                        userData.shared.registrationToken = response.data?.token ?? ""
                        userData.shared.phone_no = self?.phoneNumber ?? ""
                        userData.shared.time = Date()
                        userData.shared.dataSave()
						let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
						vc.typeVerification = "phone"
						vc.action = "signup"
						vc.controller = self
						self?.present(vc, animated: true)
                    }
                })
            }else if GlobalVariables.isLogin == true{
                if self.password == ""{
                    CommonFunctions.toster(Constants.AlertMessages.enterPassword)
                }else{
                    self.nextButton.isUserInteractionEnabled = false
                    self.nextButton.showLoading()
					self.enterPhoneVM.logInWithPhoneChallengeApi(phoneNumber: self.phoneNumber.phoneFormat, countryCode: self.countryCode, completion: { [weak self] response in
                        self?.nextButton.hideLoading()
                        self?.nextButton.isUserInteractionEnabled = true
                        if let response = response{
                            userData.shared.userToken = response.data?.token ?? ""
                            userData.shared.dataSave()
                            let serverPublicKey = BigNum.init(response.data?.b ?? "")!
                            let salt = BigNum.init(response.data?.salt ?? "")!
                            let configuration = SRPConfiguration<SHA512>(.N2048)
                            let client = SRPClient(configuration: configuration)
                            let clientKeys = client.generateKeys()
                            let spk = SRPKey(serverPublicKey)
                            
                            do{
								
								let clientSharedSecret = try client.calculateSharedSecret(username: "\(self?.countryCode.dropFirst() ?? "")\(self?.phoneNumber.phoneFormat ?? "")", password: self?.password ?? "", salt: salt.bytes, clientKeys: clientKeys, serverPublicKey: spk)
                                let clientProof = client.calculateSimpleClientProof(clientPublicKey: clientKeys.public, serverPublicKey: spk, sharedSecret: clientSharedSecret)
                                EnterPhoneVM().logInApi(A: BigNum(bytes: clientKeys.public.bytes).dec, M1: BigNum(bytes: clientProof).dec, method: "srp", completion: {[weak self] response in
                                    if let response = response{
                                        if(response.data?.accessToken != nil){
                                            userData.shared.userToken = response.data?.accessToken ?? ""
                                            userData.shared.refreshToken = response.data?.refreshToken ?? ""
                                            userData.shared.time = Date()
                                            userData.shared.dataSave()
                                            self?.nextBtnView.isHidden = true
                                            let indexPath = NSIndexPath(item: (self?.currentPage ?? 0) + 1, section: 0)
                                            self?.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
										}else{
                                            let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                                            vc.typeVerification = response.data?.type2FA
											vc.controller = self
											self?.present(vc, animated: true)
                                        }
									}else{
										self?.enterNumberCVC?.passwordTF.text = ""
									}
                                })
                            }catch{
                                print("error")
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func setLoginPin(enteredPin : String){
        userData.shared.logInPinSet = Int(enteredPin) ?? 0
        userData.shared.dataSave()
        self.showActiveFaceIdAlert()
    }
    
    func showActiveFaceIdAlert(){
        let alert = UIAlertController(title: CommonFunctions.localisation(key: "ACTIVATE_FACE_ID"), message: CommonFunctions.localisation(key: "ACCESS_LYBER_FACE_ID"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "DECLINE"), style: .default, handler: {(action : UIAlertAction) in
			
			userData.shared.faceIdEnabled = false
			userData.shared.dataSave()
			
			self.GotoNextIndex()
        }))
        alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "ACTIVATE"), style: .default, handler: {_ in
			let localAuthenticationContext = LAContext()
			localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
			let authType = localAuthenticationContext.biometryType
			if(authType == .faceID){
				userData.shared.faceIdEnabled = true
				userData.shared.dataSave()
			}else{
				CommonFunctions.toster(CommonFunctions.localisation(key: "DEVICE_NOT_SUPPORT_REGISTERED_FACEID"))
				userData.shared.faceIdEnabled = false
				userData.shared.dataSave()
			}
			
			self.GotoNextIndex()
        }))
        present(alert, animated: true, completion: nil)
    }
	
	func checkEmailAddressValidation(){
		if self.email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
			CommonFunctions.toster(Constants.AlertMessages.enterEmail)
		}else if email.isValidEmail() == false{
			CommonFunctions.toster(Constants.AlertMessages.enterValidEmail)
		}else if self.emailPassword == ""{
			CommonFunctions.toster(Constants.AlertMessages.enterPassword)
		}else if emailPassword.count < 8{
			CommonFunctions.toster(Constants.AlertMessages.enterValidPassword)
		}else{
			self.nextButton.showLoading()
			self.nextButton.isUserInteractionEnabled = false
			PersonalDataVM().sendVerificationEmailApi(email: self.email,password : self.emailPassword, completion: {[weak self]response in
				self?.nextButton.hideLoading()
				userData.shared.email = self?.email ?? ""
				userData.shared.dataSave()
				self?.nextButton.isUserInteractionEnabled = true
				if response != nil{
					let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
					vc.typeVerification = "email"
					vc.action = "signup_email"
					vc.enterPhoneController = self
					self?.present(vc, animated: true)
				}
			})
		}
	}
}
