//
//  AllAssetsVC.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import UIKit
import ESPullToRefresh

class AllAssetsVC: SwipeGesture {
    //MARK: - Variables
    var allAssetsVM = AllAssetsVM()
    var pageNumber : Int = 1, apiHitOnce = false , apiHitting : Bool = false , canPaginate : Bool = true
    var screenType : screenEnum = .portfolio
    var coinSelectedCallback : ((_ coinData : Trending?)->())?
    var coinsType : [String] = [CommonFunctions.localisation(key: "TRENDING"),CommonFunctions.localisation(key: "GAINERS"),CommonFunctions.localisation(key: "LOSERS"),CommonFunctions.localisation(key: "STABLE")]
	var fromAssetId : String = ""
    
    var coinsData : [PriceServiceResume] = []
    var originalData : [PriceServiceResume] = []
    var filteredData : [AssetBaseData] = []
    var filterCoin : [PriceServiceResume] = []
    var selectedCoinsType : coinType? = .Trending
    //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var AllAssetsLbl: UILabel!
    @IBOutlet var collView: UICollectionView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTF: UITextField!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var availableFlatVw: UIView!
    @IBOutlet var availbaleFlatLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfEuroLbl: UILabel!
    @IBOutlet var euroImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        self.tblView.es.startPullToRefresh()
    }

	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
			if(screenType != .exchange){
				self.navigationController?.deleteToViewController(ofClass: PortfolioHomeVC.self)
			}
		}
		return true
	}

	//MARK: - SetUpUI

    override func setUpUI(){
        self.allAssetsVM.controller = self
		self.filteredData = coinDetailData
		
        self.backBtn.layer.cornerRadius = 12
		self.searchTF.placeholder = CommonFunctions.localisation(key: "SEARCH")
        CommonUI.setUpLbl(lbl: self.AllAssetsLbl, text: CommonFunctions.localisation(key: "CHOOSE_AN_ASSET"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpViewBorder(vw: searchView, radius: 12, borderWidth: 1, borderColor: UIColor.borderColor.cgColor)
        searchTF.delegate = self
        searchTF.addTarget(self, action: #selector(searchTextChange), for: .editingChanged)
        
        CommonUI.setUpLbl(lbl: self.availbaleFlatLbl, text: CommonFunctions.localisation(key: "AVAILABLE_FLAT"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        CommonUI.setUpLbl(lbl: self.euroLbl, text: "Euro", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfEuroLbl, text: "0€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.collView.delegate = self
        self.collView.dataSource = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        if screenType == .exchange{
            self.AllAssetsLbl.text = CommonFunctions.localisation(key: "EXCHANGE_TO_TITLE")
            self.backBtn.setImage(Assets.back.image(), for: .normal)
            self.availableFlatVw.isHidden = false
		}else if screenType == .singleAsset || screenType == .singleAssetStrategy{
            self.backBtn.setImage(Assets.back.image(), for: .normal)
            self.availableFlatVw.isHidden = true
            self.AllAssetsLbl.text = CommonFunctions.localisation(key: "CHOOSE_AN_ASSET")
        }else{
			self.availableFlatVw.isHidden = true
			//update position of collview
            self.backBtn.setImage(Assets.back.image(), for: .normal)
            
            self.AllAssetsLbl.text = CommonFunctions.localisation(key: "ALL_ASSETS")
        }
        
        tblView.es.addPullToRefresh {
//            self.coinsData = []
            self.pageNumber  = 1
            self.apiHitOnce = false
            self.apiHitting = false
            self.canPaginate = true
            self.callGetAssetsApi()
        }
        
		//hide euros
		self.availableFlatVw.isHidden = true
    }
}


//MARK: - Coll VIEW DELEGATE AND DATA SOURCE METHODS
extension AllAssetsVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        self.searchTF.text = ""
        self.searchTF.resignFirstResponder()
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
extension AllAssetsVC: UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAssetsTVC", for: indexPath as IndexPath) as! AddAssetsTVC
        cell.configureWithData(data : filterCoin[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if screenType == .portfolio{
            let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
			vc.assetId = filterCoin[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }else if screenType == .exchange{
			let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
			vc.fromAssetId = self.fromAssetId
			vc.toAssetId = filterCoin[indexPath.row].id
			vc.fromAssetPrice = coinsData.first(where: {$0.id == self.fromAssetId})?.priceServiceResumeData.lastPrice
			vc.toAssetPrice = filterCoin[indexPath.row].priceServiceResumeData.lastPrice
			vc.strategyType = .Exchange
			//            vc.assetsData = coinsData[indexPath.row]
			self.navigationController?.pushViewController(vc, animated: true)
        }else if screenType == .singleAsset || screenType == .singleAssetStrategy{
			let toAsset = coinsData.first(where: {$0.id == "usdt"}) ?? filterCoin[indexPath.row]
            if(self.fromAssetId == "usdt" || filterCoin[indexPath.row].id == "usdt"){
				let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
				vc.strategyType = .singleCoin
				vc.asset = toAsset
				self.navigationController?.pushViewController(vc, animated: true)
			}else{
				if(CommonFunctions.getBalance(id: "usdt") != nil){
					let vc = InvestInMyStrategyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
					vc.fromAssetId = "usdt"
					vc.toAssetId = filterCoin[indexPath.row].id
					vc.fromAssetPrice = coinsData.first(where: {$0.id == "usdt"})?.priceServiceResumeData.lastPrice
					vc.toAssetPrice = filterCoin[indexPath.row].priceServiceResumeData.lastPrice
					vc.strategyType = .Exchange
					self.navigationController?.pushViewController(vc, animated: true)
				}else{
					presentAlertBuyUsdt(toAsset: toAsset)
				}
			}
        }
    }
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		// Dismiss the keyboard
		view.endEditing(true)
	}
}

//MARK: - objective functions
extension AllAssetsVC{
    @objc func backBtnAct(){
		if(screenType == .exchange){
			self.navigationController?.popViewController(animated: true)
		}else{
			self.navigationController?.popToViewController(ofClass: PortfolioHomeVC.self)
		}
		
    }
    
    @objc func fireTimer(){
        self.pageNumber  = 1
        self.apiHitOnce = false
        self.apiHitting = false
        self.canPaginate = true
        self.callGetAssetsApi(isEmpty: true)
    }
}

//MARK: - Other functions
extension AllAssetsVC{
    func callGetAssetsApi(isEmpty : Bool = false){
        allAssetsVM.getAllAssetsApi(completion: {[]response in
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
    
   
    @objc func searchTextChange(){
        if searchTF.text == ""{
			self.filterData()
        }else{
            self.filterCoin = []
            self.filteredData = coinDetailData.filter({
				($0.id?.hasPrefix(searchTF.text ?? "") ?? false) || ($0.fullName?.lowercased().hasPrefix(searchTF.text?.lowercased() ?? "") ?? false)

            })
            print(filteredData)
            for i in 0..<self.filteredData.count{
                print(self.filteredData[i].id ?? "")
                
                for k in 0..<self.coinsData.count{
                    if self.coinsData[k].id == self.filteredData[i].id ?? ""{
						if(!(self.fromAssetId != "" && self.coinsData[k].id == self.fromAssetId)){
							filterCoin.append(self.coinsData[k])
							print("filterCoin coins data",filterCoin)
						}
                    }
                }
            }
        }
        
        print("coins data",coinsData)
        self.tblView.reloadData()
        
    }
    
    func showSpinnerOnTableFooter(){
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tblView.bounds.width, height: CGFloat(44))
        self.tblView.tableFooterView = spinner
        self.tblView.tableFooterView?.isHidden = false
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
        
        self.tblView.reloadData()
    }
	
	func presentAlertBuyUsdt(toAsset : PriceServiceResume){
        let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.type = .buyUsdt
        vc.controller = self
        vc.toAsset = toAsset
        self.navigationController?.present(vc, animated: false)
	}
}

extension AllAssetsVC: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("clear")
        self.pageNumber  = 1
        self.apiHitOnce = false
        self.apiHitting = false
        self.canPaginate = true
        self.callGetAssetsApi()
        return true
    }
}
