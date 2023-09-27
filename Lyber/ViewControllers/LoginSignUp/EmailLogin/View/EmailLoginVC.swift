//
//  EmailLoginVC.swift
//  Lyber
//
//  Created by sonam's Mac on 04/08/22.
//

import UIKit
import IQKeyboardManagerSwift
import BigNum
import CryptoKit
import SwiftySRP

class EmailLoginVC: ViewController {
    //MARK: - Variables
    var email = String() ,password = String(), enteredPin = String()
    var currentPage : Int? = 0
    var emailLoginCVC : EmailLoginCVC?
    //MARK: - IB OUTLETS
    @IBOutlet var headerVw: HeaderView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextBtnView: UIView!
    @IBOutlet var nextButton: PurpleButton!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    
    var indicatorView : [UIView]!
    var indicatorViewsWidth : [NSLayoutConstraint]!
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
        self.navigationController?.navigationBar.isHidden = true
        setUpUI()
    }
	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerVw.headerLbl.isHidden = true
        self.collView.delegate = self
        self.collView.dataSource = self
        self.collView.layer.cornerRadius = 32
        self.collView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        self.headerVw.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
        
        indicatorView = [indicator1,indicator2,indicator3,indicator4,indicator5]
        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3,indicatorViewsWidth4,indicatorViewsWidth5]
        self.setIndicatorViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        collView.reloadData()
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension EmailLoginVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmailLoginCVC", for: indexPath as IndexPath) as! EmailLoginCVC
            cell.controller = self
            cell.setUpUI()
			self.emailLoginCVC = cell
            if currentPage == 0{
                DispatchQueue.main.async {
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = true
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        
        }else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createPinCVC", for: indexPath as IndexPath) as! createPinCVC
            cell.setUpUI()
            cell.pinCreatedDelegate = {[]pin in
                self.enteredPin = pin
                self.GotoNextIndex()
            }
            if currentPage == 1{
                DispatchQueue.main.async {
                    cell.pinTF1.becomeFirstResponder()
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = false
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmPinCVC", for: indexPath as IndexPath) as! ConfirmPinCVC
            cell.setUpUI(verifyPin : true)
            cell.pinConfirmDelegate = {[]pin in
                
                if self.enteredPin != pin{
                    CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
                }else{
                    self.setLoginPin(enteredPin: pin)
                }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //        collView.reloadData()
    }
}

//MARK: - objective functions
extension EmailLoginVC{
    @objc func backBtnAct(){
		if self.currentPage ?? 0 == 0{
			self.navigationController?.popToViewController(ofClass: LoginVC.self)
		}else{
			let indexPath = NSIndexPath(item: (currentPage ?? 0) - 1, section: 0)
			self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
		}
    }
    
    @objc func nextBtnAct(){
        self.checkValidationOnEmail()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
		if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue) != nil{
//            self.stackViewBottomConst.constant = keyboardSize.height + 12
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        stackViewBottomConst.constant = 12
    }
}

//MARK: - Other functions
extension EmailLoginVC{
    func checkValidationOnEmail(){
        if self.email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster(Constants.AlertMessages.enterEmail)
        }else if email.isValidEmail() == false{
            CommonFunctions.toster(Constants.AlertMessages.enterValidEmail)
        }else if password.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster(Constants.AlertMessages.enterPassword)
        }else{
            self.nextButton.showLoading()
            EnterPhoneVM().logInChallengeApi(email: self.email, completion: { [weak self] response in
                self?.nextButton.hideLoading()
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
                        let clientSharedSecret = try client.calculateSharedSecret(username: self?.email ?? "", password: self?.password ?? "", salt: salt.bytes, clientKeys: clientKeys, serverPublicKey: spk)
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
                                    self?.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
                                }else{
                                    let vc = VerificationVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                                    vc.typeVerification = response.data?.type2FA
									vc.controller = self
									self?.present(vc, animated: true)
                                }
							}else{
								self?.emailLoginCVC?.passwordTF.text = ""
							}
                        })
                    }catch{
                        print("error")
                    }
                }
            })
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
            //already login cause email login vc so if notifications activated : go to portfolio
            if userData.shared.is_push_enabled != 0{
				let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.GotoNextIndex()
            }
        }))
        alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "ACTIVATE"), style: .default, handler: {_ in
			//already login cause email login vc so if notifications activated : go to portfolio
			if userData.shared.is_push_enabled != 0{
				let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
				self.navigationController?.pushViewController(vc, animated: true)
			}else{
				self.GotoNextIndex()
			}
        }))
        present(alert, animated: true, completion: nil)
    }
    
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
			
			if self.currentPage ?? 0 == 0{
				self.nextBtnView.isHidden = false
			}else if self.currentPage ?? 0 == 1{
				self.nextBtnView.isHidden = true
			}
			self.headerVw.backBtn.setImage(Assets.back.image(), for: .normal)
            
        }
    }
}

//MARK: - SCROLLVIEW DELEGATES FUNTION
extension EmailLoginVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x + scrollView.frame.width/2)/scrollView.frame.width
        if Int(value) != self.currentPage{
            self.currentPage = (Int(value))
            self.setIndicatorViews()
        }
        collView.reloadData()
    }
}
