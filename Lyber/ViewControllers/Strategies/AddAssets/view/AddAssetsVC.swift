//
//  AddStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import UIKit
import ESPullToRefresh

class AddAssetsVC: ViewController {
    //MARK: - Variables
    var pageNumber : Int = 1, apiHitOnce = false , apiHitting : Bool = false , canPaginate : Bool = true
    //var AssetsAddDataCallback : ((Trending?)->())?
    var AssetsAddDataCallback : ((PriceServiceResume?)->())?
    var coinsType : [String] = [CommonFunctions.localisation(key: "TRENDING"),CommonFunctions.localisation(key: "GAINERS"),CommonFunctions.localisation(key: "LOSERS"),CommonFunctions.localisation(key: "STABLE")]
	
	var fromAssetId : String = ""
	
	var coinsData : [PriceServiceResume] = []
	var originalData : [PriceServiceResume] = []
	var filteredData : [AssetBaseData] = []
	var filterCoin : [PriceServiceResume] = []
    var selectedCoinsType : coinType? = .Trending
    var timer = Timer()
    //MARK: - IB OUTLETS
    @IBOutlet var bottomVw: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var addAssetLbl: UILabel!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var tblView: UITableView!
//    @IBOutlet var viewAllAssetsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.bottomVw.layer.cornerRadius = 32
        self.bottomVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.addAssetLbl, text: CommonFunctions.localisation(key: "ADD_AN_ASSET"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.collView.delegate = self
        self.collView.dataSource = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        
        tblView.es.addPullToRefresh {
            self.pageNumber  = 1
            self.apiHitOnce = false
            self.apiHitting = false
            self.canPaginate = true
            
        }
        if(self.coinsData.count == 0){
            self.callGetAssetsApi()
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    @objc func fireTimer(){
        self.pageNumber  = 1
        self.apiHitOnce = false
        self.apiHitting = false
        self.canPaginate = true
        self.tblView.tableFooterView?.isHidden = true
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension AddAssetsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coinsType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddAssetsCVC", for: indexPath as IndexPath) as! AddAssetsCVC
        cell.configureWithData(data : coinsType[indexPath.row])
        if (indexPath.row == 0){
            cell.isSelected = true
            self.collView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.layer.bounds.width/4, height: collView.layer.bounds.height)
    }
    
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if indexPath.item == 0{
			self.selectedCoinsType = .Trending
		}else if indexPath.row == 1{
			self.selectedCoinsType = .TopGainers
		}else if indexPath.row == 2{
			self.selectedCoinsType = .TopLoosers
		}else if indexPath.row == 3{
			self.selectedCoinsType = .Stable
		}
		self.filterData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

//MARK: - table view delegates and dataSource
extension AddAssetsVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAssetsTVC", for: indexPath as IndexPath) as! AddAssetsTVC
        cell.configureWithData(data : filterCoin[indexPath.row] )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newAsset = filterCoin[indexPath.row]
        newAsset.priceServiceResumeData.isAuto = true
        self.AssetsAddDataCallback?(newAsset)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.apiHitOnce == true {
            if  indexPath.row == (filterCoin.count-7) && canPaginate && apiHitting == false {
//                self.showSpinnerOnTableFooter()
//
            }
        }
    }
}

//MARK: - objective functions
extension AddAssetsVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Other functions
extension AddAssetsVC{
   
    func showSpinnerOnTableFooter(){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblView.bounds.width, height: CGFloat(44))
        
        self.tblView.tableFooterView = spinner
        self.tblView.tableFooterView?.isHidden = false
    }
	
    func callGetAssetsApi(isEmpty : Bool = false){
		AllAssetsVM().getAllAssetsApi(completion: {[]response in
			if let response = response {
				print(response)
				self.originalData = response
				self.coinsData = response
				self.filterData()
			}
			self.tblView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tblView.bounds.width, height: CGFloat(0)))
			self.tblView.tableHeaderView?.isHidden = true
			self.tblView.es.stopPullToRefresh()
			self.tblView.tableFooterView?.isHidden = true
			CommonFunctions.hideLoader(self.view)
			
			self.tblView.reloadData()
        })
    }
    
    func showSpinnerOnTableHeader(){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblView.bounds.width, height: CGFloat(44))
        self.tblView.tableHeaderView = spinner
        self.tblView.tableHeaderView?.isHidden = false
    }
	
	func filterData(){
		if self.selectedCoinsType == .Stable{
			self.filterCoin = self.coinsData.filter({CommonFunctions.getCurrency(id: $0.id).isStablecoin ?? false})
		}
		else{
			if self.selectedCoinsType == .TopGainers{
				self.filterCoin = self.coinsData.sorted(by: {(Double($0.priceServiceResumeData.change ?? "") ?? 0) > (Double($1.priceServiceResumeData.change ?? "") ?? 0)})
			}else if self.selectedCoinsType == .TopLoosers{
				self.filterCoin = self.coinsData.sorted(by: {(Double($0.priceServiceResumeData.change ?? "") ?? 0) < (Double($1.priceServiceResumeData.change ?? "") ?? 0)})
			}else{
				self.filterCoin = self.originalData
			}
			self.filterCoin = self.filterCoin.filter({!(CommonFunctions.getCurrency(id: $0.id).isStablecoin ?? false)})
		}
		if(self.fromAssetId != ""){
			let indexAssetToRemove = filterCoin.firstIndex(where: {$0.id == self.fromAssetId})
			if(indexAssetToRemove != nil){
				filterCoin.remove(at: indexAssetToRemove!)
			}
			
		}
        //We don't want to be able to add assets with "isStrategyActive" at false
        filterCoin = filterCoin.filter { CommonFunctions.getCurrency(id: $0.id).isStrategyActive ?? false }
        
		self.tblView.reloadData()
	}
	
}
