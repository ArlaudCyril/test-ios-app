//
//  AddStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import UIKit
import ESPullToRefresh

class AddAssetsVC: UIViewController {
    //MARK: - Variables
    var addAssetsVM = AddAssetsVM()
    var pageNumber : Int = 1, apiHitOnce = false , apiHitting : Bool = false , canPaginate : Bool = true
    //var AssetsAddDataCallback : ((Trending?)->())?
    var AssetsAddDataCallback : ((AllAssetsData?)->())?
    var coinsType : [String] = [L10n.Trending.description,L10n.TopGainers.description,L10n.TopLoosers.description,L10n.Stable.description]
    var coinsData : [AllAssetsData] = []
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
}

//MARK: - SetUpUI
extension AddAssetsVC{
    func setUpUI(){
        self.addAssetsVM.controller = self
        self.bottomVw.layer.cornerRadius = 32
        self.bottomVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.addAssetLbl, text: L10n.AddAnAsset.description, textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
//        CommonUI.setUpButton(btn: self.viewAllAssetsBtn, text: L10n.ViewAllAvailableAssets.description, textcolor: UIColor.PurpleColor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
//        self.viewAllAssetsBtn.setAttributedTitle(CommonFunction.underlineString(str: L10n.ViewAllAvailableAssets.description), for: .normal)
        self.collView.delegate = self
        self.collView.dataSource = self
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        
        tblView.es.addPullToRefresh {
//            self.coinsData = []
            self.pageNumber  = 1
            self.apiHitOnce = false
            self.apiHitting = false
            self.canPaginate = true
            
        }
        self.callGetAssetsApi()
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
//        collView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        if indexPath.item == 0{
            self.selectedCoinsType = .Trending
        }else if indexPath.row == 1{
            self.selectedCoinsType = .TopGainers
        }else if indexPath.row == 2{
            self.selectedCoinsType = .TopLoosers
        }else if indexPath.row == 3{
            self.selectedCoinsType = .Stable
        }
//        self.coinsData = []
        self.pageNumber  = 1
        self.apiHitOnce = false
        self.apiHitting = false
        self.canPaginate = true
        self.tblView.tableFooterView?.isHidden = true
        self.showSpinnerOnTableHeader()
        self.callGetAssetsApi(isEmpty: true)
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
        return coinsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAssetsTVC", for: indexPath as IndexPath) as! AddAssetsTVC
        cell.configureWithData(data : coinsData[indexPath.row] )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newAsset = coinsData[indexPath.row]
        newAsset.isAuto = true
        self.AssetsAddDataCallback?(newAsset)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.apiHitOnce == true {
            if  indexPath.row == (coinsData.count-7) && canPaginate && apiHitting == false {
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
        var order = String()
        if self.selectedCoinsType == .Trending{
            order = "volume_desc"
        }else if self.selectedCoinsType == .TopGainers{
            order = "hour_24_desc"
        }else if self.selectedCoinsType == .TopLoosers{
            order = "hour_24_asc"
        }else if self.selectedCoinsType == .Stable{
            order = "stable_coins"
        }
        addAssetsVM.getAllAssetsApi(order: order, completion: {[]response in
            if var response = response {
                self.coinsData.removeAll()
                self.coinsData.append(contentsOf: response.data )
                
                if (response.data.count) < 10 {
                    self.canPaginate = false
                }
                self.apiHitOnce = true
                self.apiHitting = false
                self.tblView.reloadData()
            }
            self.tblView.es.stopPullToRefresh()
            self.tblView.tableFooterView?.isHidden = true
            self.tblView.tableHeaderView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tblView.bounds.width, height: CGFloat(0)))
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
}
