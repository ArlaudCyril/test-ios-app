//
//  AddBankAccountVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/07/22.
//

import UIKit

class AddBankAccountVC: ViewController {
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var addBankAccountLbl: UILabel!
    @IBOutlet var ibanNumberVw: UIView!
    @IBOutlet var bicView: UIView!
    @IBOutlet var ibanTF: UITextField!
    @IBOutlet var bicTF: UITextField!
    @IBOutlet var addBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }


	//MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.isHidden  = true
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        CommonUI.setUpLbl(lbl: addBankAccountLbl, text: CommonFunctions.localisation(key: "ADD_BANK_ACCOUNT"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpViewBorder(vw: self.ibanNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.bicView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpTextField(textfield: ibanTF, placeholder: CommonFunctions.localisation(key: "IBAN_NUMBER"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: bicTF, placeholder: CommonFunctions.localisation(key: "BIC_NUMBER"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        let tfs = [ibanTF,bicTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
        }
        self.addBtn.setTitle(CommonFunctions.localisation(key: "ADD"), for: .normal)
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.addBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
    }
}

//MARK: - Text Field Delegates
extension AddBankAccountVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ibanTF{
            self.bicTF.becomeFirstResponder()
        }else if textField == bicTF{
            self.bicTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == ibanTF{
            return (newString.length <= 30 )
        }else if textField == bicTF{
            return (newString.length <= 30 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == ibanTF{
            CommonUI.setUpViewBorder(vw: self.ibanNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == bicTF{
            CommonUI.setUpViewBorder(vw: self.bicView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ibanTF{
            CommonUI.setUpViewBorder(vw: self.ibanNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == bicTF{
            CommonUI.setUpViewBorder(vw: self.bicView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - objective functions
extension AddBankAccountVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnAct(){
        if self.ibanTF.text == ""{
            CommonFunctions.toster("Please enter the IBAN Number")
        }else if bicTF.text == ""{
            CommonFunctions.toster("Please enter the BIC Number")
        }else{
            self.addBtn.showLoading()
            AddBankAccountVM().addBankAccountApi(iban: self.ibanTF.text ?? "", bic: self.bicTF.text ?? "", completion: {[weak self]response in
                self?.addBtn.hideLoading()
                if let response = response{
                    print(response)
                    userData.shared.iban = self?.ibanTF.text ?? ""
                    userData.shared.bic = self?.bicTF.text ?? ""
                    userData.shared.dataSave()
                    self?.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}
