//
//  ProfileAccountTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class ProfileAccountTVC: UITableViewCell {
    var controller : ProfileVC?
    //MARK: - IB OUTLETS
    @IBOutlet var outerView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var nameDescLbl: UILabel!
	@IBOutlet var valueView: UIView!
	@IBOutlet var valueLbl: UILabel!
    @IBOutlet var rightArrowView: UIView!
    @IBOutlet var rightArrowBtn: UIButton!
    @IBOutlet var switchView: UIView!
    @IBOutlet var switchBtn: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension ProfileAccountTVC{
    func setUpCell(data : SecurityModel?,index : IndexPath,lastIndex : Int){
        CommonUI.setUpLbl(lbl: nameLbl, text: data?.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: nameDescLbl, text: data?.desc, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		self.valueView.isHidden = true
        self.rightArrowView.isHidden = false
        self.switchView.isHidden = true
        self.switchBtn.addTarget(self, action: #selector(switchBtnAct), for: .touchUpInside)
        if index.section == 2{
            self.nameDescLbl.isHidden = true
			if(index.row == 0){
				outerView.layer.cornerRadius = 16
				outerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
			}
			if(index.row == 1){
				outerView.layer.cornerRadius = 16
				outerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
				self.valueView.isHidden = false
				CommonUI.setUpLbl(lbl: self.valueLbl, text: CommonFunctions.nameLanguage(), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
			}
        }else if index.section == 3{
            if index.row == 0{
                outerView.layer.cornerRadius = 16
                outerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            }else if index.row == lastIndex{
                outerView.layer.cornerRadius = 16
                outerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
                self.switchView.isHidden = false
                if controller?.faceIdEnable == 1{
                    self.switchBtn.setOn(true, animated: false)
                }else{
                    self.switchBtn.setOn(false, animated: false)
                }
                
                self.rightArrowView.isHidden = true
            }else{
                outerView.layer.cornerRadius = 0
            }
        }
    }

}

//MARK: - objective functions
extension ProfileAccountTVC{
    @objc func switchBtnAct(sender : UISwitch){
        if sender.isOn == true{
            print("on")
            self.enableFaceId(enable: 1)
        }else {
            print("off")
            self.enableFaceId(enable: 0)
        }
    }
}

//MARK: - Other functions
extension ProfileAccountTVC{
    func enableFaceId(enable : Int){
        EnterPhoneVM().enableFaceIdApi(enable: enable, completion: {[]response in
            if let response = response{
                print(response)
            }
        })
    }
}
