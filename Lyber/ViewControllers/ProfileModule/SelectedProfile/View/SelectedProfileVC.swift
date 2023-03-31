//
//  SelectedProfileVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class SelectedProfileVC: ViewController {
    var profilePicImg = UIImage()
    var profilePicType : profilePicType = .GALLERY
    var profileChangeCallback : ((UIImage)->())?
    var selectedProfileVM = SelectedProfileVM()
    //MARK:- IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var profilePicVw: UIView!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var saveBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
       
    }
    


	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.text = CommonFunctions.localisation(key: "SELECTED_PROFILE_PICTURE")
        self.profilePicVw.layer.cornerRadius = self.profilePicVw.layer.bounds.height/2
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.height/2
        self.profilePic.image = profilePicImg
        if profilePicType == .DEFAULT{
            self.profilePic.contentMode = .scaleAspectFit
            self.profilePic.image = self.profilePic.image?.roundedImageWithBorder(width: 18, color: UIColor.clear)
        }else{
            self.profilePic.contentMode = .scaleAspectFill
        }
        self.saveBtn.setTitle(CommonFunctions.localisation(key: "SAVE"), for: .normal)
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.saveBtn.addTarget(self, action: #selector(saveBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension SelectedProfileVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveBtnAct(){
        self.saveBtn.showLoading()
        selectedProfileVM.uploadImgApi(ProfilePic: profilePicImg, completion: {[weak self]response in
            if let response = response{
                print(response)
                self?.selectedProfileVM.updateProfileImgApi(ProfilePic: response.file_name ?? "",ProfileType : self?.profilePicType, completion: {[weak self]response in
                    self?.saveBtn.hideLoading()
                    if let response = response{
                        print(response)
                        userData.shared.profile_image = response.profile_pic ?? ""
                        userData.shared.profilePicType = response.profile_pic_type ?? ""
                        userData.shared.dataSave()
                        self?.navigationController?.popToViewController(ofClass: ProfileVC.self, animated: true)
                    }
                })
            }
        })
    }
}
