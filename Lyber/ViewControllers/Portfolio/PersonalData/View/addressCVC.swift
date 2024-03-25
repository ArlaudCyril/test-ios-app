//
//  addressCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import UIKit
import DropDown
import CountryPickerView
import IQKeyboardManagerSwift
import GooglePlaces

class addressCVC: UICollectionViewCell {
    //MARK: - Variables
    var controller : PersonalDataVC?
    var dropDown = DropDown()
    //MARK:- IB OUTLETS
    @IBOutlet var addressTitleLbl: UILabel!
    @IBOutlet var addressDescLbl: UILabel!
    
    @IBOutlet var addressVw: UIView!
    @IBOutlet var addressTF: UITextField!
    
    @IBOutlet var cityVw: UIView!
    @IBOutlet var cityTF: UITextField!
    
    @IBOutlet var zipCodeVw: UIView!
    @IBOutlet var zipCodeTF: UITextField!
    
    @IBOutlet var countryVw: CountryPickerView!
    @IBOutlet var countryTF: UITextField!
    
    @IBOutlet var specifiedUSPersonVw: UIView!
    @IBOutlet var specifiedUSPersonLbl: UILabel!
    
    override func awakeFromNib() {
		IQKeyboardManager.shared.enable = true
    }
}

extension addressCVC{
    func setUpCell(){
        CommonUI.setUpLbl(lbl: self.addressTitleLbl, text: CommonFunctions.localisation(key: "POSTAL_ADDRESS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.addressDescLbl, text: CommonFunctions.localisation(key: "NEED_INFORMATIONS_LEGAL"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.addressDescLbl, text: CommonFunctions.localisation(key: "NEED_INFORMATIONS_LEGAL"), lineSpacing: 6, textAlignment: .left)
        CommonUI.setUpLbl(lbl: self.specifiedUSPersonLbl, text: CommonFunctions.localisation(key: "ARE_YOU_A_US_CITIZEN"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.addressVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpViewBorder(vw: self.specifiedUSPersonVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        
        CommonUI.setUpTextField(textfield: addressTF, placeholder: CommonFunctions.localisation(key: "ADDRESS"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: cityTF, placeholder: CommonFunctions.localisation(key: "CITY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: zipCodeTF, placeholder: CommonFunctions.localisation(key: "ZIPCODE"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: countryTF, placeholder: CommonFunctions.localisation(key: "COUNTRY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        countryTF.textColor = UIColor.Purple35126D
        
        self.countryVw.delegate = self
        self.countryVw.dataSource = self
        
		self.countryVw.customizeView()
        let tfs = [addressTF,cityTF,zipCodeTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
			tf?.autocapitalizationType = .words
            tf?.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        }
        let addressTextFieldTap = UITapGestureRecognizer(target: self, action: #selector(autocompleteClicked))
        self.addressTF .addGestureRecognizer(addressTextFieldTap)
        
        let specifiedUsPersonVwTap = UITapGestureRecognizer(target: self, action: #selector(IsUsPerson))
        self.specifiedUSPersonVw.addGestureRecognizer(specifiedUsPersonVwTap)
    }
    
    func setPersonalData(){
		self.addressTF.text = userData.shared.address
        self.cityTF.text = userData.shared.city
        self.zipCodeTF.text = userData.shared.zipCode
        //self.countryVw.setCountryByCode(userData.shared.country)
		self.countryVw.setCountryByName(userData.shared.country)
        
        self.specifiedUSPersonLbl.text = userData.shared.isUsCitizen
        self.specifiedUSPersonLbl.textColor = UIColor.Purple35126D
        DispatchQueue.main.async {
            self.controller?.address = self.addressTF.text ?? ""
            self.controller?.CityName = self.cityTF.text ?? ""
            self.controller?.zipCode = self.zipCodeTF.text ?? ""
            self.controller?.CountryName = self.countryTF.text ?? ""
            self.controller?.isUsPerson = self.specifiedUSPersonLbl.text ?? ""
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
        if textField == addressTF{
            self.cityTF.becomeFirstResponder()
        }else if textField == cityTF{
            self.zipCodeTF.becomeFirstResponder()
        }else if textField == zipCodeTF{
            self.zipCodeTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == addressTF{
            return (newString.length <= 30 )
        }else if textField == cityTF{
//            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
//                return false
//            }
            return (newString.length <= 30 )
        }else if textField == zipCodeTF{
            return (newString.length <= 10 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressTF{
            CommonUI.setUpViewBorder(vw: self.addressVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == cityTF{
            CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == zipCodeTF{
            CommonUI.setUpViewBorder(vw: self.zipCodeVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == countryTF{
            CommonUI.setUpViewBorder(vw: self.countryVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == addressTF{
            CommonUI.setUpViewBorder(vw: self.addressVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == cityTF{
            CommonUI.setUpViewBorder(vw: self.cityVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
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
        if tf == addressTF{
            self.controller?.address = tf.text ?? ""
        }else if tf == cityTF{
            self.controller?.CityName = tf.text ?? ""
        }else if tf == zipCodeTF{
            self.controller?.zipCode = tf.text ?? ""
        }
    }
    
}

//MARK: - COUNTRY PICKER DELEGATES
extension addressCVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.countryTF.text = country.name
        self.controller?.CountryName = country.name
    }
	
	func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
		if userData.shared.language == "fr"{
			return Locale(identifier: "fr_FR")
		}else{
			return Locale(identifier: "en_GB")
		}
	}
	
	func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
		return ["FR"].compactMap { countryPickerView.getCountryByCode($0) }
	}
	
	func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
		return "Preferred country"
	}
}

//MARK: - Other functions
extension addressCVC{
    @objc func autocompleteClicked(_ sender: UIView) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = [.name, .addressComponents]
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.types = ["address"]
        filter.countries = [self.countryVw.selectedCountry.code]
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        self.controller?.present(autocompleteController, animated: true, completion: nil)
      }
    
    @objc func IsUsPerson(){
        
        dropDown.dataSource = [CommonFunctions.localisation(key: "YES"),CommonFunctions.localisation(key: "NO")]
        dropDown.backgroundColor = UIColor.PurpleGrey_50
        dropDown.cornerRadius = 8
        dropDown.textFont = UIFont.MabryPro(Size.Large.sizeValue())
        dropDown.anchorView = specifiedUSPersonVw
        dropDown.bottomOffset = CGPoint(x: 0, y: specifiedUSPersonVw.frame.height)
        dropDown.show()
        dropDown.selectionAction = {[weak self] (index: Int,item: String) in
            self?.specifiedUSPersonLbl.text = item
            self?.controller?.isUsPerson = item
            self?.specifiedUSPersonLbl.textColor = UIColor.Purple35126D
        }
    }
}

extension addressCVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.addressTF.text = place.name
        self.controller?.address = place.name ?? ""
        if let addressComponents = place.addressComponents {
               var city: String?
               var postalCode: String?
               
               for component in addressComponents {
                   if component.types.contains("locality") {
                       city = component.name
                   } else if component.types.contains("postal_code") {
                       postalCode = component.name
                   }
               }
            self.cityTF.text = city
            self.controller?.CityName = city ?? ""
            self.zipCodeTF.text = postalCode
            self.controller?.zipCode = postalCode ?? ""
           }
        self.controller?.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
      print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.controller?.dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }

  }
