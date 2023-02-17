//
//  ResourcesTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class ResourcesTVC: UITableViewCell {
    //MARK: - Variables
//    var resourcesData : [assetsModel] = [
//        assetsModel(coinImg: Assets.resources_one.image(), coinName: "Bitcoin 101, from basics to advance ...", euro: "-51%", totalCoin: ""),
//        assetsModel(coinImg: Assets.resources_two.image(), coinName:"Elon Musk tips on trading bitcoins", euro: "+2.9%", totalCoin: ""),
//        assetsModel(coinImg: Assets.resources_three.image(), coinName: "Elon Musk tips on trading bitcoins", euro: "-5,1%", totalCoin: "")]
    var resourcesData : [newsData] = []
    //MARK: - IB OUTLETS
    @IBOutlet var coinCollView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ResourcesTVC{
    func setUpCell(){
        coinCollView.delegate = self
        coinCollView.dataSource = self
        coinCollView.reloadData()
    }
    
//    func setLayout(){
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 64) / 3, height: 120)
//        layout.minimumInteritemSpacing = 8
//        layout.minimumLineSpacing = 8
//        coinCollView.collectionViewLayout = layout
//
////        let height = collViw.collectionViewLayout.collectionViewContentSize.height
//        let height = CGFloat((120*(self.resourcesData.count/3)) + 8)
//        collViewHeightConst.constant = height
//    }
}

//MARK:- COLL VIEW DELEGATE AND DATA SOURCE METHODS
extension ResourcesTVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourcesData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResourcesCVC", for: indexPath as IndexPath) as! ResourcesCVC
        cell.configureWithData(data : resourcesData[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.coinCollView.bounds.width/2 - 16), height: self.coinCollView.bounds.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: resourcesData[indexPath.row].url ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
}
