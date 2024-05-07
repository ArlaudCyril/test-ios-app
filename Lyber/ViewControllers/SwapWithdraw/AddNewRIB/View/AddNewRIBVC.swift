//
//  AddNewRIBVC.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 13/03/2024.
//

import UIKit
import CountryPickerView

class AddNewRIBVC: ViewController {
    //MARK: - Variables
    var isEditingRib = false
    var isAddingFromWithdraw = false
    var ribData : RibData?
    var addNewRIBVM = AddNewRIBVM()
    
    //MARK: @IBOutlet
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var ribNameVw: UIView!
    @IBOutlet var ribNameTF: UITextField!
    
    @IBOutlet var ibanVw: UIView!
    @IBOutlet var ibanTF: UITextField!
    
    @IBOutlet var bicVw: UIView!
    @IBOutlet var bicTF: UITextField!
    
    @IBOutlet var ownerNameVw: UIView!
    @IBOutlet var ownerNameTF: UITextField!
    
    @IBOutlet var bankCountryVw: CountryPickerView!
    @IBOutlet var bankCountryTF: UITextField!
    
    @IBOutlet var addBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    //MARK: - SetUpUI
    override func setUpUI(){
        self.headerView.headerLbl.text = CommonFunctions.localisation(key: "YOUR_NEW_RIB")
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        
        CommonUI.setUpTextField(textfield: ribNameTF, placeholder: CommonFunctions.localisation(key: "RIB_NAME"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: ibanTF, placeholder: CommonFunctions.localisation(key: "IBAN"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: bicTF, placeholder: CommonFunctions.localisation(key: "BIC"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: ownerNameTF, placeholder: CommonFunctions.localisation(key: "OWNER_NAME"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))
        CommonUI.setUpTextField(textfield: bankCountryTF, placeholder: CommonFunctions.localisation(key: "BANK_COUNTRY"), font: UIFont.MabryPro(Size.XLarge.sizeValue()))

        self.bankCountryTF.textColor = UIColor.Purple35126D
        self.bankCountryVw.delegate = self
        self.bankCountryVw.dataSource = self
        self.bankCountryVw.customizeView()
        
        let tfs = [ribNameTF,ibanTF,bicTF, ownerNameTF, bankCountryTF]
        for tf in tfs{
            tf?.delegate = self
            tf?.textColor = UIColor.Purple35126D
            tf?.tintColor = UIColor.Purple35126D
            tf?.autocapitalizationType = .words
        }
        
        let vws = [ribNameVw, ibanVw, bicVw, ownerNameVw, bankCountryVw]
        for vw in vws {
            CommonUI.setUpViewBorder(vw: vw ?? UIView(), radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        }
        
        self.addBtn.setTitle(CommonFunctions.localisation(key: "ADD"), for: .normal)
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        
        self.addBtn.addTarget(self, action: #selector(addBtnAct), for: .touchUpInside)
        
        if(self.isEditingRib){
            self.ribNameTF.text = self.ribData?.name
            self.ibanTF.text = self.ribData?.iban
            self.bicTF.text = self.ribData?.bic
            self.ownerNameTF.text = self.ribData?.userName
            self.bankCountryTF.text = self.ribData?.bankCountry
        }
    }
}

//MARK: - Text Field Delegates
extension AddNewRIBVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == ribNameTF{
            self.ibanTF.becomeFirstResponder()
        }else if textField == ibanTF{
            self.bicTF.becomeFirstResponder()
        }else if textField == bicTF{
            self.ownerNameTF.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == ribNameTF{
            CommonUI.setUpViewBorder(vw: self.ribNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == ibanTF{
            CommonUI.setUpViewBorder(vw: self.ibanVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == bicTF{
            CommonUI.setUpViewBorder(vw: self.bicVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }else if textField == ownerNameTF{
            CommonUI.setUpViewBorder(vw: self.ownerNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.PurpleColor.cgColor,backgroundColor: UIColor.LightPurple)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ribNameTF{
            CommonUI.setUpViewBorder(vw: self.ribNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == ibanTF{
            CommonUI.setUpViewBorder(vw: self.ibanVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == bicTF{
            CommonUI.setUpViewBorder(vw: self.bicVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }else if textField == ownerNameTF{
            CommonUI.setUpViewBorder(vw: self.ownerNameVw, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor,backgroundColor: UIColor.whiteColor)
        }
    }
}

//MARK: - objective functions
extension AddNewRIBVC{
    @objc func backBtnAct(){
        if(self.isAddingFromWithdraw){
            self.navigationController?.popViewController(animated: true)
        }else{
            if(!(self.navigationController?.popToViewController(ofClass: ExchangeFromVC.self) ?? false)){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func addBtnAct(){
        let iban = self.ibanTF.text ?? ""
        let bic = self.bicTF.text ?? ""
        let ribName = self.ribNameTF.text ?? ""
        let ownerName = self.ownerNameTF.text ?? ""
        let bankCountry = self.bankCountryTF.text ?? ""
        
        if !(containsValidData(input: iban) && containsValidData(input: bic) && containsValidData(input: ribName) && containsValidData(input: ownerName) && containsValidData(input: bankCountry)) {
            CommonFunctions.toster(CommonFunctions.localisation(key: "PLEASE_COMPLETE_FIELDS"))
        }else if(!containsOnlyLetters(input: ownerName)){
            CommonFunctions.toster(CommonFunctions.localisation(key: "OWNER_NAME_ONLY_LETTERS"))
        }else{
            
            if(self.isEditingRib){
                self.addNewRIBVM.deleteRisApi(ribId: ribData?.ribId ?? "", completion: {response in
                    if response != nil{
                        self.addNewRib(iban: iban, bic: bic, ribName: ribName, ownerName: ownerName, bankCountry: bankCountry)
                    }
                })
            }else{
                self.addNewRib(iban: iban, bic: bic, ribName: ribName, ownerName: ownerName, bankCountry: bankCountry)
            }
        }
        
    }
}

//MARK: - private functions
extension AddNewRIBVC{
    private func addNewRib(iban: String, bic: String, ribName: String, ownerName: String, bankCountry: String){
        self.addNewRIBVM.addRibApi(iban: iban, bic: bic, nameRib: ribName, ownerName: ownerName, bankCountry: bankCountry, completion: {response in
            if response != nil{
                AddNewRIBVM().getRibsApi(completion: {response in
                    if response != nil{
                        if(self.isAddingFromWithdraw){
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            let vc = WithdrawVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                            vc.typeWithdraw = .ribs
                            vc.ribsArray = response?.data ?? []
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                })
            }
        })
    }
    
    private func containsValidData(input: String) -> Bool {
        let trimmedText = input.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedText.isEmpty && trimmedText.range(of: "[a-zA-Z0-9]", options: .regularExpression) != nil
    }
    
    private func containsOnlyLetters(input: String) -> Bool {
        let allowedCharacterSet = CharacterSet.letters
        return input.rangeOfCharacter(from: allowedCharacterSet.inverted) == nil && !input.isEmpty
    }
}

//MARK: - COUNTRY PICKER DELEGATES
extension AddNewRIBVC: CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        self.bankCountryTF.text = country.name
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
    
    func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: CountryPickerViewController) {
        self.navigationController?.navigationBar.isHidden = false
    }
}

