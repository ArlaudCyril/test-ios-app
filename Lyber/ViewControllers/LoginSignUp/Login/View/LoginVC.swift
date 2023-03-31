//
//  LoginVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit

class LoginVC: ViewController {
    //MARK: - IB OUTLETS
    @IBOutlet var backgroundImgVw: UIImageView!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subtitleLbl: UILabel!
    @IBOutlet var signUpBtn: PurpleButton!
    @IBOutlet var LoginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
	//MARK: - SetUpUI
    override func setUpUI(){
        CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_REINVENTED"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: subtitleLbl, text: CommonFunctions.localisation(key: "DIVERSIFIED_REGULAR_SIMPLE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        self.signUpBtn.setTitle(CommonFunctions.localisation(key: "SIGN_UP"), for: .normal)
        CommonUI.setUpButton(btn: LoginBtn, text: CommonFunctions.localisation(key: "LOG_IN"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 16, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.signUpBtn.addTarget(self, action: #selector(signUpBtnAct), for: .touchUpInside)
        self.LoginBtn.addTarget(self, action: #selector(loginBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension LoginVC{
    @objc func signUpBtnAct(){
		GlobalVariables.isRegistering = true
        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func loginBtnAct(){
		GlobalVariables.isRegistering = false
        let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
        vc.isLogin = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
}
