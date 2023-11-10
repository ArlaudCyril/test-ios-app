//
//  addressCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit
import CountryPickerView
import IQKeyboardManagerSwift

class addressCVC: UICollectionViewCell {
    //MARK: - Variables
    var controller : PersonalDataVC?
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
		IQKeyboardManager.shared.enable = true
    }
}

extension addressCVC{
    func setUpCell(){
        CommonUI.setUpLbl(lbl: self.addressLbl, text: CommonFunctions.localisation(key: "POSTAL_ADDRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressDescLbl, text: CommonFunctions.localisation(key: "NEED_INFORMATIONS_LEGAL"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.addressDescLbl, text: CommonFunctions.localisation(key: "NEED_INFORMATIONS_LEGAL"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpViewBorder(vw: self.streetNumberVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.buildingFloorVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.stateVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpTextField(textfield: buildingFloorTF, placeholder: CommonFunctions.localisation(key: "STREET_NAME"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: streetNumberTF, placeholder: CommonFunctions.localisation(key: "STREET_NUMBER"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: cityTF, placeholder: CommonFunctions.localisation(key: "CITY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: stateTF, placeholder: CommonFunctions.localisation(key: "DEPARTMENT"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: zipCodeTF, placeholder: CommonFunctions.localisation(key: "ZIPCODE"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: countryTF, placeholder: CommonFunctions.localisation(key: "COUNTRY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        countryTF.textColor = UIColor.Purple35126D
        
        self.countryVw.delegate = self
        self.countryVw.dataSource = self
        self.countryVw.customizeView()
        let tfs = [streetNumberTF,stateTF,buildingFloorTF,cityTF,zipCodeTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
			tf?.autocapitalizationType = .words
            tf?.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        }
    }
    
    func setPersonalData(){
		self.streetNumberTF.text = userData.shared.streetNumber
        self.buildingFloorTF.text = userData.shared.streetName
        self.cityTF.text = userData.shared.city
        self.stateTF.text = userData.shared.department
        self.zipCodeTF.text = userData.shared.zipCode
		self.countryVw.setCountryByCode(userData.shared.country)
        
        DispatchQueue.main.async {
            self.controller?.streetNumber = self.streetNumberTF.text ?? ""
            self.controller?.streetName = self.buildingFloorTF.text ?? ""
            self.controller?.CityName = self.cityTF.text ?? ""
            self.controller?.stateName = self.stateTF.text ?? ""
            self.controller?.zipCode = self.zipCodeTF.text ?? ""
            self.controller?.CountryName = self.countryTF.text ?? ""
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
            return true
        }else if textField == cityTF{
//            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
//                return false
//            }
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
            self.controller?.streetName = tf.text ?? ""
        }else if tf == cityTF{
            self.controller?.CityName = tf.text ?? ""
        }else if tf == stateTF{
            self.controller?.stateName = tf.text ?? ""
        }else if tf == zipCodeTF{
            self.controller?.zipCode = tf.text ?? ""
        }
    }
    
}

//MARK: - COUNTRY PICKER DELEGATES
extension addressCVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.countryTF.text = country.name
        self.controller?.CountryName = country.code
    }
	
	func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
		if userData.shared.language == "fr"{
			return Locale(identifier: "fr_FR")
		}else{
			return Locale(identifier: "en_GB")
		}
	}
}
