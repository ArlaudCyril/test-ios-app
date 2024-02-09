//
//  checkAccountCompletedVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit

class checkAccountCompletedVC: ViewController {
    //MARK: - Variables
    var tableData : [AccountCompletedModel] =
    [AccountCompletedModel(index: 1, text: CommonFunctions.localisation(key: "CREATE_AN_ACCOUNT"), isCompleted: false, isPending: true, rightIcon: Assets.right_arrow_grey.image()),
     AccountCompletedModel(index: 2, text: CommonFunctions.localisation(key: "FILL_PERSONAL_DATA"), isCompleted: false, isPending: false, rightIcon: Assets.right_arrow_grey.image()),
     AccountCompletedModel(index: 3, text: CommonFunctions.localisation(key: "VERIFY_YOUR_IDENTITY"), isCompleted: false, isPending: false, rightIcon: Assets.right_arrow_grey.image()),
//     AccountCompletedModel(index: 4, text: CommonFunctions.localisation(key: "MAKE_YOUR_FIRST_INVESTMENT"), isCompleted: false, isPending: false, rightIcon: Assets.right_arrow_grey.image())
    ]
    //MARK:- IB OUTLETS
	@IBOutlet var headerView: HeaderView!
    @IBOutlet var bottomVw: UIView!
    @IBOutlet var completeYourAccountLbl: UILabel!
    @IBOutlet var stepcompletedLbl: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var infoLbl: UILabel!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var investMoneyBtn: UIButton!
    @IBOutlet var threeDotBtn: UIButton!
	@IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkAccountInfoCompleted()
		self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
       
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tblView.removeObserver(self, forKeyPath: "contentSize")
	}


	//MARK: - SetUpUI

    override func setUpUI(){
        CommonUI.setUpLbl(lbl: self.headerView.headerLbl, text: CommonFunctions.localisation(key: "REGISTRATION"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.bottomVw.layer.cornerRadius = 32
        self.bottomVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        self.progressView.layer.cornerRadius = 4
        self.progressView.layer.sublayers![1].cornerRadius = 4
        self.progressView.subviews[1].clipsToBounds = true
        CommonUI.setUpLbl(lbl: self.completeYourAccountLbl, text: CommonFunctions.localisation(key: "COMPLETE_ACCOUNT_TO_START_INVESTING"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.stepcompletedLbl, text: "0/3 \(CommonFunctions.localisation(key: "STEPS_COMPLETED"))", textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: self.infoLbl, text: CommonFunctions.localisation(key: "PROGRESS_REGISTRATION_SAVED_EACH_STAGE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.infoLbl.numberOfLines = 0
        
        self.tblView.layer.cornerRadius = 16
        tblView.delegate = self
        tblView.dataSource  = self
		
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
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
        if tableData[indexPath.row].isCompleted == false{
			if indexPath.row == 0{
				let vc = EnterPhoneVC.instantiateFromAppStoryboard(appStoryboard: .Main)
				self.navigationController?.pushViewController(vc, animated: false)
				
			}
            else if indexPath.row == 1{
                if userData.shared.stepRegisteringComplete == 1{
                    let vc = PersonalDataVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }else if indexPath.row == 2{
                if userData.shared.stepRegisteringComplete == 2{
                    let vc = IdentityVerificationVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
}

//MARK: - Other functions
extension checkAccountCompletedVC{
    func checkAccountInfoCompleted(){
        if userData.shared.stepRegisteringComplete >= 1{
            self.tableData[0].isCompleted = true
            self.tableData[0].isPending = false
			self.tableData[1].isPending = true
			self.progressView.progress = 1/3
			self.stepcompletedLbl.text = "1/3 \(CommonFunctions.localisation(key: "STEPS_COMPLETED"))"
        }
        if userData.shared.stepRegisteringComplete == 2{
            self.tableData[1].isCompleted = true
            self.tableData[1].isPending = false
            self.tableData[2].isPending = true
            self.progressView.progress = 2/3
            self.stepcompletedLbl.text = "2/3 \(CommonFunctions.localisation(key: "STEPS_COMPLETED"))"
        }
//        if userData.shared.stepRegisteringComplete == 3{
//            self.tableData[2].isCompleted = true
//            self.tableData[2].isPending = false
//        }
//        self.tblView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                self.tblView.reloadData()
        })
    }
	
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: false)
	}
}
