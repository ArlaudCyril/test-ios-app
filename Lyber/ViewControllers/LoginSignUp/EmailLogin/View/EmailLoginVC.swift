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

class EmailLoginVC: UIViewController {
    //MARK: - Variables
    var email = String() ,password = String()
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextBtnView: UIView!
    @IBOutlet var nextButton: PurpleButton!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    
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
}
//MARK: - SetUpUI
extension EmailLoginVC{
    func setUpUI(){
        //        self.hideKeyboardWhenTappedAround()
        self.headerView.headerLbl.isHidden = true
        self.collView.delegate = self
        self.collView.dataSource = self
//        indicatorView = [indicator1,indicator2,indicator3,indicator4,indicator5]
//        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3,indicatorViewsWidth4,indicatorViewsWidth5]
        self.collView.layer.cornerRadius = 32
        self.collView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        self.setIndicatorViews()
        self.nextButton.setTitle(L10n.Next.description, for: .normal)
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension EmailLoginVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmailLoginCVC", for: indexPath as IndexPath) as! EmailLoginCVC
            cell.controller = self
            cell.setUpUI()
            IQKeyboardManager.shared.shouldResignOnTouchOutside = true
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
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnAct(){
        self.checkValidationOnEmail()
        //        collView.reloadData()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]as? NSValue)?.cgRectValue{
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
//                    userData.shared.fromSignUpData(response)
                    userData.shared.accessToken = response.data?.token ?? ""
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
                                userData.shared.is_push_enabled = 1
                                userData.shared.isIdentityVerified = true
                                userData.shared.accessToken = response.data?.accessToken ?? ""
                                userData.shared.refreshToken = response.data?.refreshToken ?? ""
                                userData.shared.time = Date()
                                userData.shared.dataSave()
//                                let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                                let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//                                vc.fromLoginScreen = true
//                                vc.email = self?.email ?? ""
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        })
                    }catch{
                        print("error")
                    }
                }
            })
        }
            
//                    let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//                    vc.fromLoginScreen = true
//                    vc.email = response.user?.email ?? ""
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
            
        
    }
}
