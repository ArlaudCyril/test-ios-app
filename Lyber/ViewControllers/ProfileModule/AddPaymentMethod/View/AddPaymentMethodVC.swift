//
//  AddPaymentMethodVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit

class AddPaymentMethodVC: ViewController {
    //MARK: - Variables
    var paymentMethodData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "BANK_ACCOUNT"), subName: CommonFunctions.localisation(key: "LIMITED_25000€_WEEK"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.creditcardPurple.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ADD_CREDIT_CARD"), subName: CommonFunctions.localisation(key: "LIMITED_1000€_WEEK"), rightBtnName: ""),
    ]
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var addPaymentLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: addPaymentLbl, text: CommonFunctions.localisation(key: "ADD_PAYMENT_METHOD"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        tblView.delegate = self
        tblView.dataSource = self
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
    }
}

//Mark:- table view delegates and dataSource
extension AddPaymentMethodVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethodData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPaymentMethodTVC")as! AddPaymentMethodTVC
        cell.setUpCellData(data: paymentMethodData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = AddBankAccountVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        if indexPath.row == 1{
            let vc = AddCreditCardVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - objective functions
extension AddPaymentMethodVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnAct(){
//        self.navigationController?.popViewController(animated: true)
    }
}
