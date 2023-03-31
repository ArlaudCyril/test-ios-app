//
//  PersonalDataVC.swift
//  Lyber
//
//  Created by sonam's Mac on 30/05/22.
//

import UIKit
import IQKeyboardManagerSwift
import JWTDecode

class PersonalDataVC: ViewController {
    //MARK: - Variables
    var personalDataVM = PersonalDataVM()
    var fromLoginScreen = false
    var openFromLink = false
    var currentPage : Int = 0
    var indicatorView : [UIView]!
    var indicatorViewsWidth : [NSLayoutConstraint]!
    var firstName = String(),lastName = String(),birthPlace = String(), birthDate = String(),birthCountry = String(), nationality = String(),isUsPerson = String(),email = String(),emailPassword = String(),streetNumber = String(),buildingFloor = String(),CityName = String(),stateName = String(),zipCode = String(),CountryName = String(),investmentExp = String(),sourceOfIncome = String(),workIndustry = String(),annualIncome = String(),personalAssets = String(),isEditData = false
//    var personalData : [personalDataStruct] = []
    var personalData : personalDataStruct?,userPersonalDetail : UserPersonalData?
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextBtnView: UIView!
    @IBOutlet var nextButton: PurpleButton!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet var indicator1: UIView!
    @IBOutlet var indicator2: UIView!
    @IBOutlet var indicator3: UIView!
    @IBOutlet var indicator4: UIView!
    @IBOutlet var indicator5: UIView!
    @IBOutlet var indicatorViewsWidth1: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth2: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth3: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth4: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth5: NSLayoutConstraint!
    
    override func viewDidLoad() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setUpUI()
        callGetDataApi()
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        goToStep()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.hideKeyboardWhenTappedAround()
        indicatorView = [indicator1,indicator2,indicator3,indicator4,indicator5]
        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3,indicatorViewsWidth4,indicatorViewsWidth5]
        
        self.headerView.headerLbl.isHidden = true
        collView.delegate = self
        collView.dataSource = self
        self.LoadNibFiles()
        self.setIndicatorViews()
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
        

        goToStep()
        
    }
}


//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension PersonalDataVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalDataCVC", for: indexPath as IndexPath) as! PersonalDataCVC
            cell.controller = self
            if isEditData{
                cell.setPersonalDate(data: self.userPersonalDetail )
            }
            return cell
        }else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emailAddressCVC", for: indexPath as IndexPath) as! emailAddressCVC
            cell.controller = self
            if isEditData{
                cell.setPersonalDate(data: self.userPersonalDetail )
            }
            return cell
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerificationEmailCVC", for: indexPath as IndexPath) as! VerificationEmailCVC
            cell.controller = self
            cell.setUpCell()
            cell.verificationEmailCallBack = {[]otp in
                self.checkEmailVerification(code : otp)
            }
            
            return cell

        }else if indexPath.item == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addressCVC", for: indexPath as IndexPath) as! addressCVC
            cell.controller = self
            if isEditData{
                cell.setPersonalDate(data: self.userPersonalDetail )
            }
            return cell
        }else if indexPath.item == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestmentExperienceCVC", for: indexPath as IndexPath) as! InvestmentExperienceCVC
            cell.controller = self
            if isEditData{
                cell.setPersonalDate(data: self.userPersonalDetail )
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.layer.bounds.width, height: collView.layer.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
}

//MARK: - objective functions
extension PersonalDataVC{
    @objc func backBtnAct(){
        if fromLoginScreen == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            if self.currentPage == 2{
                let indexPath = NSIndexPath(item: (currentPage) - 1, section: 0)
                self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func nextBtnAct(){
            if currentPage == 0{
                checkPersonalDataValidation()
            }else if currentPage == 1{
                checkEmailAddressValidation()
            }else if currentPage == 2{
                
            }else if currentPage == 3{
                checkAdddressValidation()
            }else if currentPage == 4{
                checkInvestmentExperienceValidation()
            }else{
                GotoNextIndex()
           }
    }
}

//MARK: - SCROLLVIEW DELEGATES FUNTION
extension PersonalDataVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x + scrollView.frame.width/2)/scrollView.frame.width
        if Int(value) != self.currentPage{
            self.currentPage = (Int(value))
            self.setIndicatorViews()
        }
    }
    
    func goToStep(){
        if self.fromLoginScreen == true{
            DispatchQueue.main.async {
                let indexPath = NSIndexPath(item: 2, section: 0)
                self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
            }
        }else{
            if openFromLink == true{
                DispatchQueue.main.async {
                    let indexPath = NSIndexPath(item: 2, section: 0)
                    self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
                }
            }else{
                if userData.shared.personalDataStepComplete == 1{
                    DispatchQueue.main.async {
                        let indexPath = NSIndexPath(item: 1, section: 0)
                        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
                    }
                }else if userData.shared.personalDataStepComplete == 3{
                    DispatchQueue.main.async {
                        let indexPath = NSIndexPath(item: 3, section: 0)
                        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
                    }
                }else if userData.shared.personalDataStepComplete == 4{
                    DispatchQueue.main.async {
                        let indexPath = NSIndexPath(item: 4, section: 0)
                        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
                    }
                }
            }
            
        }
    }
}

//MARK: - Other functions
extension PersonalDataVC{
    func LoadNibFiles(){
        let personalDataNib : UINib =  UINib(nibName: "personalDataXib", bundle: nil)
        collView.register(personalDataNib, forCellWithReuseIdentifier: "PersonalDataCVC")
        
        let EmailAddressNib : UINib =  UINib(nibName: "EmailAddressXib", bundle: nil)
        collView.register(EmailAddressNib, forCellWithReuseIdentifier: "emailAddressCVC")
        
        let VerificationEmailNib : UINib =  UINib(nibName: "VerificationEmailXib", bundle: nil)
        collView.register(VerificationEmailNib, forCellWithReuseIdentifier: "VerificationEmailCVC")
        
        let addressNib : UINib =  UINib(nibName: "addressXib", bundle: nil)
        collView.register(addressNib, forCellWithReuseIdentifier: "addressCVC")
        
        let InvestmentExperienceNib : UINib =  UINib(nibName: "InvestmentExperienceXib", bundle: nil)
        collView.register(InvestmentExperienceNib, forCellWithReuseIdentifier: "InvestmentExperienceCVC")
    }
    
    func GotoNextIndex(){
        let indexPath = NSIndexPath(item: (self.currentPage ) + 1, section: 0)
        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
    }
    
    func GotoPreviousIndex(){
        let indexPath = NSIndexPath(item: (self.currentPage ) - 1, section: 0)
        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
    }
    
    func setIndicatorViews(){
        for (num,vw) in indicatorView.enumerated(){
            vw.layer.cornerRadius = 2
            if num == self.currentPage{
                vw.backgroundColor = UIColor.PurpleColor
                self.indicatorViewsWidth[num].constant = 32
            }else{
                vw.backgroundColor = UIColor.PurpleColor.withAlphaComponent(0.2)
                self.indicatorViewsWidth[num].constant = 4
            }
            if self.currentPage == 2{
                self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
                self.nextButton.isHidden = true
            }else{
                self.nextButton.isHidden = false
                self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
                self.headerView.backBtn.setImage(Assets.close.image(), for: .normal)
                if self.currentPage == 4{
                    self.nextButton.setTitle(CommonFunctions.localisation(key: "SEND_TO_LYBER"), for: .normal)
                }
            }
        
        }
    }
    
    func checkPersonalDataValidation(){
        if self.firstName.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster(Constants.AlertMessages.enterFirstName)
        }else if self.lastName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterLastName)
        }else if self.birthPlace == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterBirthPlace)
        }else if self.birthDate == ""{
            CommonFunctions.toster(Constants.AlertMessages.selectBirthDate)
        }else if self.birthCountry == ""{
            CommonFunctions.toster(Constants.AlertMessages.selectBirthCountry)
        }else if self.nationality == ""{
            CommonFunctions.toster(Constants.AlertMessages.selectNationality)
        }else if self.isUsPerson == ""{
            CommonFunctions.toster(Constants.AlertMessages.selectAreYouUSCitizen)
        }else{
//            GotoNextIndex()
			personalData = personalDataStruct(fisrtName: firstName, lastName: lastName, birthPlace: birthPlace, birthDate: birthDate, birthCountry: birthCountry, nationality: nationality, isUsPerson: isUsPerson, language: userData.shared.language)
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
            personalDataVM.personalDataApi(profile_info_step : 1,personalData: personalData, completion: {[weak self]response in
                self?.nextButton.hideLoading()
                self?.nextButton.isUserInteractionEnabled = true
                if let response = response{
                    print(response)
                    userData.shared.personalDataStepComplete = 1
                    userData.shared.dataSave()
                    self?.GotoNextIndex()
                }
            })
        }
    }
    
    func checkEmailAddressValidation(){
        if self.email.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster(Constants.AlertMessages.enterEmail)
        }else if email.isValidEmail() == false{
            CommonFunctions.toster(Constants.AlertMessages.enterValidEmail)
        }else if self.emailPassword == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterPassword)
        }else if emailPassword.count < 8{
            CommonFunctions.toster(Constants.AlertMessages.enterValidPassword)
        }else{
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
            personalDataVM.sendVerificationEmailApi(email: self.email,password : self.emailPassword, completion: {[weak self]response in
                self?.nextButton.hideLoading()
				userData.shared.email = self?.email ?? ""
				userData.shared.dataSave()
                self?.nextButton.isUserInteractionEnabled = true
                if response != nil{
                    self?.GotoNextIndex()
                }
            })
        }
    }
    
    func checkEmailVerification(code: String?){
        CommonFunctions.showLoader(self.view)
        personalDataVM.checkEmailVerificationApi(code: code , completion: {[self]response in
            CommonFunctions.hideLoader(self.view)
            if (response != nil){
                
                    print(response)
                    userData.shared.personalDataStepComplete = 3
                    userData.shared.dataSave()
                    self.GotoNextIndex()
            }else{
                CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
            }
            
        })
        
    }
    
    func checkAdddressValidation(){
        if self.streetNumber.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            CommonFunctions.toster(Constants.AlertMessages.enterStreetNumber)
        }else if self.buildingFloor.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterBuildingFloor)
        }else if self.CityName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterCity)
        }else if self.stateName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterState)
        }else if self.zipCode.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterZipcode)
        }else if self.zipCode.count < 5{
            CommonFunctions.toster(Constants.AlertMessages.enterValidZipcode)
        }else if self.CountryName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterCountry)
        }else{
//            GotoNextIndex()
            personalData = personalDataStruct(streetNumber: streetNumber, buildingFloor: buildingFloor, CityName: CityName, stateName: stateName, zipCode: zipCode, CountryName: CountryName, investmentExp: investmentExp, sourceOfIncome: sourceOfIncome, workIndustry: workIndustry, annualIncome: annualIncome, personalAssets: personalAssets)
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
            personalDataVM.setAddressApi(profile_info_step : 4,personalData: personalData, completion: {[weak self]response in
                self?.nextButton.hideLoading()
                self?.nextButton.isUserInteractionEnabled = true
                if let response = response{
                    print(response)
                    userData.shared.personalDataStepComplete = 4
                    userData.shared.dataSave()
                    self?.GotoNextIndex()
                }
            })
        }
    }
    
    func checkInvestmentExperienceValidation(){
        if self.investmentExp == ""{
            CommonFunctions.toster(Constants.AlertMessages.chooseInvestmentExp)
        }else if self.sourceOfIncome == ""{
            CommonFunctions.toster(Constants.AlertMessages.chooseSourceOfIncome)
        }else if self.workIndustry == ""{
            CommonFunctions.toster(Constants.AlertMessages.chooseWorkIndustry)
        }else if self.annualIncome == ""{
            CommonFunctions.toster(Constants.AlertMessages.chooseAnnualIncome)
        }else if self.personalAssets == ""{
            CommonFunctions.toster(Constants.AlertMessages.pleaseSelectPersonalAssets)
        }else{
            personalData = personalDataStruct(investmentExp: investmentExp, sourceOfIncome: sourceOfIncome, workIndustry: workIndustry, annualIncome: annualIncome, personalAssets: personalAssets)
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
			personalDataVM.setInvestmentExperienceApi(profile_info_step : 5,personalData: personalData, completion: {[weak self]response in
                if let response = response{
                    print(response)
                    self?.personalDataVM.finishRegistrationApi(completion: {[weak self]response in
                        self?.nextButton.hideLoading()
                        self?.nextButton.isUserInteractionEnabled = true
                        if let response = response{
                            userData.shared.isPersonalInfoFilled = true
                            userData.shared.time = Date()
                            GlobalVariables.isRegistering = false
                            userData.shared.userToken = response.data?.access_token ?? ""
                            userData.shared.refreshToken = response.data?.refresh_token ?? ""
                            userData.shared.dataSave()
                            //                            userData.shared.fromPersonalData(response)
                            
                            if self?.fromLoginScreen == true{
                                let vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
                                let navVC = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows[0].rootViewController = navVC
                                navVC.navigationController?.popToRootViewController(animated: true)
                                navVC.setNavigationBarHidden(true , animated: true)
                            }
                            self?.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }
    
    func callGetDataApi(){
        if isEditData == true{
            self.view.isUserInteractionEnabled = false
            CommonFunctions.showLoader(self.view)
            personalDataVM.getPersonalDataApi(completion: {[weak self] response in
                CommonFunctions.hideLoader(self?.view ?? UIView())
                self?.view.isUserInteractionEnabled = true
                if let response = response{
                    print(response)
                    self?.userPersonalDetail = response
                    self?.collView.reloadData()
                }
            })
        }
    }
}

