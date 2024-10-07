//
//  EnableWhitelistingVC.swift
//  Lyber
//
//  Created by sonam's Mac on 02/08/22.
//

import UIKit

class EnableWhitelistingVC: ViewController {
    //MARK: - Variables
    var enableWhitelistingVM = EnableWhitelistingVM()
    var timeCallBack : ((SecurityTime?)->())?
    var TimeData : [SecurityTime] = [
        SecurityTime(id: 1, securityTime: "72_HOURS", time: CommonFunctions.localisation(key: "72_HOURS"), isSelected: false),
        SecurityTime(id: 2, securityTime: "24_HOURS", time: CommonFunctions.localisation(key: "24_HOURS"), isSelected: false),
        SecurityTime(id: 3, securityTime: "NO_EXTRA_SECURITY", time: CommonFunctions.localisation(key: "NO_EXTRA_SECURITY"), isSelected: false)]
    var selectedTime : SecurityTime?
    //MARK: - IB OUTLETS
    @IBOutlet var headerView: HeaderView!
    @IBOutlet var enableWhitelistingLbl: UILabel!
    @IBOutlet var whitlistingDescLbl: UILabel!
    
    @IBOutlet var extraSecurityLbl: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var tblViewHeightConst: NSLayoutConstraint!
	
	@IBOutlet var informationVw: UIView!
	@IBOutlet var informationLbl: UILabel!
	
    @IBOutlet var saveSettingsBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

	//MARK: - SetUpUI

    override func setUpUI(){
        self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
        self.headerView.headerLbl.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.enableWhitelistingLbl, text: CommonFunctions.localisation(key: "ADDRESS_BOOK_SECURITY"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.XXXLarge.sizeValue()))
        CommonUI.setUpLbl(lbl: self.whitlistingDescLbl, text: CommonFunctions.localisation(key: "ADDRESS_BOOK_LIMITS_WITHDRAWLS"), textColor: UIColor.SecondarytextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
        CommonUI.setTextWithLineSpacing(label: self.whitlistingDescLbl, text: CommonFunctions.localisation(key: "ADDRESS_BOOK_LIMITS_WITHDRAWLS"), lineSpacing: 6, textAlignment: .left)
        
        CommonUI.setUpLbl(lbl: self.extraSecurityLbl, text: CommonFunctions.localisation(key: "EXTRA_SECURITY"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypTextMedium(Size.Header.sizeValue()))
		
		CommonUI.setUpViewBorder(vw: self.informationVw, radius: 16, borderWidth: 0, borderColor: UIColor.ColorFFF2D9.cgColor, backgroundColor: UIColor.ColorFFF2D9)
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
		
		if(userData.shared.extraSecurity == "none"){
			CommonUI.setUpLbl(lbl: self.informationLbl, text: CommonFunctions.localisation(key: "CAN_WITHDRAW_IMMEDIATELY"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryPro(Size.Small.sizeValue()))
		}else{
//			CommonUI.setUpLbl(lbl: self.blockLbl, text: "\(CommonFunctions.localisation(key: "CHANGES_EFFECTIVE_AFTER")) \(CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime))", textColor: UIColor.primaryTextcolor, font: UIFont.MabryPro(Size.Small.sizeValue()))
			
			CommonUI.setUpLbl(lbl: self.informationLbl, text: CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)]), textColor: UIColor.primaryTextcolor, font: UIFont.MabryPro(Size.Small.sizeValue()))
		}
        
        self.saveSettingsBtn.setTitle(CommonFunctions.localisation(key: "SAVE_SETTINGS"), for: .normal)
        self.saveSettingsBtn.backgroundColor = UIColor.TFplaceholderColor
        self.saveSettingsBtn.isUserInteractionEnabled = false
        
        self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
        self.saveSettingsBtn.addTarget(self, action: #selector(saveSettingsBtnAct), for: .touchUpInside)
        
		for index in 0...(TimeData.count - 1){
			if TimeData[index].securityTime.encoderSecurityTime == userData.shared.extraSecurity{
				TimeData[index].isSelected = true
				selectedTime = TimeData[index]
				self.saveSettingsBtn.backgroundColor = UIColor.PurpleColor
				self.saveSettingsBtn.isUserInteractionEnabled = true
			}
		}
    }
}

//MARK: - objective functions
extension EnableWhitelistingVC{
    @objc func backBtnAct(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func saveSettingsBtnAct(){
        self.saveSettingsBtn.showLoading()
        enableWhitelistingVM.changeWhitelistingSecurityApi(withdrawalLock: self.selectedTime?.securityTime.encoderSecurityTime ?? "", controller: self, completion: {response in
			self.saveSettingsBtn.hideLoading()
			if response != nil {
				userData.shared.extraSecurity = self.selectedTime?.securityTime.encoderSecurityTime ?? ""
				userData.shared.dataSave()
				self.timeCallBack?(self.selectedTime)
			}
		})
		self.navigationController?.popViewController(animated: true)
        
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
		
		updateInformationLbl(timeDataSelected: TimeData[indexPath.row])
		
        for i in 0...(self.TimeData.count - 1){
            if TimeData[i].id ==  self.TimeData[indexPath.row].id{
                selectedTime = self.TimeData[indexPath.row]
            }else{
                self.TimeData[i].isSelected = false
            }
            self.tblView.reloadData()
        }
        
        if TimeData[indexPath.row].isSelected == true{
            self.saveSettingsBtn.backgroundColor = UIColor.PurpleColor
            self.saveSettingsBtn.isUserInteractionEnabled = true
        }else{
            self.saveSettingsBtn.backgroundColor = UIColor.TFplaceholderColor
            self.saveSettingsBtn.isUserInteractionEnabled = false
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

// MARK: - Others functions
extension EnableWhitelistingVC{
	func updateInformationLbl(timeDataSelected: SecurityTime){
		//selectedTime is the previous timeData
		switch userData.shared.extraSecurity {
			case "none":
				switch timeDataSelected.securityTime{
					case "NO_EXTRA_SECURITY":
						self.informationLbl.text = CommonFunctions.localisation(key: "CAN_WITHDRAW_IMMEDIATELY")
					default:
						self.informationLbl.text = CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED_FUTURE", parameter: [CommonFunctions.localisation(key: timeDataSelected.securityTime)])
				}
			case "1d":
				switch timeDataSelected.securityTime{
					case "72_HOURS":
						self.informationLbl.text = CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED_FUTURE", parameter: [CommonFunctions.localisation(key: timeDataSelected.securityTime)])
					case "24_HOURS":
						self.informationLbl.text = CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)])
					case "NO_EXTRA_SECURITY":
						self.informationLbl.text = "\( CommonFunctions.localisation(key: "CAN_WITHDRAW_IMMEDIATELY_FUTURE")) \( CommonFunctions.localisation(key: "CHANGES_EFFECTIVE_AFTER", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)]))"
					default:
						print("not handled")
				}
			case "3d":
				switch timeDataSelected.securityTime{
					case "72_HOURS":
						self.informationLbl.text = CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)])
					case "24_HOURS":
						self.informationLbl.text = "\(CommonFunctions.localisation(key: "NHOURS_DELAY_REQUIRED_FUTURE", parameter: [CommonFunctions.localisation(key: timeDataSelected.securityTime)])) \(CommonFunctions.localisation(key: "CHANGES_EFFECTIVE_AFTER", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)]))"
					case "NO_EXTRA_SECURITY":
						self.informationLbl.text = "\(CommonFunctions.localisation(key: "CAN_WITHDRAW_IMMEDIATELY_FUTURE")) \( CommonFunctions.localisation(key: "CHANGES_EFFECTIVE_AFTER", parameter: [CommonFunctions.localisation(key: userData.shared.extraSecurity.decoderSecurityTime)]))"
					default:
						print("not handled")
				}
			default:
				print("not handled")
		}
	}
}

