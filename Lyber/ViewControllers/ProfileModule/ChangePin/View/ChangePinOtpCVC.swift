//
//  ChangePinOtpCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/07/22.
//

import UIKit

class ChangePinOtpCVC: UICollectionViewCell ,MyTextFieldDelegate{
    //MARK: - Variables
    var otpFieldDelegate : ((String)->())?
    
    //MARK: - IB OUTLETS
    @IBOutlet var enterCodeLbl: UILabel!
    @IBOutlet var confirmationLbl: UILabel!
//    @IBOutlet var phoneNumberLbl: UILabel!
    
    @IBOutlet var Tf1: otpTextField!
    @IBOutlet var Tf2: otpTextField!
    @IBOutlet var Tf3: otpTextField!
    @IBOutlet var Tf4: otpTextField!
//    @IBOutlet var resendCodeBtn: UIButton!
}

//Mark:- SetUpUI
extension ChangePinOtpCVC{
    func setUpUI(){
//        IQKeyboardManager.shared.enableAutoToolbar = false
        CommonUI.setUpLbl(lbl: enterCodeLbl, text: L10n.EnterCode.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: confirmationLbl, text: L10n.confirmationCode.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))

        let tfs : [otpTextField] = [Tf1,Tf2,Tf3, Tf4]
        for tf in tfs {
            tf.delegate = self
            tf.otpDelegate = self
            tf.font = UIFont.MabryProMedium(Size.Large.sizeValue())
            CommonUI.setUpViewBorder(vw: tf, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor)
        }
//        CommonUI.setUpButton(btn: resendCodeBtn, text: "\(L10n.resendCodeWillBeSend.description)00:\(time)", textcolor: UIColor.SecondarytextColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
//        self.resendCodeBtn.addTarget(self, action: #selector(resendCodeButton), for: .touchUpInside)
//        hitTimer()
    }
    
}

//MARK: - Text Field Delegates
extension ChangePinOtpCVC: UITextFieldDelegate{
    
    func textFieldDidDelete(_ tf: UITextField) {
        switch tf {
        case Tf1:
                Tf1.resignFirstResponder()
        case Tf2:
                Tf1.becomeFirstResponder()
        case Tf3:
                Tf2.becomeFirstResponder()
        case Tf4:
                Tf3.becomeFirstResponder()
            
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
                if Tf1 == textField{
                    Tf2.becomeFirstResponder()
                }else if Tf2 == textField{
                    Tf3.becomeFirstResponder()
                }else if Tf3 == textField{
                    Tf4.becomeFirstResponder()
                }else if Tf4 == textField{
                    Tf4.resignFirstResponder()
                }
            }
        if Tf1.text != "" && Tf2.text != "" && Tf3.text != "" && Tf4.text != ""{
            otpFieldDelegate?("\(Tf1.text ?? "")\(Tf2.text ?? "")\(Tf3.text ?? "")\(Tf4.text ?? "")")
            Tf1.text = ""
            Tf2.text = ""
            Tf3.text = ""
            Tf4.text = ""
        }
        return newString.length <= maxLength
    }
}
