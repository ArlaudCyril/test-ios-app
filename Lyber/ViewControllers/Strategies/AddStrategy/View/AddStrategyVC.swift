//
//  AddStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit

class AddStrategyVC: UIViewController {
    //MARK: - Variables
    var addStrategyVM = AddStrategyVM()
//    var newAsset : coinsModel?
    //var assetsData : [Trending?] = []
    var assetsData : [AllAssetsData?] = []
    var totalAllocationPercentage = 0
    var allocation : [Int] = []
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var buildMyOwnStrategyLbl: UILabel!
    @IBOutlet var addManyAssetsLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var addAnAssetBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var saveMyStrategyBtn: PurpleButton!
    @IBOutlet var noOfAssetsLbl: UILabel!
    @IBOutlet var isStrategyReadyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

}

//MARK: - SetUpUI
extension AddStrategyVC{
    func setUpUI(){
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: buildMyOwnStrategyLbl, text: L10n.BuildMyOwnStrategy.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: addManyAssetsLbl, text: L10n.AddManyAssetsAsYouWish.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setTextWithLineSpacing(label: self.addManyAssetsLbl, text: L10n.AddManyAssetsAsYouWish.description, lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpButton(btn: self.addAnAssetBtn, text: L10n.AddAnAsset.description, textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: bottomView, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.saveMyStrategyBtn.setTitle(L10n.SaveMyStrategy.description, for: .normal)
//        self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
        
        CommonUI.setUpLbl(lbl: noOfAssetsLbl, text: "\(assetsData.count) \(L10n.asset.description)", textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        CommonUI.setUpLbl(lbl: isStrategyReadyLbl, text: L10n.YourStrategyReadyToBeSaved.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.addAnAssetBtn.addTarget(self, action: #selector(addAssetBtnAct), for: .touchUpInside)
        self.saveMyStrategyBtn.addTarget(self, action: #selector(saveStrategyBtnAct), for: .touchUpInside)
        handleAllocationPercentageView()
    }
}

//MARK: - table view delegates and dataSource
extension AddStrategyVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddStrategyTVC")as! AddStrategyTVC
        cell.setUpCell(data: assetsData[indexPath.row] ,index : indexPath.row,allocation : allocation[indexPath.row])
        cell.controller = self
        
        return cell
    }
}

//MARK: - objective functions
extension AddStrategyVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addAssetBtnAct(){
        let vc = AddAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        vc.AssetsAddDataCallback = {[weak self] assets in
            
            self?.handleAllocationPercentage(asset : assets)
            self?.tblView.reloadData()
            self?.handleAllocationPercentageView()
            self?.noOfAssetsLbl.text = self?.assetsData.count ?? 0 > 1 ? "\(self?.assetsData.count ?? 0) \(L10n.assets.description)" : "\(self?.assetsData.count ?? 0) \(L10n.asset.description)"
        }
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveStrategyBtnAct(){
        let alert = UIAlertController(title: "Build Strategy", message: "Enter your strategy name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your strategy name"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text?.isEmpty ?? true{
                CommonFunction.toster("Please enter Strategy name")
            }else{
                self.addStrategyVM.addStrategyApi(strategyName: textField?.text ?? "" ,assets: self.assetsData,allocation : self.allocation, completion: {[]response in
                    if let response = response{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {_ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Other functions
extension AddStrategyVC{
    func handleAllocationPercentageView(){
        self.totalAllocationPercentage = 0
        if assetsData.count > 0{
            for i in 0...((self.allocation.count ) - 1){
                self.totalAllocationPercentage += self.allocation[i]
                print(self.totalAllocationPercentage)
            }
            
            self.noOfAssetsLbl.isHidden = false
            if self.totalAllocationPercentage > 100{
                self.isStrategyReadyLbl.text = "\(L10n.yourAllocationIsGreaterThan.description)\((self.totalAllocationPercentage ) - 100)%"
                self.isStrategyReadyLbl.textColor = UIColor.RedDF5A43
                self.noOfAssetsLbl.textColor = UIColor.RedDF5A43
                self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = false
            }
            else if self.totalAllocationPercentage < 100{
                self.isStrategyReadyLbl.text = "\(L10n.yourAllocationIslessThan.description)\(100 - (self.totalAllocationPercentage ))%"
                self.isStrategyReadyLbl.textColor = UIColor.RedDF5A43
                self.noOfAssetsLbl.textColor = UIColor.RedDF5A43
                self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = false
            }
            else{
                self.isStrategyReadyLbl.text = L10n.YourStrategyReadyToBeSaved.description
                self.isStrategyReadyLbl.textColor = UIColor.SecondarytextColor
                self.noOfAssetsLbl.textColor = UIColor.ThirdTextColor
                self.saveMyStrategyBtn.backgroundColor = UIColor.PurpleColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = true
            }
        }else{
            self.noOfAssetsLbl.isHidden = true
            self.isStrategyReadyLbl.text = L10n.VousDevezAjouter.description
            self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
            self.saveMyStrategyBtn.isUserInteractionEnabled = false
        }
        self.tblView.reloadData()
    }
    
    func handleAllocationPercentage(asset : AllAssetsData?){
        var nbAuto = 0
        var percentageTotalManual = 0
        var percentageRemaining = 100
        var isContained = false
        if self.assetsData.count == 0{
            self.assetsData.append(asset)
        }else{
            for i in 0...((self.assetsData.count ) - 1){
                if self.assetsData[i]?.id == asset?.id{
                    isContained = true
                    break
                }
            }
            if(isContained == false)
            {
                self.assetsData.append(asset)
            }
        }
        for i in 0...((self.assetsData.count) - 1){
            if(self.assetsData[i]?.isAuto == true)
            {
                nbAuto += 1
            }
            else
            {
                percentageTotalManual += self.allocation[i]
            }
        }
        for i in 0...((self.assetsData.count) - 1){
            if(self.assetsData[i]?.isAuto == true)
            {
                let percentageAllocated = max(0, (percentageRemaining-percentageTotalManual)/(nbAuto))
                if(i>(self.allocation.count) - 1)
                {
                    self.allocation.append(percentageAllocated)
                }
                else{
                    self.allocation[i]=percentageAllocated
                }
                percentageRemaining -= percentageAllocated
                nbAuto -= 1
            }
        }
    }
    
}

// MARK: - TABLE VIEW OBSERVER
extension AddStrategyVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.setUpUI()
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
