//
//  AddCreditCardVC.swift
//  Lyber
//
//  Created by sonam's Mac on 23/06/22.
//

import UIKit
import DropDown

class AddCreditCardVC: UIViewController {
    //MARK: - Variables
    var dropDown = DropDown()
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var addCreditcardLbl: UILabel!
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var cardNumberView: UIView!
    @IBOutlet var cardNumberTF: UITextField!
    @IBOutlet var expireView: UIView!
    @IBOutlet var expireLbl: UILabel!
    @IBOutlet var expireBtn: UIButton!
    @IBOutlet var expireTF: UITextField!
    @IBOutlet var CVVView: UIView!
    @IBOutlet var cvvTF: UITextField!
    @IBOutlet var zipView: UIView!
    @IBOutlet var zipCodeTF: UITextField!
    @IBOutlet var addBtn: PurpleButton!
    @IBOutlet var termConditionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

//MARK: - SetUpUI
extension AddCreditCardVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: addCreditcardLbl, text: L10n.AddCreditCard.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: termConditionLbl, text: L10n.ByAddingNewCardYouAcceptTermsConditions.description, textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Small.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.nameView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.cardNumberView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.expireView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.CVVView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.zipView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpTextField(textfield: nameTF, placeholder: L10n.CardholderName.description, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: cardNumberTF, placeholder: L10n.CardNumber.description, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
//        CommonUI.setUpTextField(textfield: expireTF, placeholder: L10n.Expire.description, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
//        CommonUI.setUpButton(btn: expireBtn, text: L10n.Expire.description, textcolor: UIColor.TFplaceholderColor, backgroundColor: UIColor.whiteColor, cornerRadius: 16, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: expireLbl, text: L10n.Expire.description, textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: cvvTF, placeholder: L10n.CVV.description, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: zipCodeTF, placeholder: L10n.ZIPCode.description, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        let tfs = [nameTF,cardNumberTF,cvvTF,zipCodeTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
        }
        self.addBtn.setTitle(L10n.Add.description, for: .normal)
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.addBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expireBtnAct))
        self.expireView.addGestureRecognizer(tap)
    }
}

//MARK: - Text Field Delegates
extension AddCreditCardVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF{
            self.cardNumberTF.becomeFirstResponder()
        }else if textField == cardNumberTF{
//            self.expireTF.becomeFirstResponder()
        }else if textField == expireTF{
            self.cvvTF.becomeFirstResponder()
        }else if textField == cvvTF{
            self.zipCodeTF.becomeFirstResponder()
        }else if textField == zipCodeTF{
            self.zipCodeTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == nameTF{
            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
                return false
            }
            return (newString.length <= 30 )
        }else if textField == cardNumberTF{
            return (newString.length <= 16 )
        }else if textField == expireTF{
//            return (newString.length <= 4 )
            return false
        }else if textField == cvvTF{
            return (newString.length <= 3 )
        }else if textField == zipCodeTF{
            return (newString.length <= 6 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameTF{
            CommonUI.setUpViewBorder(vw: self.nameView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == cardNumberTF{
            CommonUI.setUpViewBorder(vw: self.cardNumberView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == expireTF{
//            let tap = UITapGestureRecognizer(target: self, action: #selector(SelectYear))
//            self.expireTF.addGestureRecognizer(tap)
//            CommonUI.setUpViewBorder(vw: self.expireView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == cvvTF{
            CommonUI.setUpViewBorder(vw: self.CVVView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == zipCodeTF{
            CommonUI.setUpViewBorder(vw: self.zipView, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF{
            CommonUI.setUpViewBorder(vw: self.nameView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == cardNumberTF{
            CommonUI.setUpViewBorder(vw: self.cardNumberView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == expireTF{
//            CommonUI.setUpViewBorder(vw: self.expireView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == cvvTF{
            CommonUI.setUpViewBorder(vw: self.CVVView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == zipCodeTF{
            CommonUI.setUpViewBorder(vw: self.zipView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - objective functions
extension AddCreditCardVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addBtnAct(){
//        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func expireBtnAct(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strDate = dateFormatter.string(from: date)
//        }
//        let years : [String] = []
//        for i in 0..<7{
//            print((Int(strDate) ?? 0) + i)
//            years.append("\((Int(strDate) ?? 0) + i)")
//        }
        dropDown.dataSource = ["\(Int(strDate) ?? 0)","\((Int(strDate) ?? 0 ) + 1 )","\((Int(strDate) ?? 0) + 2)","\((Int(strDate) ?? 0) + 3)","\((Int(strDate) ?? 0) + 4)","\((Int(strDate) ?? 0) + 5)","\((Int(strDate) ?? 0) + 6)"]
        dropDown.selectionBackgroundColor = UIColor.LightPurple
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.cornerRadius = 6
        dropDown.anchorView = expireView
        dropDown.bottomOffset = CGPoint(x: 0, y: expireView.frame.height)
        dropDown.show()
        dropDown.selectionAction = {[weak self] (index: Int,item: String) in
            CommonUI.setUpLbl(lbl: self?.expireLbl ?? UILabel(), text: item, textColor: UIColor.Purple35126D, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        }
    }
}
