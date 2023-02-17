//
//  EnableWhitelistingVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

class EnableWhitelistingVC: UIViewController {
    //MARK: - Variables
    var enableWhitelistingVM = EnableWhitelistingVM()
    var timeCallBack : ((SecurityTime?)->())?
    var TimeData : [SecurityTime] = [
        SecurityTime(id: 1, securityTime: "72_HOURS", time: "72 \(L10n.Hours.description)", isSelected: false),
        SecurityTime(id: 2, securityTime: "24_HOURS", time: "24 \(L10n.Hours.description)", isSelected: false),
        SecurityTime(id: 3, securityTime: "NO_EXTRA_SECURITY", time: L10n.NoExtraSecurity.description, isSelected: false)]
    var selectedTime : SecurityTime?
    var disableWhitelisting = false
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var enableWhitelistingLbl: UILabel!
    @IBOutlet var whitlistingDescLbl: UILabel!
    
    @IBOutlet var extraSecurityLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet var blockView: UIView!
    @IBOutlet var blockLbl: UILabel!
    @IBOutlet var enableWhitelistingBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

//MARK: - SetUpUI
extension EnableWhitelistingVC{
    func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.enableWhitelistingLbl, text: L10n.EnableWhitelisting.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.whitlistingDescLbl, text: L10n.WhitelistingIsFeatureThatLimitsWithdrawls.description, textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.whitlistingDescLbl, text: L10n.WhitelistingIsFeatureThatLimitsWithdrawls.description, lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.extraSecurityLbl, text: L10n.ExtraSecurity.description, textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        CommonUI.setUpViewBorder(vw: self.blockView, radius: 16, borderWidth: 0, borderColor: UIColor.greyColor.cgColor, backgroundColor: UIColor.greyColor)
        CommonUI.setUpLbl(lbl: self.blockLbl, text: L10n.AllowYouToBlockTheAdditionOfAddress.description, textColor: UIColor.primaryTextcolor, font: UIFont.MabryPro(Size.Small.sizeValue()))
        self.enableWhitelistingBtn.setTitle(L10n.EnableWhitelisting.description, for: .normal)
        self.enableWhitelistingBtn.backgroundColor = UIColor.TFplaceholderColor
        self.enableWhitelistingBtn.isUserInteractionEnabled = false
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.enableWhitelistingBtn.addTarget(self, action: #selector(enbaleWhiteListingBtnAct), for: .touchUpInside)
        
        if userData.shared.enableWhiteListing {
            for index in 0...(TimeData.count - 1){
                if TimeData[index].securityTime == userData.shared.extraSecurity{
                    TimeData[index].isSelected = true
                    selectedTime = TimeData[index]
                    self.enableWhitelistingLbl.text = L10n.DisableWhitelisting.description
                    self.enableWhitelistingBtn.setTitle(L10n.DisableWhitelisting.description, for: .normal)
                    self.enableWhitelistingBtn.backgroundColor = UIColor.PurpleColor
                    self.enableWhitelistingBtn.isUserInteractionEnabled = true
                    self.tblView.isUserInteractionEnabled = false
                    self.disableWhitelisting = true
                }
            }
        }
        
    }
}

//MARK: - objective functions
extension EnableWhitelistingVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func enbaleWhiteListingBtnAct(){
        self.enableWhitelistingBtn.showLoading()
        if self.disableWhitelisting{
            enableWhitelistingVM.enableWhitelistingApi(enable: false, Security: selectedTime?.securityTime ?? "", completion: {response in
                self.enableWhitelistingBtn.hideLoading()
                if let response = response {
                    userData.shared.enableWhiteListing = false
                    userData.shared.dataSave()
                    self.timeCallBack?(self.selectedTime)
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }else{
            enableWhitelistingVM.enableWhitelistingApi(enable: true, Security: selectedTime?.securityTime ?? "", completion: {response in
                self.enableWhitelistingBtn.hideLoading()
                if let response = response {
                    userData.shared.enableWhiteListing = true
                    userData.shared.extraSecurity = self.selectedTime?.securityTime ?? ""
                    userData.shared.dataSave()
                    self.timeCallBack?(self.selectedTime)
                }
            })
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
}

//MARK: - TABLE VIEW DELEGATE AND DATA SOURCE METHODS
extension EnableWhitelistingVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnableWhitelistingTVC", for: indexPath) as! EnableWhitelistingTVC
        cell.configureWithData(data : TimeData[indexPath.row])
        
        if TimeData[indexPath.row].isSelected == true{
            cell.TimeView.layer.borderColor = UIColor.PurpleColor.cgColor
            cell.radioBtn.setImage(Assets.radio_select.image(), for: .normal)
        }else{
            cell.TimeView.layer.borderColor = UIColor.greyColor.cgColor
            cell.radioBtn.setImage(Assets.radio_unselect.image(), for: .normal)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.TimeData[indexPath.row].isSelected = !self.TimeData[indexPath.row].isSelected
        for i in 0...(self.TimeData.count - 1){
            if TimeData[i].id ==  self.TimeData[indexPath.row].id{
                selectedTime = self.TimeData[indexPath.row]
            }else{
                self.TimeData[i].isSelected = false
            }
            self.tblView.reloadData()
        }
        
        if TimeData[indexPath.row].isSelected == true{
            self.enableWhitelistingBtn.backgroundColor = UIColor.PurpleColor
            self.enableWhitelistingBtn.isUserInteractionEnabled = true
        }else{
            self.enableWhitelistingBtn.backgroundColor = UIColor.TFplaceholderColor
            self.enableWhitelistingBtn.isUserInteractionEnabled = false
        }
    }
}

// MARK: - TABLE VIEW OBSERVER
extension EnableWhitelistingVC{
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.tblView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.setUpUI()
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
