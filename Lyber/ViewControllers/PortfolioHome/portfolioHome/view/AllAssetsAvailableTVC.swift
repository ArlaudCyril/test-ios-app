//
//  AllAssetsAvailableTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class AllAssetsAvailableTVC: UITableViewCell {
    //MARK: - Variables
    var controller : PortfolioHomeVC?
    var allAssetsAvailable : [PriceServiceResume] = []
    //MARK: - IB OUTLETS
    @IBOutlet var coinCollView: UICollectionView!
    @IBOutlet var viewAll: UIView!
    @IBOutlet var collViewHeightConst: NSLayoutConstraint!
    @IBOutlet var viewAllBtn: UIButton!
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension AllAssetsAvailableTVC{
    func setUpCell(){
        self.allAssetsAvailable = self.controller?.allAvailableAssets ?? []
        coinCollView.delegate = self
        coinCollView.dataSource = self
        setLayout()
        CommonUI.setUpButton(btn: viewAllBtn, text: CommonFunctions.localisation(key: "VIEW_ALL"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 0, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        viewAllBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "VIEW_ALL")), for: .normal)
        viewAllBtn.addTarget(self, action: #selector(viewAllBtnAct), for: .touchUpInside)
    }
    
    func setLayout(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 64) / 3, height: 120)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        coinCollView.collectionViewLayout = layout
        
        let height = coinCollView.collectionViewLayout.collectionViewContentSize.height
       
        collViewHeightConst.constant = height
		coinCollView.reloadData()
    }
}// let height = CGFloat((120*(self.allAssetsAvailable.count/3)) + 8)

//MARK: - COLL VIEW DELEGATE AND DATA SOURCE METHODS
extension AllAssetsAvailableTVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allAssetsAvailable.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCoinCVC", for: indexPath as IndexPath) as! AllCoinCVC
        cell.configureWithData(data : allAssetsAvailable[indexPath.row])
        return cell
    }

    	        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PortfolioDetailVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		vc.assetId = allAssetsAvailable[indexPath.row].id
		self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - objective functions
extension AllAssetsAvailableTVC{
    @objc func viewAllBtnAct(){
        let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
		self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
