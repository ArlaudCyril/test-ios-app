//
//  addressCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit
import ADCountryPicker
import CountryPickerView

class addressCVC: UICollectionViewCell {
    //MARK: - Variables
    var controller : PersonalDataVC?
    var picker = ADCountryPicker()
    //MARK:- IB OUTLETS
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var addressDescLbl: UILabel!
    @IBOutlet var streetNumberVw: UIView!
    @IBOutlet var streetNumberTF: UITextField!
    @IBOutlet var buildingFloorVw: UIView!
    @IBOutlet var buildingFloorTF: UITextField!
    @IBOutlet var cityVw: UIView!
    @IBOutlet var cityTF: UITextField!
    @IBOutlet var stateVw: UIView!
    @IBOutlet var stateTF: UITextField!
    @IBOutlet var zipCodeVw: UIView!
    @IBOutlet var zipCodeTF: UITextField!
    @IBOutlet var countryVw: CountryPickerView!
    @IBOutlet var countryTF: UITextField!
    
    override func awakeFromNib() {
        setUpCell()
    }
}

extension addressCVC{
    func setUpCell(){
        CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "ADDRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressDescLbl, text: CommonFunctions.localisation(key: "TO_ENSURE_CRYPTO_SERVICES_ARE_LEGAL"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.addressDescLbl, text: CommonFunctions.localisation(key: "TO_ENSURE_CRYPTO_SERVICES_ARE_LEGAL"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpViewBorder(vw: self.streetNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.buildingFloorVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.stateVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpTextField(textfield: buildingFloorTF, placeholder: CommonFunctions.localisation(key: "BUILDING_FLOOR"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: streetNumberTF, placeholder: CommonFunctions.localisation(key: "STREET_NUMBER"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: cityTF, placeholder: CommonFunctions.localisation(key: "CITY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: stateTF, placeholder: CommonFunctions.localisation(key: "STATE"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: zipCodeTF, placeholder: CommonFunctions.localisation(key: "ZIPCODE"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: countryTF, placeholder: CommonFunctions.localisation(key: "COUNTRY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        countryTF.textColor = UIColor.Purple35126D
        
        let countryTap = UITapGestureRecognizer(target: self, action: #selector(selectCountry))
        self.countryVw.addGestureRecognizer(countryTap)
        self.countryVw.delegate = self
        
        let tfs = [streetNumberTF,stateTF,buildingFloorTF,cityTF,zipCodeTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
            tf?.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        }
    }
    
    func setPersonalDate (data : UserPersonalData?){
        let addresss = data?.address1?.components(separatedBy: ",")
        self.streetNumberTF.text = addresss?[0] ?? ""
        self.buildingFloorTF.text = addresss?[1] ?? ""
        self.cityTF.text = data?.city ?? ""
        self.stateTF.text = data?.state ?? ""
        self.zipCodeTF.text = "\(data?.zip_code ?? 0)"
        self.countryTF.text = countryName(from: data?.country ?? "")
        
        DispatchQueue.main.async {
            self.controller?.streetNumber = self.streetNumberTF.text ?? ""
            self.controller?.buildingFloor = self.buildingFloorTF.text ?? ""
            self.controller?.CityName = self.cityTF.text ?? ""
            self.controller?.stateName = self.stateTF.text ?? ""
            self.controller?.zipCode = self.zipCodeTF.text ?? ""
            self.controller?.CountryName = data?.country ?? ""
        }
        
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
}

//MARK: - Text Field Delegates
extension addressCVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == streetNumberTF{
            self.buildingFloorTF.becomeFirstResponder()
        }else if textField == buildingFloorTF{
            self.cityTF.becomeFirstResponder()
        }else if textField == cityTF{
            self.stateTF.becomeFirstResponder()
        }else if textField == stateTF{
            self.zipCodeTF.becomeFirstResponder()
        }else if textField == zipCodeTF{
            self.zipCodeTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == streetNumberTF{
            return (newString.length <= 30 )
        }else if textField == buildingFloorTF{
            return (newString.length <= 30 )
        }else if textField == cityTF{
            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
                return false
            }
            return (newString.length <= 30 )
        }else if textField == stateTF{
            return (newString.length <= 30 )
        }else if textField == zipCodeTF{
            return (newString.length <= 10 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == streetNumberTF{
            CommonUI.setUpViewBorder(vw: self.streetNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == buildingFloorTF{
            CommonUI.setUpViewBorder(vw: self.buildingFloorVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == cityTF{
            CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == stateTF{
            CommonUI.setUpViewBorder(vw: self.stateVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == zipCodeTF{
            CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == countryTF{
            CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == streetNumberTF{
            CommonUI.setUpViewBorder(vw: self.streetNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == buildingFloorTF{
            CommonUI.setUpViewBorder(vw: self.buildingFloorVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == cityTF{
            CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == stateTF{
            CommonUI.setUpViewBorder(vw: self.stateVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == zipCodeTF{
            CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == countryTF{
            CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - objective functions
extension addressCVC{
    @objc func editChange(_ tf : UITextField){
        if tf == streetNumberTF{
            self.controller?.streetNumber = tf.text ?? ""
        }else if tf == buildingFloorTF{
            self.controller?.buildingFloor = tf.text ?? ""
        }else if tf == cityTF{
            self.controller?.CityName = tf.text ?? ""
        }else if tf == stateTF{
            self.controller?.stateName = tf.text ?? ""
        }else if tf == zipCodeTF{
            self.controller?.zipCode = tf.text ?? ""
        }
    }
    
    @objc func selectCountry(){
       
//        picker.delegate = self
//        let pickerNavigationController = UINavigationController(rootViewController: picker)
//        pickerNavigationController.modalTransitionStyle = .coverVertical
//        self.controller?.present(pickerNavigationController, animated: true, completion: nil)
    }
}

//MARK: - COUNTRY PICKER DELEGATES
extension addressCVC: ADCountryPickerDelegate,CountryPickerViewDelegate{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
//        self.countryTF.text = name
//        self.controller?.CountryName = code
//        self.picker.dismiss(animated: true, completion: nil)
    
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.countryTF.text = country.name
        self.controller?.CountryName = country.code
    }
}
