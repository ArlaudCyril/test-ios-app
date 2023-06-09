//
//  DefaultPictureVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/08/22.
//

import UIKit

class DefaultPictureVC: SwipeGesture {
    //MARK: - Variables
    var pictureData : [String] =
    ["one","two","three","four","five","six","seven","eight","nine","ten",
     "eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen","twenty",
     "twenty_one","twenty_two","twenty_three","twenty_four","twenty_five","twenty_six","twenty_seven","twenty_eight","twenty_nine","thirty",
     "thirty_one","thirty_two","thirty_three","thirty_four","thirty_five","thirty_six","thirty_seven","thirty_eight","thirty_nine","fourty"
    ]
    //MARK:- IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }



	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.text = CommonFunctions.localisation(key: "SELECT_DEFAULT_PICTURE")
        self.collView.delegate = self
        self.collView.dataSource = self
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
    }
}

//MARK: - objective functions
extension DefaultPictureVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension DefaultPictureVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultPictureCVC", for: indexPath as IndexPath) as! DefaultPictureCVC
        cell.configureWithData(data: pictureData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = SelectedProfileVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        vc.profilePicImg = UIImage(named: pictureData[indexPath.row]) ?? UIImage()
        vc.profilePicType = .DEFAULT
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collView.bounds.width - 36)/4), height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
