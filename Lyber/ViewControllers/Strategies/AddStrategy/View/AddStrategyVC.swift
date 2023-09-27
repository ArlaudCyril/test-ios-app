//
//  AddStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 03/06/22.
//

import UIKit

class AddStrategyVC: ViewController {
    //MARK: - Variables
    var addStrategyVM = AddStrategyVM()
    var addAssetsVC = AddAssetsVC()
    var assetsData : [PriceServiceResume?] = []
    var totalAllocationPercentage = 0
    var allocation : [Int] = []
    var tailoring : Bool?
    var tailoringStrategy : Strategy?
    var investmentStrategyController : InvestmentStrategyVC?
	var minInvestPerAsset : Decimal = 20
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var buildMyOwnStrategyLbl: UILabel!
    @IBOutlet var addManyAssetsLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var addAnAssetBtn: UIButton!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var saveMyStrategyBtn: PurpleButton!
    @IBOutlet var isStrategyReadyLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }



	//MARK: - SetUpUI

    override func setUpUI(){
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: buildMyOwnStrategyLbl, text: CommonFunctions.localisation(key: "BUILD_MY_OWN_STRATEGY"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: addManyAssetsLbl, text: CommonFunctions.localisation(key: "ADD_MANY_ASSETS_AS_YOU_WISH"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        CommonUI.setTextWithLineSpacing(label: self.addManyAssetsLbl, text: CommonFunctions.localisation(key: "ADD_MANY_ASSETS_AS_YOU_WISH"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpButton(btn: self.addAnAssetBtn, text: CommonFunctions.localisation(key: "ADD_AN_ASSET"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: bottomView, radius: 32, borderWidth: 2, borderColor: UIColor.greyColor.cgColor)
        
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.saveMyStrategyBtn.setTitle(CommonFunctions.localisation(key: "SAVE_MY_STRATEGY"), for: .normal)
//        self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
        
        CommonUI.setUpLbl(lbl: isStrategyReadyLbl, text: CommonFunctions.localisation(key: "YOUR_STRATEGY_READY_TO_BE_SAVED"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.addAnAssetBtn.addTarget(self, action: #selector(addAssetBtnAct), for: .touchUpInside)
        self.saveMyStrategyBtn.addTarget(self, action: #selector(saveMyStrategyBtnAct), for: .touchUpInside)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
   

        let action = UIContextualAction(style: .destructive, title: CommonFunctions.localisation(key: "DELETE"),
            handler: { (action, view, completionHandler) in
            // Update data source when user taps action
            self.assetsData.remove(at: indexPath.row)
            self.allocation.remove(at: indexPath.row)
            self.handleAllocationPercentageView()
            completionHandler(true)
          })
      action.backgroundColor = .red
      let configuration = UISwipeActionsConfiguration(actions: [action])
        
      return configuration

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
        }
        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveMyStrategyBtnAct(){
        if(self.tailoringStrategy != nil){
            saveTailoringStrategy()
        }
        else{
            saveStrategy()
        }
        
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
            
            if self.totalAllocationPercentage > 100{
                self.isStrategyReadyLbl.text = "\(CommonFunctions.localisation(key: "YOUR_ALLOCATION_IS_GREATER_THAN")) \((self.totalAllocationPercentage ) - 100)%"
                self.isStrategyReadyLbl.textColor = UIColor.Red_500
                self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = false
            }
            else if self.totalAllocationPercentage < 100{
                self.isStrategyReadyLbl.text = "\(CommonFunctions.localisation(key: "YOUR_ALLOCATION_IS_LESS_THAN")) \(100 - (self.totalAllocationPercentage ))%"
                self.isStrategyReadyLbl.textColor = UIColor.Red_500
                self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = false
            }
            else{
                self.isStrategyReadyLbl.text = CommonFunctions.localisation(key: "YOUR_STRATEGY_READY_TO_BE_SAVED")
                self.isStrategyReadyLbl.textColor = UIColor.SecondarytextColor
                self.saveMyStrategyBtn.backgroundColor = UIColor.PurpleColor
                self.saveMyStrategyBtn.isUserInteractionEnabled = true
            }
        }else{
            self.isStrategyReadyLbl.text = CommonFunctions.localisation(key: "YOU_MUST_ADD")
            self.saveMyStrategyBtn.backgroundColor = UIColor.TFplaceholderColor
            self.saveMyStrategyBtn.isUserInteractionEnabled = false
        }
        self.tblView.reloadData()
    }
    
    func handleAllocationPercentage(asset : PriceServiceResume?){
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
            if(self.assetsData[i]?.priceServiceResumeData.isAuto == true)
            {
                nbAuto += 1
            }
            else
            {
                percentageTotalManual += self.allocation[i]
            }
        }
        for i in 0...((self.assetsData.count) - 1){
            if(self.assetsData[i]?.priceServiceResumeData.isAuto == true)
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
    
    func saveStrategy(){
        let alert = UIAlertController(title: "Build Strategy", message: "Enter your strategy name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your strategy name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {_ in
            
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text?.isEmpty ?? true{
                CommonFunctions.toster("Please enter Strategy name")
            }else{
                let strategy = self.createStrategy(strategyName: textField?.text ?? "")
                self.addStrategyVM.addStrategyApi(strategy: strategy, completion: {[]response in
                    if response != nil{
                        self.investmentStrategyController?.invstStrategyData.append(strategy)
						self.investmentStrategyController?.invstStrategyData.sort(by: {$0.publicType ?? "" < $1.publicType ?? "" })
                        self.investmentStrategyController?.tblView.reloadData()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTailoringStrategy(){
        //MARK: - Waiting backend for the possibility of changing the name of the strategy
        /*let alert = UIAlertController(title: "Build Strategy", message: "Enter your strategy name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.tailoringStrategy?.name!
            if(self.tailoringStrategy?.publicType != nil){
                textField.text! += " (\(CommonFunctions.localisation(key: "COPY")))"
            }
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {_ in
            
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if textField?.text?.isEmpty ?? true{
                CommonFunctions.toster("Please enter Strategy name")
            }else{
                if(self.tailoringStrategy?.publicType != nil){
                    let strategyName = (textField?.text ?? "")
                    let strategy = self.createStrategy(strategyName: strategyName)
                    //Public strategy, we just add this strategy to our list
                    self.addStrategyVM.addStrategyApi(strategy: strategy, completion: {[]response in
                        if response != nil{
                            self.investmentStrategyController?.invstStrategyData.append(strategy)
							self.investmentStrategyController?.invstStrategyData.sort(by: {$0.publicType ?? "" < $1.publicType ?? "" })
                            self.investmentStrategyController?.tblView.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
                else{
                    let strategy = self.modifyStrategy(strategyName: textField?.text ?? "", tailoringStrategy: self.tailoringStrategy!)
                    self.addStrategyVM.tailorStrategyApi(newStrategy: strategy, completion: {[]response in
                        if response != nil{
                            for i in 0...((self.investmentStrategyController?.invstStrategyData.count ?? 0) - 1) {
                                if(self.investmentStrategyController?.invstStrategyData[i].name == self.tailoringStrategy?.name)
                                {
                                    self.investmentStrategyController?.invstStrategyData[i] = strategy
                                }
                            }
                            self.investmentStrategyController?.tblView.reloadData()
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)*/

        //MARK: - Waiting solution
		if(self.allocation.min() ?? 0 <= 0){
			CommonFunctions.toster(Constants.AlertMessages.AllAssetsMustHaveAllocationsGreaterThan0)
		}else{
			if(self.tailoringStrategy?.publicType != nil){
				let alert = UIAlertController(title: "Build Strategy", message: "Enter your strategy name", preferredStyle: .alert)
				alert.addTextField { (textField) in
					textField.text = self.tailoringStrategy?.name!
					textField.text! += " (\(CommonFunctions.localisation(key: "COPY")))"
				}
				alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: {_ in
					
				}))
				alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
					let textField = alert?.textFields![0]
					if textField?.text?.isEmpty ?? true{
						CommonFunctions.toster((CommonFunctions.localisation(key: "ALERT_STRATEGY_NAMET")))
					}else{
						var strategy = self.createStrategy(strategyName:textField?.text ?? "")
						strategy.risk = nil
						strategy.expectedYield = nil
						//Public strategy, we just add this strategy to our list
						self.addStrategyVM.addStrategyApi(strategy: strategy, completion: {[]response in
							if response != nil{
								self.investmentStrategyController?.invstStrategyData.append(strategy)
								self.investmentStrategyController?.invstStrategyData.sort(by: {$0.publicType ?? "" < $1.publicType ?? "" })
								self.investmentStrategyController?.tblView.reloadData()
								self.dismiss(animated: true, completion: nil)
							}
						})
					}
				}))
				self.present(alert, animated: true, completion: nil)
			}
			else{
				let strategy = self.modifyStrategy(strategyName: (tailoringStrategy?.name)!, tailoringStrategy: self.tailoringStrategy!)
				var requiredAmount : Decimal = 0
				for asset in strategy.bundle {
					let newAmount = self.minInvestPerAsset / (Decimal(asset.share)/100)
					if(newAmount > requiredAmount){
						requiredAmount = newAmount
					}
				}
				if(strategy.activeStrategy != nil && Decimal(strategy.activeStrategy?.amount ?? 0) < requiredAmount)
				{
					
					let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
					vc.confirmationType = .Tailoring
					vc.strategy = strategy
					vc.addStrategyController = self
					vc.requiredAmount = requiredAmount
					self.present(vc, animated: true, completion: nil)
				}else{
					self.addStrategyVM.tailorStrategyApi(newStrategy: strategy, completion: {[]response in
						if response != nil{
							for i in 0...((self.investmentStrategyController?.invstStrategyData.count ?? 0) - 1) {
								if(self.investmentStrategyController?.invstStrategyData[i].name == self.tailoringStrategy?.name)
								{
									self.investmentStrategyController?.invstStrategyData[i] = strategy
								}
							}
							self.investmentStrategyController?.tblView.reloadData()
							self.dismiss(animated: true, completion: nil)
						}
					})
				}
			}
		}
        
    }
    
    func getStrategy(){
        print(self.addAssetsVC.coinsData)
        
        //MARK: - Loading resume cryptocurrencies
		AllAssetsVM().getAllAssetsApi(completion: {[]response in
            if let response = response {
                self.addAssetsVC.coinsData.removeAll()
				self.addAssetsVC.coinsData.append(contentsOf: response )
                for i in 0...((self.tailoringStrategy?.bundle.count ?? 0) - 1){
                    self.allocation.append(self.tailoringStrategy?.bundle[i].share ?? 0)
                    for asset in  self.addAssetsVC.coinsData{
                        if(asset.id == self.tailoringStrategy?.bundle[i].asset)
                        {
                            self.assetsData.append(asset)
                        }
                    }
                }
                if(self.tblView != nil)
                {
                    self.tblView.reloadData()
                    self.handleAllocationPercentageView()
                }
            }
        })
        
    }
            
    func createStrategy(strategyName:String) -> Strategy{
        var bundle = [InvestmentStrategyAsset]()
        
        for i in 0...(self.assetsData.count - 1){
            let assetData = InvestmentStrategyAsset(asset: self.assetsData[i]?.id ?? "", share: self.allocation[i])
            bundle.append(assetData)
        }
        
        return Strategy(name: strategyName, bundle: bundle)
    }
    
    func modifyStrategy(strategyName: String, tailoringStrategy: Strategy)-> Strategy
    {
        var bundle = [InvestmentStrategyAsset]()
        
        
        for i in 0...(self.assetsData.count - 1){
            let assetData = InvestmentStrategyAsset(asset: self.assetsData[i]?.id ?? "", share: self.allocation[i])
            bundle.append(assetData)
        }
        
        let newStrategy = Strategy(name: strategyName, bundle: bundle, strategy: tailoringStrategy)
        
        return newStrategy
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
