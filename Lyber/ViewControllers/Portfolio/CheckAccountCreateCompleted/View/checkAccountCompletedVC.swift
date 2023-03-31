//
//  checkAccountCompletedVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit

class checkAccountCompletedVC: ViewController {
    //MARK: - Variables
    var openFromLink = false
    var tableData : [AccountCompletedModel] =
    [AccountCompletedModel(index: 1, text: CommonFunctions.localisation(key: "CREATE_AN_ACCOUNT"), isCompleted: true, isPending: false, rightIcon: Assets.right_arrow_grey.image()),
     AccountCompletedModel(index: 2, text: CommonFunctions.localisation(key: "FILL_PERSONAL_DATA"), isCompleted: false, isPending: true, rightIcon: Assets.right_arrow_grey.image()),
     AccountCompletedModel(index: 3, text: CommonFunctions.localisation(key: "VERIFY_YOUR_IDENTITY"), isCompleted: false, isPending: false, rightIcon: Assets.right_arrow_grey.image()),
//     AccountCompletedModel(index: 4, text: CommonFunctions.localisation(key: "MAKE_YOUR_FIRST_INVESTMENT"), isCompleted: false, isPending: false, rightIcon: Assets.right_arrow_grey.image())
    ]
    //MARK:- IB OUTLETS
    @IBOutlet var portfolioLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var bottomVw: UIView!
    @IBOutlet var completeYourAccountLbl: UILabel!
    @IBOutlet var stepcompletedLbl: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if openFromLink {
            DispatchQueue.main.async {
                let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                vc.openFromLink = true
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAccountInfoCompleted()
       
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        CommonUI.setUpLbl(lbl: self.portfolioLbl, text: CommonFunctions.localisation(key: "PORTFOLIO"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "0.00€", textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.extraLarge.sizeValue()))
        self.profilePic.layer.cornerRadius = self.profilePic.layer.bounds.width/2
        
        self.bottomVw.layer.cornerRadius = 32
        self.bottomVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.progressView.layer.cornerRadius = 4
        self.progressView.layer.sublayers![1].cornerRadius = 4
        self.progressView.subviews[1].clipsToBounds = true
        CommonUI.setUpLbl(lbl: self.completeYourAccountLbl, text: CommonFunctions.localisation(key: "COMPLETE_ACCOUNT_TO_START_INVESTING"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.stepcompletedLbl, text: "1/3 \(CommonFunctions.localisation(key: "STEP_COMPLETED"))", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        self.tblView.layer.cornerRadius = 16
        tblView.delegate = self
        tblView.dataSource  = self
    }
}

//MARK: - objective functions
extension checkAccountCompletedVC{
    
    @objc func threeDotBtnAct(){
        
    }
}

//MARK: - table view delegates and dataSource
extension checkAccountCompletedVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkAccountCompletedTVC")as! checkAccountCompletedTVC
        cell.setUpCell(data: tableData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData[indexPath.row].isCompleted == true{
//            let vc = IdentityVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//            let nav = UINavigationController(rootViewController: vc)
//            nav.modalPresentationStyle = .fullScreen
//            nav.navigationBar.isHidden = true
//            self.present(nav, animated: true, completion: nil)
        }else {
            if indexPath.row == 1{
                let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//                vc.openFromLink = openFromLink
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }else if indexPath.row == 2{
                if userData.shared.isPersonalInfoFilled{
                    let vc = IdentityVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                    let nav = UINavigationController(rootViewController: vc)
                    nav.modalPresentationStyle = .fullScreen
                    nav.navigationBar.isHidden = true
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
        
    }
}

//MARK: - Other functions
extension checkAccountCompletedVC{
    func checkAccountInfoCompleted(){
        if userData.shared.isAccountCreated{
            self.tableData[0].isCompleted = true
            self.tableData[0].isPending = false
        }
        if userData.shared.isPersonalInfoFilled{
            self.tableData[1].isCompleted = true
            self.tableData[1].isPending = false
            self.tableData[2].isPending = true
            self.progressView.progress = 2/3
            self.stepcompletedLbl.text = "2/3 \(CommonFunctions.localisation(key: "STEP_COMPLETED"))"
        }
        if userData.shared.isIdentityVerified{
            self.tableData[2].isCompleted = true
            self.tableData[2].isPending = false
        }
//        self.tblView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                self.tblView.reloadData()
        })
    }
}
