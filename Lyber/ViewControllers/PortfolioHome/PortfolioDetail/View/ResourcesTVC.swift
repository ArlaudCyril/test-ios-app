//
//  ResourcesTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit

class ResourcesTVC: UITableViewCell {
    //MARK: - Variables
    var resourcesData : [newsData] = []
    //MARK: - IB OUTLETS
    @IBOutlet var coinCollView: UICollectionView!
    
}

extension ResourcesTVC{
	func setUpCell(){
		coinCollView.delegate = self
		coinCollView.dataSource = self
		coinCollView.reloadData()
	}
}

//MARK: - COLL VIEW DELEGATE AND DATA SOURCE METHODS
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: resourcesData[indexPath.row].url ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
}
