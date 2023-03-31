//
//  InvestmentStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit

class InvestmentStrategyVC: ViewController {
    //MARK: - Variables
    var investmentStrategyVM = InvestmentStrategyVM()
    var investmentStrategyTVC = InvestmentStrategyTVC()
    var isEducationStrategy : Bool = false
    var invstStrategyData : [Strategy] = []
    var selectedStrategy : Int!
    
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    //    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var investmentStratgyLbl: UILabel!
    @IBOutlet var strategyDescLbl: UILabel!
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var buildOwnStrategyBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var scrollView: UIScrollView!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpUI()
        
    }
    

	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: self.investmentStratgyLbl, text: CommonFunctions.localisation(key: "INVESTMENT_STRATEGIES"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.strategyDescLbl, text: CommonFunctions.localisation(key: "STRATEGIES_ARE_THERE_TO_HELP_YOU"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.strategyDescLbl, text: CommonFunctions.localisation(key: "STRATEGIES_ARE_THERE_TO_HELP_YOU"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpButton(btn: buildOwnStrategyBtn, text: CommonFunctions.localisation(key: "BUILD_MY_OWN_STRATEGY"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        CommonUI.setUpViewBorder(vw: bottomView, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
       
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.buildOwnStrategyBtn.addTarget(self, action: #selector(buildOwnStrategyBtnAct), for: .touchUpInside)
    }
}

//MARK: - table view delegates and dataSource
extension InvestmentStrategyVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invstStrategyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvestmentStrategyTVC")as! InvestmentStrategyTVC
        cell.setUpCell(data : invstStrategyData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yCell = tableView.cellForRow(at: indexPath)?.frame.minY ?? 0
       
        self.scrollView.setContentOffset(CGPoint(x: 0, y: yCell), animated: true)
        selectedStrategy = indexPath.row
        
        invstStrategyData[indexPath.row].isSelected = !(invstStrategyData[indexPath.row].isSelected ?? false)
        for i in 0...(invstStrategyData.count - 1){
            if invstStrategyData[i].name != invstStrategyData[indexPath.row].name{
                invstStrategyData[i].isSelected = false
            }
        }
       
        showModal(strategy: invstStrategyData[indexPath.row])
        tableView.reloadData()
    }
}

//MARK: - objective functions
extension InvestmentStrategyVC{
    @objc func cancelBtnAct(){
        if isEducationStrategy == true{
            let vc = PortfolioHomeVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            nav.navigationBar.isHidden = true
            self.present(nav, animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    @objc func buildOwnStrategyBtnAct(){
        let vc = AddStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        vc.investmentStrategyController = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
}

// MARK: - TABLE VIEW OBSERVER
extension InvestmentStrategyVC{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callGetStrategies()
		self.invstStrategyData.sort(by: {$0.publicType ?? "" < $1.publicType ?? "" })
        self.setUpUI()
        self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tblView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.tblView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                    self.tblViewHeightConst.constant = newSize.height
                }
            }
        }
    }
}
    //MARK: - Other functions
extension InvestmentStrategyVC{
        
    func showModal(strategy : Strategy){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        if(strategy.activeStrategy != nil)
        {
            vc.popupType = .investWithStrategiesActive
        }
        else{
            vc.popupType = .investWithStrategiesInactive
        }
        vc.strategy = strategy
        vc.investmentStrategyController = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func callGetStrategies(){
        CommonFunctions.showLoader(self.view)
        self.investmentStrategyVM.getInvestmentStrategiesApi(completion: {[weak self]response in
            CommonFunctions.hideLoader(self?.view ?? UIView())
            self?.invstStrategyData = response?.data ?? []
            self?.tblView.reloadData()
        })
    }
    
    func deselectAllStrategies(){
        for i in 0...(invstStrategyData.count - 1){
            invstStrategyData[i].isSelected = false
        }
        self.tblView.reloadData()
    }
    
    func deleteStrategy(strategy : Strategy){
        self.investmentStrategyVM.deleteStrategyApi(strategyName: strategy.name ?? "", completion: {[]response in
            if response != nil{
                for i in 0...(self.invstStrategyData.count - 1){
                    if(self.invstStrategyData[i].name == strategy.name && self.invstStrategyData[i].ownerUuid == strategy.ownerUuid){
                        self.invstStrategyData.remove(at: i)
                        break
                    }
                }
                self.tblView.reloadData()
            }
        })
    
    }
    
    func pauseStragegy(strategy: Strategy){
        self.investmentStrategyVM.pauseStrategyApi(strategyName: strategy.name ?? "", ownerUuid: strategy.ownerUuid ?? "", completion: {[]response in
            if response != nil{
              
                for i in 0...(self.invstStrategyData.count - 1){
                    if(self.invstStrategyData[i].name == strategy.name && self.invstStrategyData[i].ownerUuid == strategy.ownerUuid){
                        self.invstStrategyData[i].activeStrategy = nil
                    }
                }
                self.tblView.reloadData()
            }
        })
    }
    
    func tailorStrategy(strategy: Strategy){
        let vc = AddStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        vc.investmentStrategyController = self
        vc.tailoringStrategy = strategy
        vc.tailoring = true
        vc.getStrategy()
        self.present(vc, animated: true, completion: nil)
    }
}
