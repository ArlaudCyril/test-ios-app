//
//  AddPaymentMethodVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit

class AddPaymentMethodVC: UIViewController {
    //MARK: - Variables
    var paymentMethodData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: L10n.BankAccount.description, subName: L10n.LimitedTo25000€PerWeek.description, rightBtnName: ""),
        buyDepositeModel(icon: Assets.creditcardPurple.image(), iconBackgroundColor: UIColor.LightPurple, name: L10n.AddCreditCard.description, subName: L10n.LimitedTo1000€PerWeek.description, rightBtnName: ""),
    ]
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var addPaymentLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

}

//MARK: - SetUpUI
extension AddPaymentMethodVC{
    func setUpUI(){
        self.backBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: addPaymentLbl, text: L10n.AddPaymentMethod.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
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
