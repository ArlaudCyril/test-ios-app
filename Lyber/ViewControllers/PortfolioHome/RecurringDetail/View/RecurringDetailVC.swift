//
//  RecurringDetailVC.swift
//  Lyber
//
//  Created by sonam's Mac on 26/08/22.
//

import UIKit
import MultiProgressView
import Lottie

class RecurringDetailVC: UIViewController {
    //MARK: - Variables
    var recurringDetailVM = RecurringDetailVM()
    var coinsData : [InvestmentStrategyAsset] = []
    var investmentId = String()
    var investmentData : RecurringInvestmentDetailAPi?
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    
    @IBOutlet var strategyView: UIView!
    @IBOutlet var frequencyTimeLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var progressView: MultiProgressView!
    @IBOutlet var collview: UICollectionView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    
    @IBOutlet var singleView: UIView!
    @IBOutlet var assetFreqLbl: UILabel!
    @IBOutlet var EuroPresentLbl: UILabel!
    
    @IBOutlet var cancelInvestmentBtn: PurpleButton!
    
    @IBOutlet var historyLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        callInvestmentDetail(id: investmentId)
    }
}

//MARK: - SetUpUI
extension RecurringDetailVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        
        CommonUI.setUpViewBorder(vw: strategyView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpLbl(lbl: self.frequencyTimeLbl, text: L10n.Weekly.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "10€", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: singleView, radius: 16, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
        CommonUI.setUpLbl(lbl: self.assetFreqLbl, text: L10n.Weekly.description, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.EuroPresentLbl, text: "10€", textColor: UIColor.grey36323C, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: self.historyLbl, text: L10n.History.description, textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.collview.delegate = self
        self.collview.dataSource = self
        self.cancelInvestmentBtn.setTitle("\(L10n.Delete.description) Investment", for: .normal)
        self.strategyView.isHidden = true
        self.singleView.isHidden = true
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.cancelInvestmentBtn.addTarget(self, action: #selector(cancelInvestmentBtnAct), for: .touchUpInside)
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.layer.cornerRadius = 20
        self.tblView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    }
    
    func setUpData(){
        if investmentData?.userInvestmentStrategyID == nil{
            self.strategyView.isHidden = true
            self.singleView.isHidden = false
            self.headerView.headerLbl.text = investmentData?.assetID ?? ""
            self.EuroPresentLbl.text = "\(investmentData?.amount ?? 0)€"
            self.assetFreqLbl.text = investmentData?.frequency ?? ""
        }else{
            self.strategyView.isHidden = false
            self.singleView.isHidden = true
            self.headerView.headerLbl.text = investmentData?.strategyName ?? ""
            self.euroLbl.text = "\(investmentData?.amount ?? 0)€"
            self.frequencyTimeLbl.text = investmentData?.frequency ?? ""
            self.progressView.delegate = self
            self.progressView.dataSource = self
            self.progressView.cornerRadius = 4
            self.progressView.lineCap = .round
            self.coinsData = investmentData?.strategyAssets ?? []
            for i in 0...((coinsData.count) - 1){
//                DispatchQueue.main.async {
                print((Float(self.coinsData[i].share ?? 0))/100)
//                    self.progressView.setProgress(section: i, to: (Float(self.coinsData[i].allocation ?? 0))/100)
//                }
            }
            self.collview.reloadData()
            self.setLayout()
        }
        
    }
}


//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension RecurringDetailVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return investmentData?.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringDetailTVC", for: indexPath) as! RecurringDetailTVC
        cell.configureWithData(data: investmentData?.history?[indexPath.row])
        return cell
    }
    
    
}

// MARK: - TABLE VIEW OBSERVER
extension RecurringDetailVC{
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
              self.tblViewHeightConst.constant = newSize.height
            }
          }
      }
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension RecurringDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvestMoneyCVC", for: indexPath as IndexPath) as! InvestMoneyCVC
        cell.configureWithData(data : coinsData[indexPath.row], strategyColor: strategyColor[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

//MARK: - objective functions
extension RecurringDetailVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelInvestmentBtnAct(){
        recurringDetailVM.deleteInvestmentApi(id: self.investmentId, completion: {_ in
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
}

//MARK: - Other functions
extension RecurringDetailVC{
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 92) / 2, height: 20)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collview.collectionViewLayout = layout
        
//        let height = collViw.collectionViewLayout.collectionViewContentSize.height
        let height = CGFloat((20*((self.coinsData.count+1)/2)) + 12*(self.coinsData.count/2))
        //CGFloat((20*(self.coinsData.count/2)) + 12)
        collViewHeightConst.constant = height
    }
    
    func callInvestmentDetail(id : String){
        CommonFunctions.showLoader(self.view)
        self.recurringDetailVM.getRecurringDetailApi(id: id, completion: {response in
            CommonFunctions.hideLoader(self.view)
            if let response = response {
                self.investmentData = response
                self.setUpData()
                self.tblView.reloadData()
            }
        })
    }
}

//MARK: - Progress View Delegate and DataSourec
extension RecurringDetailVC : MultiProgressViewDelegate, MultiProgressViewDataSource{
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return coinsData.count
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let sectionView = ProgressViewSection()
        sectionView.backgroundColor = strategyColor[section]
//        UIColor.PurpleColor.withAlphaComponent(CGFloat((coinsData[section].allocation ?? 0))/100)//coinsData[section].coinColor
        return sectionView
    }
}
