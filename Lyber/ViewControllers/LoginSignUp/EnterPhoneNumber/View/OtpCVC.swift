//
//  OtpCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import UIKit
import IQKeyboardManagerSwift

class OtpCVC: UICollectionViewCell ,MyTextFieldDelegate{
    //MARK: - Variables
    var controller : EnterPhoneVC?
    var otpFieldDelegate : ((String)->())?
    var time = 30
    var timer = Timer()
    //MARK: - IB OUTLETS
    @IBOutlet var enterCodeLbl: UILabel!
    @IBOutlet var confirmationLbl: UILabel!
    @IBOutlet var phoneNumberLbl: UILabel!
    
    @IBOutlet var Tf1: otpTextField!
    @IBOutlet var Tf2: otpTextField!
    @IBOutlet var Tf3: otpTextField!
    @IBOutlet var Tf4: otpTextField!
//    @IBOutlet var resendCodeLbl: UILabel!
    @IBOutlet var resendCodeBtn: UIButton!
    
}

//Mark:- SetUpUI
extension OtpCVC{
    func setUpUI(countryCode: String, phoneNumber: String){
//        IQKeyboardManager.shared.enableAutoToolbar = false
        CommonUI.setUpLbl(lbl: enterCodeLbl, text: L10n.EnterCode.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: confirmationLbl, text: L10n.confirmationCode.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: phoneNumberLbl, text: "\(countryCode) \(phoneNumber)", textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))

        let tfs : [otpTextField] = [Tf1,Tf2,Tf3, Tf4]
        for tf in tfs {
            tf.delegate = self
            tf.otpDelegate = self
            tf.font = UIFont.MabryProMedium(Size.Large.sizeValue())
            CommonUI.setUpViewBorder(vw: tf, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor)
        }
        CommonUI.setUpButton(btn: resendCodeBtn, text: "\(L10n.resendCodeWillBeSend.description)00:\(time)", textcolor: UIColor.SecondarytextColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        self.resendCodeBtn.addTarget(self, action: #selector(resendCodeButton), for: .touchUpInside)
//        hitTimer()
    }
    
    func configureWithData(){
        
    }
}

//MARK: - Text Field Delegates
extension OtpCVC: UITextFieldDelegate{
    
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
                if Tf1.text != "" && Tf2.text != "" && Tf3.text != "" && Tf4.text != ""{
                    otpFieldDelegate?("\(Tf1.text ?? "")\(Tf2.text ?? "")\(Tf3.text ?? "")\(Tf4.text ?? "")")
                }
            }
        
        return newString.length <= maxLength
    }
}

//MARK: - Other functions
extension OtpCVC{
    
    @objc func resendCodeButton(){
//        time = 15
//        self.resendCodeBtn.setTitleColor(UIColor.SecondarytextColor, for: .normal)
//        resendCodeBtn.setTitle("\(L10n.resendCodeWillBeSend.description)00:\(time)", for:.normal)
//        self.hitTimer()
        CommonFunction.showLoader(self.controller?.view ?? UIView())
        self.controller?.enterPhoneVM.resendOtpCodeApi(completion: {[weak self]response in
            CommonFunction.hideLoader(self?.controller?.view ?? UIView())
            if let _ = response{
                self?.time = 30
                self?.resendCodeBtn.setTitleColor(UIColor.SecondarytextColor, for: .normal)
                self?.resendCodeBtn.setTitle("\(L10n.resendCodeWillBeSend.description)00:\(self?.time ?? 0)", for:.normal)
                self?.hitTimer()
            }
        })
    }
    
    func hitTimer(){
        resendCodeBtn.isUserInteractionEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer(){
        if self.time > 0{
            self.time -= 1
            var tempString = "\(L10n.resendCodeWillBeSend.description)00:\(self.time)"
            if time < 10{
                tempString = "\(L10n.resendCodeWillBeSend.description)00:0\(self.time)"
            }
            UIView.performWithoutAnimation {
                self.resendCodeBtn.setTitle(tempString, for: .normal)
                self.resendCodeBtn.layoutIfNeeded()
            }
            resendCodeBtn.isUserInteractionEnabled = false
        }else{
            self.timer.invalidate()
            UIView.performWithoutAnimation {
                self.resendCodeBtn.setTitle(L10n.ResendCode.description, for:.normal)
                self.resendCodeBtn.setTitleColor(UIColor.PurpleColor, for: .normal)
                self.resendCodeBtn.layoutIfNeeded()
            }
            resendCodeBtn.isUserInteractionEnabled = true
        }
    }
}
