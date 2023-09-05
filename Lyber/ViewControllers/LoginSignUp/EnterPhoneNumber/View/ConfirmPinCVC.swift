//
//  ColnfirmPinCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import IQKeyboardManagerSwift
class ConfirmPinCVC: UICollectionViewCell {
    //MARK: - Variables
    var pinConfirmDelegate : ((String)->())?
    var enterDigitCounts : Int! = 0
    //MARK:- IB OUTLETS
    @IBOutlet var confirmPinLbl: UILabel!
    @IBOutlet var pinTF1: otpTextField!
    @IBOutlet var pinTF2: otpTextField!
    @IBOutlet var pinTF3: otpTextField!
    @IBOutlet var pinTF4: otpTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("confirmPin")
    }
}
//Mark:- SetUpUI
extension ConfirmPinCVC{
    func setUpUI(verifyPin : Bool){
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
		IQKeyboardManager.shared.enableAutoToolbar = false
        enterDigitCounts = 0
        if verifyPin == true{
			CommonUI.setUpLbl(lbl: confirmPinLbl, text: CommonFunctions.localisation(key: "PLEASE_ENTER_PIN"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        }else{
            CommonUI.setUpLbl(lbl: confirmPinLbl, text:  CommonFunctions.localisation(key: "CONFIRM_PIN"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        }
        let pins : [otpTextField] = [pinTF1,pinTF2,pinTF3,pinTF4]
        for pin in pins{
            pin.delegate = self
            pin.otpDelegate = self
			pin.text = ""
			pin.backgroundColor = UIColor.borderColor
            pin.layer.cornerRadius = (pin.layer.bounds.width )/2
		}
    }
    
}

//Mark:- text field Delagtes
extension ConfirmPinCVC: UITextFieldDelegate,MyTextFieldDelegate{
    
	func textFieldDidDelete(_ tf: UITextField) {
		switch tf {
			case pinTF1:
				enterDigitCounts = 0
				pinTF1.backgroundColor = UIColor.borderColor
				//            pinTF1.resignFirstResponder()
			case pinTF2:
				pinTF1.becomeFirstResponder()
				if(pinTF2.text == ""){
					pinTF1.deleteBackward()
				}else{
					enterDigitCounts -= 1
					pinTF2.backgroundColor = UIColor.borderColor
				}
			case pinTF3:
				pinTF2.becomeFirstResponder()
				if(pinTF3.text == ""){
					pinTF2.deleteBackward()
				}else{
					enterDigitCounts -= 1
					pinTF3.backgroundColor = UIColor.borderColor
				}
			case pinTF4:
				pinTF3.becomeFirstResponder()
				if(pinTF4.text == ""){
					pinTF3.deleteBackward()
				}else{
					enterDigitCounts -= 1
					pinTF4.backgroundColor = UIColor.borderColor
					
				}
			default:
				print("error")
		}
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		let currentString: NSString = textField.text! as NSString
		let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
		let maxLength = 1
		if string.count == 1{
			if pinTF1 == textField{
				if(pinTF1.text != ""){
					textField.delegate?.textField?(pinTF2, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
				}else{
					textField.text = string
					enterDigitCounts += 1
					pinTF1.backgroundColor = UIColor.primaryTextcolor
					pinTF2.becomeFirstResponder()
				}
			}else if pinTF2 == textField{
				if(pinTF2.text != ""){
					textField.delegate?.textField?(pinTF3, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
				}else{
					textField.text = string
					enterDigitCounts += 1
					pinTF2.backgroundColor = UIColor.primaryTextcolor
					pinTF3.becomeFirstResponder()
					
				}
			}else if pinTF3 == textField{
				if(pinTF3.text != ""){
					textField.delegate?.textField?(pinTF4, shouldChangeCharactersIn: _NSRange(location: 0, length: 0), replacementString: string)
				}else{
					textField.text = string
					enterDigitCounts += 1
					pinTF3.backgroundColor = UIColor.primaryTextcolor
					pinTF4.becomeFirstResponder()
					
				}
			}else if pinTF4 == textField{
				textField.text = string
				enterDigitCounts += 1
				pinTF4.backgroundColor = UIColor.primaryTextcolor
				pinTF4.resignFirstResponder()
			}
		}
		if enterDigitCounts == 4{
			enterDigitCounts = 0
			pinConfirmDelegate?("\(pinTF1.text ?? "")\(pinTF2.text ?? "")\(pinTF3.text ?? "")\(pinTF4.text ?? "")")
			let tfs = [pinTF1,pinTF2,pinTF3,pinTF4]
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
				for tf in tfs{
					tf?.backgroundColor = UIColor.borderColor
					tf?.text = ""
				}
			})
			
		}
		return newString.length <= maxLength
	}
}
