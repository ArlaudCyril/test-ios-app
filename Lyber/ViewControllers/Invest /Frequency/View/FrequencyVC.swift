//
//  FrequencyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 13/06/22.
//

import UIKit

class FrequencyVC: ViewController {
    //MARK: - Variables
    var popUpType  : bottomPopUp = .frequency
    var frequencyData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "ONCE"), subName: CommonFunctions.localisation(key: "UNIQUE_INVESTMENT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.apple_pay.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "DAILY"), subName: CommonFunctions.localisation(key: "EVERYDAY"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.bank_outline.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "WEEKLY"), subName: CommonFunctions.localisation(key: "EVERY_THURSDAY"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.bank_fill.image(), iconBackgroundColor: UIColor.PurpleColor, name: CommonFunctions.localisation(key: "MONTHLY"), subName: CommonFunctions.localisation(key: "EVERY_21ST_MONTH"), rightBtnName: "")
    ]
    var profileData : [buyDepositeModel] = [
        buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "CAMERA"), subName: CommonFunctions.localisation(key: "UNIQUE_INVESTMENT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "SELECT_FROM_GALLERY"), subName: CommonFunctions.localisation(key: "UNIQUE_INVESTMENT"), rightBtnName: ""),
        buyDepositeModel(icon: Assets.mastercard.image(), iconBackgroundColor: UIColor.LightPurple, name: CommonFunctions.localisation(key: "SET_DEFAULT_PICTURES"), subName: CommonFunctions.localisation(key: "UNIQUE_INVESTMENT"), rightBtnName: "")]
    var frequencySelectedCallback : ((String)->())?
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var frequencyLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.bottomView.layer.cornerRadius = 32
        self.bottomView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: CommonFunctions.localisation(key: "FREQUENCY"), textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBottomView))
        self.outerView.addGestureRecognizer(tap)
        
        if popUpType == .changeProfile{
            self.frequencyLbl.text = CommonFunctions.localisation(key: "SELECTED_PROFILE_PICTURE")
        }
    }
}

//MARK: - table view delegates and dataSource
extension FrequencyVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if popUpType == .frequency{
            return frequencyData.count
        }else{
            return profileData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FrequencyTVC", for: indexPath)as! FrequencyTVC
        cell.controller = self
        if popUpType == .frequency{
            cell.setUpCellData(data: frequencyData[indexPath.row],index: indexPath.row)
        }else{
            cell.setUpCellData(data: profileData[indexPath.row],index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if popUpType == .frequency{
            frequencySelectedCallback?(frequencyData[indexPath.row].name)
        }else{
            frequencySelectedCallback?(profileData[indexPath.row].name)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
}

//MARK: - objective functions
extension FrequencyVC{
    @objc func cancelBtnAct(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissBottomView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - TABLE VIEW OBSERVER
extension FrequencyVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
