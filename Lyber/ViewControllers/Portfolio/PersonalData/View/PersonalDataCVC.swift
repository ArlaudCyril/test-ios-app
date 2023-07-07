//
//  PersonalDataCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit
import ADCountryPicker
import DropDown
import CountryPickerView

class PersonalDataCVC: UICollectionViewCell {
    //MARK: - Variables
    var personalDataFilled : (()->())?
    var controller : PersonalDataVC?
    var dropDown = DropDown()
    var isNationalityTap : Bool = false
    //MARK: - IB OUTLETS
    @IBOutlet var personalDataLbl: UILabel!
    @IBOutlet var personalDataDescLbl: UILabel!
    @IBOutlet var nameVw: UIView!
    @IBOutlet var nameTF: UITextField!
    @IBOutlet var lastNameVw: UIView!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var birthPlaceVw: UIView!
    @IBOutlet var birthPlaceTF: UITextField!
    @IBOutlet var birthDateVw: UIView!
    @IBOutlet var birthDateBtn: UIButton!
    @IBOutlet var birthCountryVw: CountryPickerView!
    @IBOutlet var birthCountryLbl: UILabel!
    @IBOutlet var nationalityVw: CountryPickerView!
    @IBOutlet var NationalityLbl: UILabel!
	@IBOutlet var specifiedUSPersonVw: UIView!
	@IBOutlet var specifiedUSPersonLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SetUpCell()
    }
    
}
//Mark:- SetUpUI
extension PersonalDataCVC{
    func SetUpCell(){
        CommonUI.setUpLbl(lbl: self.personalDataLbl, text: CommonFunctions.localisation(key: "PERSONAL_DATA"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpTextField(textfield: self.nameTF, placeholder: CommonFunctions.localisation(key: "FIRST_NAME"), font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpTextField(textfield: self.lastNameTF, placeholder: CommonFunctions.localisation(key: "LAST_NAME"), font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		CommonUI.setUpTextField(textfield: self.birthPlaceTF, placeholder: CommonFunctions.localisation(key: "BIRTH_PLACE"), font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.personalDataDescLbl, text: CommonFunctions.localisation(key: "FOR_LEGAL_REASONS"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.personalDataDescLbl, text: CommonFunctions.localisation(key: "FOR_LEGAL_REASONS"), lineSpacing: 6, textAlignment: .left)
        let Views = [self.nameVw,self.lastNameVw,self.birthPlaceVw,self.birthDateVw,self.birthCountryVw,self.nationalityVw,self.specifiedUSPersonVw]
        for vw in Views{
            CommonUI.setUpViewBorder(vw: vw ?? UIView(), radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        }
        
        self.nameTF.delegate = self
        self.lastNameTF.delegate = self
        self.birthPlaceTF.delegate = self
        self.nameTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.lastNameTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        self.birthPlaceTF.font = UIFont.MabryPro(Size.XLarge.sizeValue())
        CommonUI.setUpButton(btn: self.birthDateBtn, text: CommonFunctions.localisation(key: "BIRTH_DATE"), textcolor: UIColor.TFplaceholderColor, backgroundColor: UIColor.white, cornerRadius: 16, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.birthCountryLbl, text: CommonFunctions.localisation(key: "BIRTH_COUNTRY"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.NationalityLbl, text: CommonFunctions.localisation(key: "NATIONALITY"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
		CommonUI.setUpLbl(lbl: self.specifiedUSPersonLbl, text: CommonFunctions.localisation(key: "ARE_YOU_A_US_CITIZEN"), textColor: UIColor.TFplaceholderColor, font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        
        let birthTap = UITapGestureRecognizer(target: self, action: #selector(selectBirthDate))
        self.birthDateVw.addGestureRecognizer(birthTap)
        
        let birthCountryTap = UITapGestureRecognizer(target: self, action: #selector(selectNationality))
        self.birthCountryVw.addGestureRecognizer(birthCountryTap)
        self.birthCountryVw.delegate = self
        self.birthCountryVw.customizeView()
        
        let nationalityTap = UITapGestureRecognizer(target: self, action: #selector(selectNationality(_: )))
        self.nationalityVw.addGestureRecognizer(nationalityTap)
        self.nationalityVw.delegate = self
		self.nationalityVw.customizeView()
        
		let specifiedUsPersonVwTap = UITapGestureRecognizer(target: self, action: #selector(IsUsPerson))
		self.specifiedUSPersonVw.addGestureRecognizer(specifiedUsPersonVwTap)
		
        self.nameTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        self.lastNameTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        self.birthPlaceTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
    }
    
    func setPersonalDate (data : UserPersonalData?){
        self.nameTF.text = data?.first_name ?? ""
        self.lastNameTF.text = data?.last_name ?? ""
        self.birthPlaceTF.text = data?.birth_place ?? ""
		self.specifiedUSPersonLbl.text = data?.specifiedUSPerson == true ? L10n.Yes.description : L10n.No.description
		self.birthDateBtn.setTitle(CommonFunctions.getDateFormat(date: data?.dob ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMM yyyy"), for: .normal)
        self.birthCountryLbl.text = countryName(from: data?.birth_country ?? "")
        self.NationalityLbl.text = countryName(from: data?.birth_country ?? "")
        
        self.controller?.firstName = self.nameTF.text ?? ""
        self.controller?.lastName = self.lastNameTF.text ?? ""
        self.controller?.birthPlace = self.birthPlaceTF.text ?? ""
		self.controller?.isUsPerson = self.specifiedUSPersonLbl.text ?? ""
        self.controller?.birthDate = CommonFunctions.getDateFormat(date: data?.dob ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "yyyy-mm-dd")
        self.controller?.birthCountry = data?.birth_country ?? ""
        self.controller?.nationality = data?.nationality ?? ""
        
		self.specifiedUSPersonLbl.textColor = UIColor.Purple35126D
        self.birthCountryLbl.textColor = UIColor.Purple35126D
        self.NationalityLbl.textColor = UIColor.Purple35126D
        self.birthDateBtn.setTitleColor(UIColor.Purple35126D, for: .normal)
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
extension PersonalDataCVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF{
            self.lastNameTF.becomeFirstResponder()
        }else if textField == lastNameTF{
            self.birthPlaceTF.becomeFirstResponder()
        }else if textField == birthPlaceTF{
            self.birthPlaceTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        if textField == nameTF{
            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
                return false
            }
            return (newString.length <= 30 )
        }else if textField == lastNameTF{
            if (string.rangeOfCharacter(from: NSCharacterSet.letters.inverted)) != nil && string.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil{
                return false
            }
            return (newString.length <= 30 )
        }else if textField == birthPlaceTF{
            return (newString.length <= 70 )
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameTF{
            CommonUI.setUpViewBorder(vw: self.nameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == lastNameTF{
            CommonUI.setUpViewBorder(vw: self.lastNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == birthPlaceTF{
            CommonUI.setUpViewBorder(vw: self.birthPlaceVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF{
            CommonUI.setUpViewBorder(vw: self.nameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == lastNameTF{
            CommonUI.setUpViewBorder(vw: self.lastNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == birthPlaceTF{
            CommonUI.setUpViewBorder(vw: self.birthPlaceVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - IB OUTLETS
extension PersonalDataCVC{
    @objc func selectBirthDate(){
        let vc = calenderVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        self.controller?.present(vc, animated: true, completion: nil)
        vc.dateCallBack = { birthDate,dob in
            self.birthDateBtn.setTitle(birthDate, for: .normal)
            self.controller?.birthDate = dob
            self.birthDateBtn.setTitleColor(UIColor.Purple35126D, for: .normal)
        }
    }
    
    @objc func selectNationality(_ sender : UITapGestureRecognizer){
//        if sender.view?.tag == 1{
//            isNationalityTap = true
//        }
        
//        let picker = ADCountryPicker()
//        picker.delegate = self
//        let pickerNavigationController = UINavigationController(rootViewController: picker)
//        pickerNavigationController.modalPresentationStyle = .fullScreen
//        pickerNavigationController.modalTransitionStyle = .coverVertical
//        self.controller?.present(pickerNavigationController, animated: true, completion: nil)
        
    }
    
    @objc func editChange(_ tf : UITextField){
        if tf == nameTF{
            self.controller?.firstName = tf.text ?? ""
        }else if tf == lastNameTF{
            self.controller?.lastName = tf.text ?? ""
        }else if tf == birthPlaceTF{
            self.controller?.birthPlace = tf.text ?? ""
        }
    }
}

//MARK: - Other functions
extension PersonalDataCVC{
	@objc func IsUsPerson(){
		dropDown.dataSource = [CommonFunctions.localisation(key: "YES"),CommonFunctions.localisation(key: "NO")]
		dropDown.selectionBackgroundColor = UIColor.LightPurple
		dropDown.backgroundColor = UIColor.white
		dropDown.layer.cornerRadius = 6
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


//MARK: - COUNTRY PICKER DELEGATES
extension PersonalDataCVC: ADCountryPickerDelegate, CountryPickerViewDelegate{
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
//        if isNationalityTap == true{
//            self.NationalityLbl.text = name
//            self.controller?.nationality = code
//            self.NationalityLbl.textColor = UIColor.Purple35126D
//            self.isNationalityTap = false
//        }else{
//            self.birthCountryLbl.text = name
//            self.controller?.birthCountry = code
//            self.birthCountryLbl.textColor = UIColor.Purple35126D
//        }
//        self.controller?.dismiss(animated: true, completion: nil)
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        if countryPickerView == nationalityVw{
            self.NationalityLbl.text = country.name
            self.controller?.nationality = country.code
            self.NationalityLbl.textColor = UIColor.Purple35126D
            self.isNationalityTap = false
        }else{
            self.birthCountryLbl.text = country.name
            self.controller?.birthCountry = country.name
            self.birthCountryLbl.textColor = UIColor.Purple35126D
        }
    }
    
}


