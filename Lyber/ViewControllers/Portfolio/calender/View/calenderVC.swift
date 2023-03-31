//
//  calenderVC.swift
//  Lyber
//
//  Created by sonam's Mac on 01/06/22.
//

import UIKit

class calenderVC: ViewController {
    //MARK: - Variables
    var dateCallBack : ((String,String)->())?
    //MARK: - IB OUTLETS
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateofBirthLbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: PurpleButton!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        self.dateView.layer.cornerRadius = 10
        self.dateView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,]
        datePicker.tintColor = UIColor.PurpleColor
        CommonUI.setUpLbl(lbl: self.dateofBirthLbl, text: CommonFunctions.localisation(key: "SELECT_BIRTH_DATE"),textColor: UIColor.whiteColor, font: UIFont.AtypDisplayMedium(Size.XLarge.sizeValue()))
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        self.doneBtn.setTitle(CommonFunctions.localisation(key: "DONE"), for: .normal)
        self.doneBtn.addTarget(self, action: #selector(doneAct), for: .touchUpInside)
        
        CommonUI.setUpButton(btn: cancelBtn, text: CommonFunctions.localisation(key: "CANCEL"), textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 12, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        self.cancelBtn.addTarget(self, action: #selector(cancelAct), for: .touchUpInside)
    }
    

    @objc func doneAct(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let strDate2 = dateFormatter2.string(from: datePicker.date)
        self.dateCallBack?(strDate,strDate2)
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func cancelAct(){
        self.dismiss(animated: true, completion: nil)
    }
}
