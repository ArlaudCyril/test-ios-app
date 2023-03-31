//
//  KYCVerificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 04/07/22.
//

import UIKit

class KYCVerificationVC: ViewController {
    //MARK: - Variables
    var kycVerificationVM = KYCVerificationVM()
    var isKycDone : Bool = false
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var welcometoLyberLbl: UILabel!
    @IBOutlet var verifyYourIdentityLbl: UILabel!
    @IBOutlet var editBtn: PurpleButton!
    @IBOutlet var editView: UIView!
    @IBOutlet var startView: UIView!
    @IBOutlet var startBtn: PurpleButton!
    @IBOutlet var btnVerificationInProgress: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
        CommonFunctions.showLoader(self.view)
        kycVerificationVM.getKYCStatus(completion: { data in
            self.handleKYCStatusData(data:data )
            CommonFunctions.hideLoader(self.view)
        })
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: self.welcometoLyberLbl, text: CommonFunctions.localisation(key: "IDENTITY_VERIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.verifyYourIdentityLbl, text: CommonFunctions.localisation(key: "STEPS_PROTECT_YOU_FROM_FRAUDS_AND_THEFT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.verifyYourIdentityLbl, text: CommonFunctions.localisation(key: "STEPS_PROTECT_YOU_FROM_FRAUDS_AND_THEFT"), lineSpacing: 6, textAlignment: .left)
        CommonUI.setUpButton(btn: self.btnVerificationInProgress, text: CommonFunctions.localisation(key: "VERIFICATION_IN_PROGRESS"), textcolor: UIColor.primaryTextcolor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.startBtn.setTitle(CommonFunctions.localisation(key: "START"), for: .normal)
        self.editBtn.setTitle(CommonFunctions.localisation(key: "EDIT_PERSONAL_DATA"), for: .normal)
        self.editView.isHidden = true
        self.btnVerificationInProgress.isHidden = true
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.startBtn.addTarget(self, action: #selector(startBtnAct), for: .touchUpInside)
        self.editBtn.addTarget(self, action: #selector(editBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension KYCVerificationVC{
    @objc func backBtnAct(){
        if isKycDone{
            userData.shared.isIdentityVerified = true
            userData.shared.dataSave()
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func startBtnAct(){
        self.startBtn.showLoading()
        self.view.isUserInteractionEnabled = false
        kycVerificationVM.startVerifyIdentityApi(completion: {[weak self]data in
            self?.startBtn.hideLoading()
            self?.view.isUserInteractionEnabled = true
            if let data = data {
                let vc = KycWebVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                vc.Ubalurl = data.identification?.identificationURL ?? ""
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        })
//        showAlert()
        
    }
    
    @objc func editBtnAct(){
        let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        vc.isEditData = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - Other functions
extension KYCVerificationVC{
    func handleKYCStatusData(data : KycStatusModel?){
        if data?.isLivenessInitiated == true{
            if data?.kycReview == 2{
                isKycDone = true
                self.verifyYourIdentityLbl.text = "KYC done sucessfully."
                self.startView.isHidden = true
                
                
//                if CoreData.shared.userInfo.profilePic == ""{
//                    let vc = UploadSelfieVC.instantiateFromAppStoryboard(appStoryboard: .Kyc)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }else if CoreData.shared.userInfo.profileVerificationStatus == "In Progress"{
//                    let vc = ProfileVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Main)
//                    vc.screenType = .Verification
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }else{
//                    let vc = TabBarVC.instantiateFromAppStoryboard(appStoryboard: .Tabbar)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
            }else if data?.kycReview == 3{            // kyc rejected
                if data?.kycLevel == 1 || data?.kycLevel == 2 || data?.kycLevel == 3{
                    self.verifyYourIdentityLbl.text = "OOPS! verification failed.\nReason: \(data?.comment ?? "")"
                    self.editView.isHidden = false
                }else{
                    self.verifyYourIdentityLbl.text = "Sorry,but your KYC is rejected."
                }
            }else{                              //kyc review not successful
                //payment done waiting for response
                if data?.isPayinDone == true{
                    self.verifyYourIdentityLbl.text = "Please wait your verification is under progress"
                    btnVerificationInProgress.isHidden = false
                    startView.isHidden = true
                }else{
                    if data?.kycStatus == "processed" && data?.score == 1{
                        self.verifyYourIdentityLbl.text = "Please add €1 to your wallet to complete the KYC process \n International bank Account Number\n\(data?.iban ?? "")"
                        btnVerificationInProgress.isHidden = false
                        startView.isHidden = true
                    }else if data?.kycStatus == "processed" && data?.score == -1{
                        self.verifyYourIdentityLbl.text = "OOPS! verification failed.\nReason: \(data?.comment ?? "")"
                        startBtn.setTitle("Start Again", for: .normal)
                        self.editView.isHidden = false
                    }else if data?.kycStatus == "processed" && data?.score == 0{
                        self.verifyYourIdentityLbl.text = "OOPS! verification failed.\nReason: \(data?.comment ?? "")"
                        startBtn.setTitle("Start Again", for: .normal)
                        self.editView.isHidden = false
                    }else if data?.score == 0 || data?.score == -1{
                        self.verifyYourIdentityLbl.text = "OOPS! verification failed.\nReason: \(data?.comment ?? "")"
                        startBtn.setTitle("Start Again", for: .normal)
                        self.editView.isHidden = false
                    }
                }
            }
        }else{
//            self.editView.isHidden = false
            self.startBtn.setTitle("Verify", for: .normal)
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Verify identity", message: "It will open Ubble link to verify your identity.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
            userData.shared.isIdentityVerified = true
            userData.shared.dataSave()
//            self.dismiss(animated: true, completion: nil)
            let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
          }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
