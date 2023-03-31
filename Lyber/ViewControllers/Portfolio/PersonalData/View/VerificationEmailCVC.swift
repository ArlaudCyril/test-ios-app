//
//  VerificationEmailCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit

class VerificationEmailCVC: UICollectionViewCell, MyTextFieldDelegate {
    
    //MARK: - Variables
    var controller : PersonalDataVC?
    var personalDataVM = PersonalDataVM()
    var verificationEmailCallBack : ((String)->())?
    //MARK: - IB OUTLETS
    
    @IBOutlet var enterCodeLbl: UILabel!
    @IBOutlet var confirmationLbl: UILabel!
	@IBOutlet var emailAdressLbl: UILabel!

    @IBOutlet var Tf1: otpTextField!
    @IBOutlet var Tf2: otpTextField!
    @IBOutlet var Tf3: otpTextField!
    @IBOutlet var Tf4: otpTextField!
    @IBOutlet var Tf5: otpTextField!
    @IBOutlet var Tf6: otpTextField!
    
}


//MARK: - SetUpUI
extension VerificationEmailCVC{
    func setUpCell(){
        Tf1.becomeFirstResponder()
		
        CommonUI.setUpLbl(lbl: enterCodeLbl, text: CommonFunctions.localisation(key: "ENTER_CODE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: confirmationLbl, text: CommonFunctions.localisation(key: "CONFIRMATION_CODE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		
		CommonUI.setUpLbl(lbl: emailAdressLbl, text: self.controller?.email ?? "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
		

        let tfs : [otpTextField] = [Tf1,Tf2,Tf3, Tf4, Tf5, Tf6]
        for tf in tfs {
            tf.delegate = self
            tf.otpDelegate = self
            tf.font = UIFont.MabryProMedium(Size.Large.sizeValue())
            CommonUI.setUpViewBorder(vw: tf, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor)
        }
    }

}

//MARK: - Text Field Delegates
extension VerificationEmailCVC: UITextFieldDelegate{
    
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
        case Tf5:
            Tf4.becomeFirstResponder()
        case Tf6:
            Tf5.becomeFirstResponder()
            
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
                    Tf5.becomeFirstResponder()
                }else if Tf5 == textField{
                    Tf6.becomeFirstResponder()
                }else if Tf6 == textField{
                    Tf6.resignFirstResponder()
                }
                if Tf1.text != "" && Tf2.text != "" && Tf3.text != "" && Tf4.text != "" && Tf5.text != "" && Tf6.text != ""{

                    verificationEmailCallBack?("\(Tf1.text ?? "")\(Tf2.text ?? "")\(Tf3.text ?? "")\(Tf4.text ?? "")\(Tf5.text ?? "")\(Tf6.text ?? "")")
                }
            }

        return newString.length <= maxLength
    }
}


