//
//  InvestmentStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit

class InvestmentStrategyVC: UIViewController {
    //MARK: - Variables
    var investmentStrategyVM = InvestmentStrategyVM()
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
    @IBOutlet var chooseStrategyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpUI()
        
    }
    
    

}
//MARK: - SetUpUI
extension InvestmentStrategyVC{
    func setUpUI(){
        self.headerView.headerLbl.isHidden = true
        CommonUI.setUpLbl(lbl: self.investmentStratgyLbl, text: L10n.InvestmentStrategies.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.strategyDescLbl, text: L10n.strategiesAreThereToHelpYou.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.strategyDescLbl, text: L10n.strategiesAreThereToHelpYou.description, lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpButton(btn: buildOwnStrategyBtn, text: L10n.BuildMyOwnStrategy.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.white, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        CommonUI.setUpViewBorder(vw: bottomView, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        CommonUI.setUpButton(btn: chooseStrategyBtn, text: L10n.ChooseThisStrategy.description, textcolor: UIColor.white, backgroundColor: UIColor.TFplaceholderColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.headerView.backBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.chooseStrategyBtn.addTarget(self, action: #selector(chooseStrategyBtnAct), for: .touchUpInside)
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
        selectedStrategy = indexPath.row
        invstStrategyData[indexPath.row].isSelected = !(invstStrategyData[indexPath.row].isSelected ?? false)
        for i in 0...(invstStrategyData.count - 1){
            if invstStrategyData[i].name == invstStrategyData[indexPath.row].name{
                
            }else{
                invstStrategyData[i].isSelected = false
            }
        }
        if invstStrategyData[indexPath.row].isSelected == true {
            self.chooseStrategyBtn.backgroundColor = UIColor.PurpleColor
            self.chooseStrategyBtn.isUserInteractionEnabled = true
        }else{
            self.chooseStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
            self.chooseStrategyBtn.isUserInteractionEnabled = false
        }
        showModal()
        
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
    
    @objc func chooseStrategyBtnAct(){
        print((invstStrategyData[selectedStrategy].isOwnStrategy == 1) ? 1 : 0)
        investmentStrategyVM.chooseStrategyApi(isOwnStrategy: invstStrategyData[selectedStrategy].isOwnStrategy ?? 0, strategyId: invstStrategyData[selectedStrategy].name ?? "", completion: {[]response in
            if let response = response{
                print(response)
                let vc = InvestMoneyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.strategyData = self.invstStrategyData[self.selectedStrategy]
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                nav.navigationBar.isHidden = true
                self.present(nav, animated: true, completion: nil)
            }
        })
    }
    
    @objc func buildOwnStrategyBtnAct(){
        let vc = AddStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - Other functions
extension InvestmentStrategyVC{
    
    func showModal(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.popupType = .investWithStrategies
        vc.investmentStrategyController = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func callGetStrategies(){
        CommonFunction.showLoader(self.view)
        self.investmentStrategyVM.getInvestmentStrategiesApi(completion: {[weak self]response in
            CommonFunction.hideLoader(self?.view ?? UIView())
            self?.invstStrategyData = response?.data ?? []
            self?.tblView.reloadData()
        })
    }
}

// MARK: - TABLE VIEW OBSERVER
extension InvestmentStrategyVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        callGetStrategies()
        setUpUI()
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
      self.tblView.reloadData()
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
