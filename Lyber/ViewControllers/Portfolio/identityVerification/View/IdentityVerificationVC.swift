//
//  IdentityVerificationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/06/22.
//

import UIKit
import AVKit
import JWTDecode

class IdentityVerificationVC: ViewController {
    //MARK: - Variables
    var imagePicker = UIImagePickerController()
    var IDProofImage : UIImage? = nil
    var SelfiePic : UIImage? = nil
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var verificationLbl: UILabel!
    @IBOutlet var verificationDescLbl: UILabel!
    
    @IBOutlet var takePictureView: UIView!
    @IBOutlet var takePictureLbl: UILabel!
    @IBOutlet var idPassportLbl: UILabel!
    @IBOutlet var firstBtn: UIButton!
    
    @IBOutlet var takeSelfieView: UIView!
    @IBOutlet var takeSelfieLbl: UILabel!
    @IBOutlet var secondBtn: UIButton!
    @IBOutlet var OpenCameraBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        do {
            var token = try decode(jwt: userData.shared.userToken)
        } catch {
            print(error)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IDProofImage != nil{
            self.uploadDocumentComplete()
        }
        if SelfiePic != nil{
            self.uploadSelfieComplete()
            
        }
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        headerView.backBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.verificationLbl, text: CommonFunctions.localisation(key: "IDENTITY_VERIFICATION"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.verificationDescLbl, text: CommonFunctions.localisation(key: "STEPS_PROTECT_YOU_FROM_FRAUDS_AND_THEFT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.verificationDescLbl, text: CommonFunctions.localisation(key: "STEPS_PROTECT_YOU_FROM_FRAUDS_AND_THEFT"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.takePictureLbl, text: CommonFunctions.localisation(key: "TAKE_PICTURE_OF_YOUR_PAPERS"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.idPassportLbl, text: CommonFunctions.localisation(key: "NATIONAL_ID_CARD_PASSPORT_OR_DRIVING_LICENSE"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.idPassportLbl, text: CommonFunctions.localisation(key: "NATIONAL_ID_CARD_PASSPORT_OR_DRIVING_LICENSE"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.takeSelfieLbl, text: CommonFunctions.localisation(key: "TAKE_A_SELFIE"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.OpenCameraBtn.setTitle(CommonFunctions.localisation(key: "START_VERIFICATION"), for: .normal)
        let btns = [firstBtn,secondBtn]
        for btn in btns {
            btn?.layer.cornerRadius = (btn?.layer.bounds.height ?? 0)/2
            btn?.titleLabel?.font = UIFont.MabryProMedium(Size.Medium.sizeValue())
            btn?.backgroundColor = UIColor.greyColor
            btn?.setTitleColor(UIColor.grey877E95, for: .normal)
        }
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.OpenCameraBtn.addTarget(self, action: #selector(OpenCameraBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension IdentityVerificationVC{
    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func OpenCameraBtnAct(){
//        if OpenCameraBtn.tag == 0{
//            if IDProofImage == nil{
//    //            imagePicker.cameraDevice = .rear
//            }else{
//                imagePicker.cameraDevice = .front
//            }
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: true, completion: nil)
//        }else{
//            userData.shared.isIdentityVerified = true
//            userData.shared.dataSave()
//            self.dismiss(animated: true, completion: nil)
//        }
        
        if OpenCameraBtn.tag == 0{
            showAlert()
        }else{
            userData.shared.isIdentityVerified = true
            userData.shared.dataSave()
            let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .fullScreen
            navController.navigationBar.isHidden = true
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func shoWAlertToChangeCameraSettings(){
        let alert = UIAlertController(title: "Camera Settings", message: "Please adjust your device settings to grant access to camera use.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
            DispatchQueue.main.async {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(settingsURL)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        return
    }
}

//MARK: - UiImagePicker Delegate
extension IdentityVerificationVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        if IDProofImage == nil{
            IDProofImage = selectedImage
        }else {
            SelfiePic = selectedImage
        }
    }
}

//MARK: - Other functions
extension IdentityVerificationVC{
    func uploadDocumentComplete(){
        CommonUI.StrikeThroughLabel(lbl: takePictureLbl, textcolor: UIColor.grey877E95)
        CommonUI.StrikeThroughLabel(lbl: idPassportLbl, textcolor: UIColor.grey877E95)
        self.firstBtn.setTitle("", for: .normal)
        self.firstBtn.setImage(Assets.checkmark_color.image(), for: .normal)
    }
    
    func uploadSelfieComplete(){
        self.secondBtn.setTitle("", for: .normal)
        self.secondBtn.setImage(Assets.checkmark_color.image(), for: .normal)
        CommonUI.StrikeThroughLabel(lbl: takeSelfieLbl, textcolor: UIColor.grey877E95)
        self.OpenCameraBtn.tag = 1
        self.OpenCameraBtn.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Verify identity", message: "It will open Ubble link to verify your identity.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            self.uploadSelfieComplete()
            self.uploadDocumentComplete()
            
          }))
        self.present(alert, animated: true, completion: nil)
    }
}
