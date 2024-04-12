//
//  AllocationVC.swift
//  Lyber
//
//  Created by sonam's Mac on 09/06/22.
//

import UIKit

class AllocationVC: ViewController {
    //MARK: - Variables
    var pickerData = ["5%","10%","15%","20%","25%","30%","35%","40%","45%","50%","55%","60%","65%","70%","75%","80%","85%","90%","95%","100%"]
    var allocationSelected : String!
    var allocationCallBack : ((String)->())?
    var name: String?
    
    //MARK: - IB OUTLETS
    @IBOutlet var allocationVw: UIView!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var allocationLbl: UILabel!
    @IBOutlet var coinNameLbl: UILabel!
    @IBOutlet var pickerVw: UIPickerView!
    @IBOutlet var setAllocationBtn: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }


	//MARK: - SetUpUI

    override func setUpUI(){
        allocationVw.layer.cornerRadius = 32
        allocationVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.cancelBtn.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.allocationLbl, text: CommonFunctions.localisation(key: "ALLOCATION"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.coinNameLbl, text: self.name, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        self.setAllocationBtn.setTitle(CommonFunctions.localisation(key: "SET_THIS_ALLOCATION"), for: .normal)
        pickerVw.delegate = self
        pickerVw.dataSource = self
        for i in 0...(pickerData.count - 1){
            if pickerData[i] == allocationSelected{
                self.pickerVw.selectRow(i, inComponent: 0, animated: false)
            }
        }
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.setAllocationBtn.addTarget(self, action: #selector(setAllocationBtnAct), for: .touchUpInside)
    }
}

//MARK: - UIPickerViewDelegate and UIPickerViewDataSource
extension AllocationVC: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        allocationSelected = pickerData[row]
    }
}

//MARK:- objective functions
extension AllocationVC{
    @objc func cancelBtnAct(){
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func setAllocationBtnAct(){
        allocationCallBack?(allocationSelected)
        self.dismiss(animated: true, completion: nil)
    }
}
