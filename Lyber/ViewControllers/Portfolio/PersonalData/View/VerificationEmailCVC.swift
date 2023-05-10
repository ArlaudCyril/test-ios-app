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
			if(Tf2.text == ""){
				Tf1.deleteBackward()
			}
            Tf1.becomeFirstResponder()
        case Tf3:
			if(Tf3.text == ""){
				Tf2.deleteBackward()
			}
            Tf2.becomeFirstResponder()
        case Tf4:
			if(Tf4.text == ""){
				Tf3.deleteBackward()
			}
            Tf3.becomeFirstResponder()
        case Tf5:
			if(Tf5.text == ""){
				Tf4.deleteBackward()
			}
            Tf4.becomeFirstResponder()
        case Tf6:
			if(Tf6.text == ""){
				Tf5.deleteBackward()
			}
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
				if Tf1 == textField{
					if(Tf1.text != ""){
						textField.delegate?.textField?(Tf2, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
					}else{
						textField.text = string
						Tf2.becomeFirstResponder()
					}
                }else if Tf2 == textField{
					if(Tf2.text != ""){
						textField.delegate?.textField?(Tf3, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
					}else{
						textField.text = string
						Tf3.becomeFirstResponder()
					}
                }else if Tf3 == textField{
					if(Tf3.text != ""){
						textField.delegate?.textField?(Tf4, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
					}else{
						textField.text = string
						Tf4.becomeFirstResponder()
					}
                }else if Tf4 == textField{
					if(Tf4.text != ""){
						textField.delegate?.textField?(Tf5, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
					}else{
						textField.text = string
						Tf5.becomeFirstResponder()
					}
                }else if Tf5 == textField{
					if(Tf5.text != ""){
						textField.delegate?.textField?(Tf6, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
					}else{
						textField.text = string
						Tf6.becomeFirstResponder()
					}
                }else if Tf6 == textField{
					textField.text = string
                    Tf6.resignFirstResponder()
                }
                if Tf1.text != "" && Tf2.text != "" && Tf3.text != "" && Tf4.text != "" && Tf5.text != "" && Tf6.text != ""{

                    verificationEmailCallBack?("\(Tf1.text ?? "")\(Tf2.text ?? "")\(Tf3.text ?? "")\(Tf4.text ?? "")\(Tf5.text ?? "")\(Tf6.text ?? "")")
                }
            }

        return newString.length <= maxLength
    }
}


