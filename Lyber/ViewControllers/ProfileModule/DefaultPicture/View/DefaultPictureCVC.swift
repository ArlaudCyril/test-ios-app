//
//  DefaultPictureCVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class DefaultPictureCVC: UICollectionViewCell {
    //MARK:- IB OUTLETS
    @IBOutlet var imgVw: UIImageView!
}

extension DefaultPictureCVC{
    func configureWithData(data : String){
        self.imgVw.image = UIImage(named: data)
    }
}
