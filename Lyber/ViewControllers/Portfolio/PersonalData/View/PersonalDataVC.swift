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
    var currentPage : Int = 0
    var indicatorView : [UIView]!
    var indicatorViewsWidth : [NSLayoutConstraint]!
    var firstName = String(),lastName = String(),birthPlace = String(), birthDate = String(),birthCountry = String(), nationality = String(),isUsPerson = String(),address = String(),CityName = String(),zipCode = String(),CountryName = String(),investmentExp = String(),sourceOfIncome = String(),workIndustry = String(),annualIncome = String(),activity = String(),isEditData = false
//    var personalData : [personalDataStruct] = []
    var personalData : personalDataStruct?
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextBtnView: UIView!
    @IBOutlet var nextButton: PurpleButton!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    
    @IBOutlet var indicator1: UIView!
    @IBOutlet var indicator2: UIView!
    @IBOutlet var indicator3: UIView!
    @IBOutlet var indicatorViewsWidth1: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth2: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goToStep()
		self.navigationController?.navigationBar.isHidden = true
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.hideKeyboardWhenTappedAround()
        indicatorView = [indicator1,indicator2,indicator3]
        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3]
        
        self.headerView.headerLbl.isHidden = true
        collView.delegate = self
        collView.dataSource = self
        self.LoadNibFiles()
        self.setIndicatorViews()
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
		
		self.headerView.closeBtn.addTarget(self, action: #selector(closeBtnAct), for: .touchUpInside)
		self.headerView.closeBtn.isHidden = false
		
        self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        self.nextButton.addTarget(self, action: #selector(nextButtonAct), for: .touchUpInside)
        

        goToStep()
        
    }
}


//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension PersonalDataVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.item == 0{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalDataCVC", for: indexPath as IndexPath) as! PersonalDataCVC
//            cell.controller = self
//			cell.SetUpCell()
//            if isEditData{
//                cell.setPersonalData()
//            }
//            return cell
//        }else 
		if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addressCVC", for: indexPath as IndexPath) as! addressCVC
            cell.controller = self
			cell.setUpCell()
            if isEditData{
                cell.setPersonalData()
            }
            return cell
        }else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestmentExperienceCVC", for: indexPath as IndexPath) as! InvestmentExperienceCVC
            cell.controller = self
            if isEditData{
                cell.setPersonalData()
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
		self.GotoPreviousIndex()
		userData.shared.personalDataStepComplete = userData.shared.personalDataStepComplete - 1
    }
	
	@objc func closeBtnAct(){
		CommonFunctions.stopRegistration()
	}
    
    @objc func nextButtonAct(){
			if currentPage == 0{
                checkAdddressValidation()
            }else if currentPage == 1{
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
		if userData.shared.personalDataStepComplete == 1{
			DispatchQueue.main.async {
				let indexPath = NSIndexPath(item: 0, section: 0)
				self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
			}
		}else if userData.shared.personalDataStepComplete == 2{
			DispatchQueue.main.async {
				let indexPath = NSIndexPath(item: 1, section: 0)
				self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: false)
			}
		}
    }
}

//MARK: - Other functions
extension PersonalDataVC{
    func LoadNibFiles(){
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
			
			if self.currentPage == 0{
				self.headerView.backBtn.isHidden = true
			}else{
				self.headerView.backBtn.isHidden = false
			}
			
			self.nextButton.isHidden = false
			self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        
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
        }
    }
    
    
    func checkAdddressValidation(){
        if self.address.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterAddress)
        }else if self.CityName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterCity)
        }else if self.zipCode.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterZipcode)
        }else if self.CountryName.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            CommonFunctions.toster(Constants.AlertMessages.enterCountry)
        }else if self.isUsPerson == ""{
            CommonFunctions.toster(Constants.AlertMessages.selectAreYouUSCitizen)
        }else{
            let separatedAddress = separateAddress(address)
            print("Number: \(separatedAddress?.0 ?? "")") // Number: 71
            print("Street: \(separatedAddress?.1 ?? "")") // Street: rue de Canteleu
           
            personalData = personalDataStruct(isUsPerson: isUsPerson, street: separatedAddress?.1, streetNumber: separatedAddress?.0, CityName: CityName, zipCode: zipCode, CountryName: CountryName)
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
            personalDataVM.setAddressApi(personalData: personalData, completion: {[weak self]response in
                self?.nextButton.hideLoading()
                self?.nextButton.isUserInteractionEnabled = true
                if let response = response{
                    print(response)
                    userData.shared.personalDataStepComplete = 2
                    userData.shared.isUsCitizen = self?.isUsPerson ?? ""
					userData.shared.address = self?.address ?? ""
					userData.shared.city = self?.CityName ?? ""
					userData.shared.zipCode = self?.zipCode ?? ""
					userData.shared.country = self?.CountryName ?? ""
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
            CommonFunctions.toster(Constants.AlertMessages.chooseMonthlyIncome)
        }else if self.activity == ""{
            CommonFunctions.toster(Constants.AlertMessages.chooseActivity)
        }else{
            personalData = personalDataStruct(investmentExp: investmentExp, sourceOfIncome: sourceOfIncome, workIndustry: workIndustry, annualIncome: annualIncome, activity: activity)
            self.nextButton.showLoading()
            self.nextButton.isUserInteractionEnabled = false
			personalDataVM.setInvestmentExperienceApi(personalData: personalData, completion: {[weak self]response in
                if let response = response{
                    print(response)
					self?.nextButton.hideLoading()
					self?.nextButton.isUserInteractionEnabled = true
					userData.shared.personalDataStepComplete = 3
					userData.shared.stepRegisteringComplete = 2
					
					userData.shared.investmentExperience = self?.investmentExp ?? ""
					userData.shared.sourceOfIncome = self?.sourceOfIncome ?? ""
					userData.shared.workIndustry = self?.workIndustry ?? ""
					userData.shared.annualIncome = self?.annualIncome ?? ""
					userData.shared.activityOnLyber = self?.activity ?? ""
					userData.shared.dataSave()
					
					let vc = checkAccountCompletedVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
					self?.navigationController?.pushViewController(vc, animated: false)
					
                }
            })
        }
    }
    
    func separateAddress(_ address: String) -> (String, String)? {
        let regex = try! NSRegularExpression(pattern: "^\\s*(\\d+[a-zA-Z]?)(\\s+.*)", options: [])
        let range = NSRange(address.startIndex..., in: address)
        
        if let match = regex.firstMatch(in: address, options: [], range: range) {
            if match.numberOfRanges == 3 {
                let numberRange = Range(match.range(at: 1), in: address)!
                let streetRange = Range(match.range(at: 2), in: address)!
                
                let number = String(address[numberRange]).trimmingCharacters(in: .whitespaces)
                let street = String(address[streetRange]).trimmingCharacters(in: .whitespaces)
                
                return (number, street)
            }
        }
        return nil
    }
}

