//
//  StrongAuthOTPVerifyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/08/22.
//

import UIKit

class StrongAuthOTPVerifyVC: ViewController ,MyTextFieldDelegate{
    //MARK: - Variables
    var time = 30
    var timer = Timer()
    var strongAuthCallback : (()->())?
    var strongAuthOTPVerifyVM = StrongAuthOTPVerifyVM()
    var cancelCallBack :(()->())?
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var enterCodeLbl: UILabel!
    @IBOutlet var wehaveSentCodeLbl: UILabel!
    @IBOutlet var phoneNumberLbl: UILabel!
    @IBOutlet var tf1: otpTextField!
    @IBOutlet var tf2: otpTextField!
    @IBOutlet var tf3: otpTextField!
    @IBOutlet var tf4: otpTextField!
    @IBOutlet var tf5: otpTextField!
    @IBOutlet var tf6: otpTextField!
    @IBOutlet var resendBtn: UIButton!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var bottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


	//MARK: - SetUpUI
    override func setUpUI(){
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        CommonUI.setUpLbl(lbl: enterCodeLbl, text: CommonFunctions.localisation(key: "ENTER_CODE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: wehaveSentCodeLbl, text: CommonFunctions.localisation(key: "CONFIRMATION_CODE"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: phoneNumberLbl, text: "\(userData.shared.countryCode) \(userData.shared.phone_no)", textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))

        let tfs : [otpTextField] = [tf1,tf2,tf3, tf4,tf5,tf6]
        for tf in tfs {
            tf.delegate = self
            tf.otpDelegate = self
            tf.font = UIFont.MabryProMedium(Size.Large.sizeValue())
            CommonUI.setUpViewBorder(vw: tf, radius: 16, borderWidth: 1.5, borderColor: UIColor.greyColor.cgColor)
        }
        
        CommonUI.setUpButton(btn: resendBtn, text: "\(CommonFunctions.localisation(key: "RESEND_CODE_COULD_BE_SEND")) 00:\(time)", textcolor: UIColor.SecondarytextColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.primaryTextcolor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.resendBtn.addTarget(self, action: #selector(resendCodeButton), for: .touchUpInside)
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        
        hitTimer()
        let tapp = UITapGestureRecognizer(target: self, action: #selector(outerTapped))
        self.outerView.addGestureRecognizer(tapp)
        
      
    }
}

//MARK: - Text Field Delegates
extension StrongAuthOTPVerifyVC: UITextFieldDelegate{
    
    func textFieldDidDelete(_ tf: UITextField) {
        switch tf {
        case tf1:
                tf1.becomeFirstResponder()
        case tf2:
                tf1.becomeFirstResponder()
        case tf3:
                tf2.becomeFirstResponder()
        case tf4:
                tf3.becomeFirstResponder()
        case tf5:
                tf4.becomeFirstResponder()
        case tf6:
                tf5.becomeFirstResponder()
            
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
                if tf1 == textField{
                    tf2.becomeFirstResponder()
                }else if tf2 == textField{
                    tf3.becomeFirstResponder()
                }else if tf3 == textField{
                    tf4.becomeFirstResponder()
                }else if tf4 == textField{
                    tf5.becomeFirstResponder()
                }else if tf5 == textField{
                    tf6.becomeFirstResponder()
                }else if tf6 == textField{
                    tf6.resignFirstResponder()
                }
                if tf1.text != "" && tf2.text != "" && tf3.text != "" && tf4.text != "" && tf5.text != "" && tf6.text != ""{
                    let otp = "\(tf1.text ?? "")\(tf2.text ?? "")\(tf3.text ?? "")\(tf4.text ?? "")\(tf5.text ?? "")\(tf6.text ?? "")"
                    strongAuthOTPVerifyVM.verifyStrongAuthApi(otp: otp, completion: {[]response in
						if response != nil{
                            self.dismiss(animated: true, completion: nil)
                            self.strongAuthCallback?()
                            userData.shared.strongAuthVerified = true
                            userData.shared.dataSave()
                        }

                    })
                }
            }
        return newString.length <= maxLength
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tf1{
            CommonUI.setUpViewBorder(vw: self.tf1, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == tf2{
            CommonUI.setUpViewBorder(vw: self.tf2, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == tf3{
            CommonUI.setUpViewBorder(vw: self.tf3, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == tf4{
            CommonUI.setUpViewBorder(vw: self.tf4, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == tf5{
            CommonUI.setUpViewBorder(vw: self.tf5, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == tf6{
            CommonUI.setUpViewBorder(vw: self.tf6, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf1{
            CommonUI.setUpViewBorder(vw: self.tf1, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == tf2{
            CommonUI.setUpViewBorder(vw: self.tf2, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == tf3{
            CommonUI.setUpViewBorder(vw: self.tf3, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == tf4{
            CommonUI.setUpViewBorder(vw: self.tf4, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == tf5{
            CommonUI.setUpViewBorder(vw: self.tf5, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == tf6{
            CommonUI.setUpViewBorder(vw: self.tf6, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }

}

//MARK: - Other functions
extension StrongAuthOTPVerifyVC{
    
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
        cancelCallBack?()
    }
    
    @objc func outerTapped(){
        self.dismiss(animated: true, completion: nil)
        cancelCallBack?()
    }
    
    @objc func resendCodeButton(){
        time = 30
        self.resendBtn.setTitleColor(UIColor.SecondarytextColor, for: .normal)
        resendBtn.setTitle("\(CommonFunctions.localisation(key: "RESEND_CODE_COULD_BE_SEND")) 00:\(time)", for:.normal)
        self.hitTimer()
    }
    
    func hitTimer(){
        resendBtn.isUserInteractionEnabled = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func keyboardAppear(_ notification: NSNotification){
           if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//               let bottomSafeArea = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
               bottomConst.constant = (keyboardSize.height + 24)
               UIView.animate(withDuration: 0.3) {
                   self.view.layoutIfNeeded()
               }
           }
       }
   
       @objc func keyboardHide(_ notification: NSNotification){
           if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
               bottomConst.constant = 24
               UIView.animate(withDuration: 0.2) {
                   self.view.layoutIfNeeded()
               }
           }
       }
    
    @objc func fireTimer(){
        if self.time > 0{
            self.time -= 1
            var tempString = "\(CommonFunctions.localisation(key: "RESEND_CODE_COULD_BE_SEND")) 00:\(self.time)"
            if time < 10{
                tempString = "\(CommonFunctions.localisation(key: "RESEND_CODE_COULD_BE_SEND")) 00:0\(self.time)"
            }
            UIView.performWithoutAnimation {
                self.resendBtn.setTitle(tempString, for: .normal)
                self.resendBtn.layoutIfNeeded()
            }
            resendBtn.isUserInteractionEnabled = false
        }else{
            self.timer.invalidate()
            UIView.performWithoutAnimation {
                self.resendBtn.setTitle(CommonFunctions.localisation(key: "RESEND_CODE"), for:.normal)
                self.resendBtn.setTitleColor(UIColor.PurpleColor, for: .normal)
                self.resendBtn.layoutIfNeeded()
            }
            resendBtn.isUserInteractionEnabled = true
        }
    }
}
