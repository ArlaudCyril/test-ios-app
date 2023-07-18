//
//  CreateNewPinCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/07/22.
//

import UIKit
import IQKeyboardManagerSwift

class CreateNewPinCVC: UICollectionViewCell {
    //MARK: - Variables
    var pinCreatedDelegate : ((String)->())?
    var enterDigitCounts : Int! = 0
    
    //MARK: - IB OUTLETS
    @IBOutlet var createPinLbl: UILabel!
    @IBOutlet var secureAccountLbl: UILabel!
    @IBOutlet var pinTF1: otpTextField!
    @IBOutlet var pinTF2: otpTextField!
    @IBOutlet var pinTF3: otpTextField!
    @IBOutlet var pinTF4: otpTextField!


	//MARK: - SetUpUI

    func setUpUI(){
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
		IQKeyboardManager.shared.enableAutoToolbar = false
        enterDigitCounts = 0
        CommonUI.setUpLbl(lbl: createPinLbl, text: CommonFunctions.localisation(key: "CREATE_PIN"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: secureAccountLbl, text: CommonFunctions.localisation(key: "FOUR_DIGIT_CODE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: secureAccountLbl, text: CommonFunctions.localisation(key: "FOUR_DIGIT_CODE"), lineSpacing: 6, textAlignment: .left)
        let pins : [otpTextField] = [pinTF1,pinTF2,pinTF3,pinTF4]
        for pin in pins{
            pin.delegate = self
            pin.otpDelegate = self
            pin.layer.cornerRadius = (pin.layer.bounds.width )/2
        }
    }
    
    func configureWithData(){
        
    }
}

//MARK: - Text Field Delegates
extension CreateNewPinCVC: UITextFieldDelegate,MyTextFieldDelegate{
    
    func textFieldDidDelete(_ tf: UITextField) {
        switch tf {
        case pinTF1:
            enterDigitCounts = 0
            pinTF1.backgroundColor = UIColor.borderColor
//            pinTF1.resignFirstResponder()
        case pinTF2:
            enterDigitCounts -= 1
            pinTF2.backgroundColor = UIColor.borderColor
            pinTF1.becomeFirstResponder()
        case pinTF3:
            enterDigitCounts -= 1
            pinTF3.backgroundColor = UIColor.borderColor
            pinTF2.becomeFirstResponder()
        case pinTF4:
            enterDigitCounts -= 1
            pinTF4.backgroundColor = UIColor.borderColor
            pinTF3.becomeFirstResponder()
            
        default:
            print("error")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let maxLength = 1
            if string.count == 1{
                textField.text = string
                if pinTF1 == textField{
                    enterDigitCounts += 1
                    pinTF1.backgroundColor = UIColor.primaryTextcolor
                    pinTF2.becomeFirstResponder()
                }else if pinTF2 == textField{
                    enterDigitCounts += 1
                    pinTF2.backgroundColor = UIColor.primaryTextcolor
                    pinTF3.becomeFirstResponder()
                }else if pinTF3 == textField{
                    enterDigitCounts += 1
                    pinTF3.backgroundColor = UIColor.primaryTextcolor
                    pinTF4.becomeFirstResponder()
                }else if pinTF4 == textField{
                    enterDigitCounts += 1
                    pinTF4.backgroundColor = UIColor.primaryTextcolor
                    pinTF4.resignFirstResponder()
                    
                }
            }
        if enterDigitCounts == 4{
            enterDigitCounts = 0
            pinCreatedDelegate?("\(pinTF1.text ?? "")\(pinTF2.text ?? "")\(pinTF3.text ?? "")\(pinTF4.text ?? "")")
            let tfs = [pinTF1,pinTF2,pinTF3,pinTF4]
            for tf in tfs{
                tf?.backgroundColor = UIColor.borderColor
                tf?.text = ""
            }
        }
        return newString.length <= maxLength
    }
}
