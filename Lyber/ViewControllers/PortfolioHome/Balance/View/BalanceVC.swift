//
//  BalanceVC.swift
//  Lyber
//
//  Created by sonam's Mac on 17/06/22.
//

import UIKit

class BalanceVC: UIViewController {
    
    //MARK: - Variables
    var pointOrigin : CGPoint!
    var myAssetPresent = false
    var myAsset : Trending? 
    var transactionData : [Transaction] = []
//    var assetSymbol : String = ""
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var balanceLbl: UILabel!
    @IBOutlet var coinNameLbl: UILabel!
    
    @IBOutlet var coinLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    
    @IBOutlet var earningAndROIVw: UIStackView!
    @IBOutlet var percentageVw: UIView!
    @IBOutlet var earningVw: UIView!
    @IBOutlet var totalEarningLbl: UILabel!
    @IBOutlet var NoOfEuroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    
    @IBOutlet var roiLbl: UILabel!
    @IBOutlet var percentageLbl: UILabel!
    @IBOutlet var annualPercentageLbl: UILabel!
    @IBOutlet var historiqueLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpUI()
        self.getTransactionData()
    }

}

//MARK: - SetUpUI
extension BalanceVC{
    func setUpUI(){
        self.navigationController?.navigationBar.isHidden = true
        bottomView.layer.cornerRadius = 32
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.balanceLbl, text: L10n.Balance.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.coinNameLbl, text: "\(myAsset?.name ?? "") (\(myAsset?.symbol?.uppercased() ?? ""))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.coinLbl, text: "\(CommonFunction.getTwoDecimalValue(number: (myAsset?.total_balance ?? 0.0))) \(myAsset?.symbol?.uppercased() ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(CommonFunction.getTwoDecimalValue(number: ((myAsset?.total_balance ?? 0.0)*(myAsset?.currentPrice ?? 0.0))))€", textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.extraLarge.sizeValue()))
        
        self.earningVw.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.totalEarningLbl, text: L10n.TotalEarnings.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.NoOfEuroLbl, text: "0.00€", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "\(CommonFunction.getTwoDecimalValue(number: (myAsset?.total_balance ?? 0.0))) \(myAsset?.symbol?.uppercased() ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        self.percentageVw.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.roiLbl, text: L10n.ROI.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.percentageLbl, text: "~5,01%*", textColor: UIColor.ThirdTextColor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.annualPercentageLbl, text: L10n.AnnualPercentage.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        CommonUI.setUpLbl(lbl: self.historiqueLbl, text: L10n.History.description , textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
//        self.tblView.layer.cornerRadius = 16
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let outerTapped = UITapGestureRecognizer(target: self, action: #selector(cancelBtnAct))
        self.outerView.addGestureRecognizer(outerTapped)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        self.bottomView.addGestureRecognizer(panGesture)
        
//        let earningVwTap = UITapGestureRecognizer(target: self, action: #selector(earningVwAction))
//        self.earningVw.addGestureRecognizer(earningVwTap)
//        let roiVwTap = UITapGestureRecognizer(target: self, action: #selector(ROIViewAction))
//        self.percentageVw.addGestureRecognizer(roiVwTap)
        
        DispatchQueue.main.async {
        self.pointOrigin = CGPoint(x: 0, y: (self.view.frame.height) * (0.3))
        self.bottomView.frame.origin = CGPoint(x: 0, y: self.pointOrigin.y)
        }
        
        if myAsset?.total_balance != 0{
            self.earningAndROIVw.isHidden = false
        }else{
            self.earningAndROIVw.isHidden = true
        }
    }
}

//Mark:- table view delegates and dataSource
extension BalanceVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "balanceTVC")as! balanceTVC
        cell.setUpCell(data : transactionData[indexPath.row])
        return cell
    }
    
    
}
// MARK: - TABLE VIEW OBSERVER
extension BalanceVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
        self.setUpUI()
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
//                if newSize.height > 500{
//                    self.tblViewHeightConst.constant = 500
//                }else{
//                    self.tblViewHeightConst.constant = newSize.height
//                }
              
            }
          }
      }
    }
}

//MARK: - objective functions
extension BalanceVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func earningVwAction(){
        let vc = TotalEarningsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func ROIViewAction(){
        let vc = TotalEarningsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK:- ACTION THAT MANAGES THE SWIPE UP DOWN OF BOTTOM SHEET
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        let window = UIApplication.shared.windows.first
        let topPadding = window?.safeAreaInsets.top
        
        if translation.y <= 0{
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin = CGPoint(x: 0, y: self.pointOrigin.y + translation.y)
            }
            if sender.state == .ended {
                UIView.animate(withDuration: 0.1) {
                    self.bottomView.frame.origin = CGPoint(x: 0, y:  topPadding ?? 0)
                }
            }
            return
        }else{
            UIView.animate(withDuration: 0.3) {
                self.bottomView.frame.origin = CGPoint(x: 0, y: self.pointOrigin.y + translation.y)
            }
            if sender.state == .ended {
                let dragVelocity = sender.velocity(in: bottomView)
                if dragVelocity.y >= 1300 {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.bottomView.frame.origin = CGPoint(x: 0, y: self.pointOrigin.y)
//                        self.pointOrigin ?? CGPoint(x: 0, y: 400)
                    }
                }
            }
        }
    }
}

//MARK: - Other functions
extension BalanceVC{
    func getTransactionData(){
        CommonFunction.showLoader(self.view)
        BalanceVM().getTransactionsApi(assetID: myAsset?.symbol?.uppercased() ?? "", completion: {[weak self] response in
            CommonFunction.hideLoader(self?.view ?? UIView())
            if let response = response{
                print(response)
                if response.transactions?.count == 0{
                    self?.historiqueLbl.isHidden = true
                }
                self?.transactionData = response.transactions ?? []
                self?.tblView.reloadData()
                DispatchQueue.main.async {
                    self?.pointOrigin = CGPoint(x: 0, y: (self?.view.frame.height ?? 0) * (0.3))
        //        UIView.animate(withDuration: 0.3) {
                    self?.bottomView.frame.origin = CGPoint(x: 0, y: self?.pointOrigin.y ?? 0)
        //        }
                }
                
            }
        })
    }
}
