//
//  ChangePinVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/07/22.
//

import UIKit
import IQKeyboardManagerSwift

class ChangePinVC: ViewController {
    //MARK: - Variables
    var enteredPin = String()
	var currentPage : Int? = 0
  //MARK: - IB OUTLETS
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        setUpUI()
        self.navigationController?.navigationBar.isHidden = true
    }



	//MARK: - SetUpUI

    override func setUpUI(){
        self.collView.delegate = self
        self.collView.dataSource = self
        self.collView.layer.cornerRadius = 32
        self.collView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
     
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension ChangePinVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmNewPinCVC", for: indexPath as IndexPath) as! ConfirmNewPinCVC
            cell.setUpUI(verifyPin : true)
            cell.pinConfirmDelegate = {[]pin in
                if userData.shared.logInPinSet != Int(pin){
                    CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
                }else{
                    self.GotoNextIndex()
                }
            }
            if currentPage == 0{
                DispatchQueue.main.async {
                    cell.pinTF1.becomeFirstResponder()
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = false
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        }else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreateNewPinCVC", for: indexPath as IndexPath) as! CreateNewPinCVC
            cell.setUpUI()
            cell.configureWithData()
            cell.pinCreatedDelegate = {[]pin in
                self.enteredPin = pin
                self.GotoNextIndex()
            }
            if currentPage == 1{
                DispatchQueue.main.async {
                    cell.pinTF1.becomeFirstResponder()
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = false
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConfirmNewPinCVC", for: indexPath as IndexPath) as! ConfirmNewPinCVC
            cell.setUpUI(verifyPin : false)
            cell.pinConfirmDelegate = {[]pin in
                if self.enteredPin != pin{
                    CommonFunctions.toster(Constants.AlertMessages.enterCorrectPin)
                }else{
                    self.setNewLoginPin(enteredPin: pin)
                }
                
            }
            if currentPage == 2{
                DispatchQueue.main.async {
                    cell.pinTF1.becomeFirstResponder()
                    IQKeyboardManager.shared.shouldResignOnTouchOutside = false
                }
            }else{
                cell.endEditing(true)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collView.layer.bounds.width, height: collView.layer.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        collView.reloadData()
    }
}

//MARK: - objective functions
extension ChangePinVC{
    @objc func backBtnAct(){
        if self.currentPage ?? 0 == 0 {
            self.dismiss(animated: true, completion: nil)
        }else{
            let indexPath = NSIndexPath(item: (currentPage ?? 0) - 1, section: 0)
            self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
        }
    }
    
   
}

//MARK: - SCROLLVIEW DELEGATES FUNTION
extension ChangePinVC{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = Int((scrollView.contentOffset.x + scrollView.frame.width/2) / scrollView.frame.width)
                
        if value != self.currentPage {
            if value == 0 {
                resetPinFields()
            }
            self.currentPage = value
        }

        updateUIForCurrentPage()
    }
    
}

//MARK: - OTHER FUNCTION
extension ChangePinVC{
    
    func GotoNextIndex(){
        let indexPath = NSIndexPath(item: (self.currentPage ?? 0) + 1, section: 0)
        self.collView.scrollToItem(at: indexPath as IndexPath, at: .right, animated: true)
    }
    
    func setNewLoginPin(enteredPin : String){
		userData.shared.logInPinSet = Int(enteredPin) ?? 0
		userData.shared.dataSave()
		self.dismiss(animated: true, completion: nil)
        
    }
    
    func resetPinFields() {
        if let cell = collView.cellForItem(at: IndexPath(item: 1, section: 0)) as? CreateNewPinCVC {
            cell.resetPinFields()
        }
    }
    
    func updateUIForCurrentPage() {
        if currentPage == 1 {
            self.backBtn.setImage(Assets.back.image(), for: .normal)
        } else {
            self.backBtn.setImage(Assets.close.image(), for: .normal)
        }
        collView.reloadData()
    }
}
