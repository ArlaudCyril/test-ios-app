//
//  EducationStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import UIKit

class EducationStrategyVC: ViewController {
    //MARK: - Variables
    var educationReadCallback : (()->())?
    var currentPage : Int? = 0,educationStrategyVM = EducationStrategyVM()
    var indicatorView : [UIView]!
    var indicatorViewsWidth : [NSLayoutConstraint]!
    let collData : [educationModel] =
    [educationModel(image: Assets.slider_one.image(), desc: CommonFunctions.localisation(key: "DIVERSIFIED_STRATEGY"), subDesc: CommonFunctions.localisation(key: "EDUCATION_SUBDESCRIPTION_1")),
     educationModel(image: Assets.slider_two.image(), desc: CommonFunctions.localisation(key: "FLEXIBLE_FREQUENCY"), subDesc: CommonFunctions.localisation(key: "EDUCATION_SUBDESCRIPTION_2")),
     educationModel(image: Assets.slider_one.image(), desc: CommonFunctions.localisation(key: "EVOLVING_AND_AUTOMATED_PORTFOLIO"), subDesc: CommonFunctions.localisation(key: "EDUCATION_SUBDESCRIPTION_3"))]
    
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var nextButton: PurpleButton!
    
    @IBOutlet var indicator1: UIView!
    @IBOutlet var indicator2: UIView!
    @IBOutlet var indicator3: UIView!
    @IBOutlet var indicatorViewsWidth1: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth2: NSLayoutConstraint!
    @IBOutlet var indicatorViewsWidth3: NSLayoutConstraint!
    @IBOutlet var stackViewBottomConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.collView.delegate = self
        self.collView.dataSource = self
        indicatorView = [indicator1,indicator2,indicator3]
        indicatorViewsWidth = [indicatorViewsWidth1,indicatorViewsWidth2,indicatorViewsWidth3]
        self.setIndicatorViews()
        
        self.backBtn.layer.cornerRadius = 12
        self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextBtnAct), for: .touchUpInside)
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension EducationStrategyVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EductaionStrategyCVC", for: indexPath as IndexPath) as! EductaionStrategyCVC
        cell.configureWithData(data: collData[indexPath.row],index : indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collView.layer.bounds.height)
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
extension EducationStrategyVC{
    @objc func backBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextBtnAct(){
        if currentPage ?? 0 > 1{
            self.nextButton.showLoading()
            educationStrategyVM.readEductionStrategyApi(completion: {[]response in
                self.nextButton.hideLoading()
                if response != nil{
//                    let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
//                    let nav = UINavigationController(rootViewController: vc)
//                    nav.modalPresentationStyle = .fullScreen
//                    nav.navigationBar.isHidden = true
//                    self.present(nav, animated: true, completion: nil)
                    userData.shared.isEducationStrategyRead = true
                    userData.shared.dataSave()
                    self.dismiss(animated: true, completion: nil)
                    self.educationReadCallback?()
//                    let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
//                    vc.popupType = .InvestInStrategiesOrAsset
//                    vc.portfolioHomeController = PortfolioHomeVC.self
//                    self.present(vc, animated: true, completion: nil)
                }
            })
        }else{
            let contentOffset = CGFloat(floor(self.collView.contentOffset.x + self.collView.bounds.size.width))
            let frame: CGRect = CGRect(x : contentOffset ,y : self.collView.contentOffset.y ,width : self.collView.frame.width,height : self.collView.frame.height)
            self.collView.scrollRectToVisible(frame, animated: true)
        }
    }
}

//MARK: - SCROLLVIEW DELEGATES FUNTION
extension EducationStrategyVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = (scrollView.contentOffset.x + scrollView.frame.width/2)/scrollView.frame.width
        if Int(value) != self.currentPage{
            self.currentPage = (Int(value))
            self.setIndicatorViews()
        }
    }
}

//MARK: - OTHER FUNCTION
extension EducationStrategyVC{
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
            if self.currentPage ?? 0 == 2{
                self.nextButton.tag = 1
                self.nextButton.setTitle(CommonFunctions.localisation(key: "CHOOSE_STRATEGY"), for: .normal)
            }else{
                self.nextButton.tag = 0
                self.nextButton.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
            }
        }
    }
}
