//
//  SelectedProfileVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class SelectedProfileVC: ViewController {
    var profilePicImg = UIImage()
    var profileChangeCallback : ((UIImage)->())?
	var icon : Constants.Icon = .HUMAN_HEAD
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
		self.profilePic.contentMode = .scaleAspectFit
		self.profilePic.image = self.profilePic.image?.roundedImageWithBorder(width: 18, color: UIColor.clear)
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
		ProfileVM().saveProfilePictureApi(imageName: self.icon.rawValue, completion: {response in
			self.saveBtn.hideLoading()
			if response != nil{
				userData.shared.profile_image = self.icon.rawValue
				userData.shared.dataSave()
				self.navigationController?.popToViewController(ofClass: ProfileVC.self, animated: false)
			}
		})
        
    }
}
