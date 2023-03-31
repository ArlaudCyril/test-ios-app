//
//  FundAccountVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/08/22.
//

import UIKit

class FundAccountVC: ViewController {
    //MARK:- IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var fundAccountLbl: UILabel!
    @IBOutlet var fundAccountDescLbl: UILabel!
    
    @IBOutlet var ibanLbl: UILabel!
    @IBOutlet var ibanNoLbl: UILabel!
    
    @IBOutlet var referenceLbl: UILabel!
    @IBOutlet var referenceNoLbl: UILabel!
    
    @IBOutlet var bicLbl: UILabel!
    @IBOutlet var bicNoLbl: UILabel!
    
    @IBOutlet var ReceipientNameLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var receipientAddressLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var bankNameLbl: UILabel!
    @IBOutlet var nameOfBankLbl: UILabel!
    
    @IBOutlet var transferTimingView: UIView!
    @IBOutlet var transferTimingLbl: UILabel!
    @IBOutlet var transferTimingDescLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: fundAccountLbl, text: CommonFunctions.localisation(key: "FUND_ACCOUNT_YOUR_BANK_ACCOUNT"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: fundAccountDescLbl, text: CommonFunctions.localisation(key: "MAKE_SURE_NAME_BANK_ACCOUNT"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: fundAccountLbl, text: CommonFunctions.localisation(key: "FUND_ACCOUNT_YOUR_BANK_ACCOUNT"), lineSpacing: 6, textAlignment: .left)
        CommonUI.setTextWithLineSpacing(label: fundAccountDescLbl, text: CommonFunctions.localisation(key: "MAKE_SURE_NAME_BANK_ACCOUNT"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: ibanLbl, text: CommonFunctions.localisation(key: "IBAN_NUMBER"), textColor: UIColor.Grey7B8094, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: bicLbl, text: CommonFunctions.localisation(key: "BIC_NUMBER"), textColor: UIColor.Grey7B8094, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpLbl(lbl: ibanNoLbl, text: "AA123456789000000", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: bicNoLbl, text: "ABC12345", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.transferTimingView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: transferTimingLbl, text: CommonFunctions.localisation(key: "TRANSFER_TIMING"), textColor: UIColor.Grey7B8094, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: transferTimingDescLbl, text: CommonFunctions.localisation(key: "SEPA_TRANSFER"), textColor: UIColor.Grey7B8094, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: transferTimingDescLbl, text: CommonFunctions.localisation(key: "SEPA_TRANSFER"), lineSpacing: 6, textAlignment: .left)
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension FundAccountVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
}
