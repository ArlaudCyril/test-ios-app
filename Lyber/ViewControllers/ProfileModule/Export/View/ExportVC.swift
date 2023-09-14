//
//  ExportVC.swift
//  Lyber
//
//  Created by Lyber on 31/08/2023.
//

import Foundation
import UIKit
import DropDown

class ExportVC: SwipeGesture {
	//MARK: - Variables
	var dropDownExport = DropDown()
	var dateToExport = ""
	//MARK: - IB OUTLETS
	@IBOutlet var headerView: HeaderView!
	@IBOutlet var exportLbl: UILabel!

	@IBOutlet var exportVw: UIView!
	@IBOutlet var exportNameLbl: UILabel!
	
	
	@IBOutlet var exportBtn: PurpleButton!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	//MARK: - SetUpUI
	
	override func setUpUI(){
		self.headerView.headerLbl.isHidden = true
		self.headerView.backBtn.isHidden = false
		self.headerView.closeBtn.isHidden = true
		
		CommonUI.setUpLbl(lbl: self.exportLbl, text: CommonFunctions.localisation(key: "EXPORT_OPERATIONS"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
		
		//export Dropdown
		dropdownExportConfiguration()
		let exportTap = UITapGestureRecognizer(target: self, action: #selector(exportSelect))
		self.exportVw.addGestureRecognizer(exportTap)
	
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
		
		self.exportBtn.setTitle(CommonFunctions.localisation(key: "EXPORT"), for: .normal)
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		self.exportBtn.addTarget(self, action: #selector(exportBtnAct), for: .touchUpInside)
	}
	
}

//MARK: - objective functions
extension ExportVC{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: false)
	}
	
	@objc func exportBtnAct(){
		ExportVm().exportApi(date: self.dateToExport, completion: {response in
			let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
			vc.previousViewController = self
			if response != nil{
				vc.confirmationType = .exportSuccess
			}else{
				vc.confirmationType = .exportFailure
			}
			self.present(vc, animated: true)
		})
	}
	
	@objc func exportSelect(){
		self.dropDownExport.show()
	}
}

//MARK: - Other functions
extension ExportVC{
	func dropdownExportConfiguration(){
		CommonUI.setUpViewBorder(vw: exportVw ?? UIView(), radius: 12, borderWidth: 1.5, borderColor: UIColor.borderColor.cgColor)
		
		
		dropDownExport.cellHeight = 44
		dropDownExport.anchorView = exportVw
		dropDownExport.bottomOffset = CGPoint(x: 0, y: exportVw.frame.height)
		dropDownExport.textFont = UIFont.MabryPro(Size.Large.sizeValue())
		dropDownExport.backgroundColor = UIColor.PurpleGrey_50
		dropDownExport.cornerRadius = 8
		
		self.dropDownExport.dataSource = []
		//TODO: set dataSource
		for month in monthsFromDateToDateNow(dateString: userData.shared.registeredAt) ?? []{
			self.dropDownExport.dataSource.append(month)
		}
		
		CommonUI.setUpLbl(lbl: self.exportNameLbl ?? UILabel(), text: CommonFunctions.getDateFormat(date: self.dropDownExport.dataSource[self.dropDownExport.dataSource.count-1], inputFormat: "yyyy-MM", outputFormat: "MMMM yyyy") , textColor: UIColor.ThirdTextColor, font: UIFont.MabryPro(Size.Large.sizeValue()))
		self.dateToExport = self.dropDownExport.dataSource[self.dropDownExport.dataSource.count-1]
		
		//configuration printing dropdown
		dropDownExport.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			cell.optionLabel.text = CommonFunctions.getDateFormat(date: item, inputFormat: "yyyy-MM", outputFormat: "MMMM yyyy")
		}
		
		//when one option is selected
		dropDownExport.selectionAction = {[weak self] (index: Int,item: String) in
			self?.exportNameLbl.text = CommonFunctions.getDateFormat(date: item, inputFormat: "yyyy-MM", outputFormat: "MMMM yyyy")
			self?.dateToExport = item
		}
		
	}
	
	func monthsFromDateToDateNow(dateString: String) -> [String]? {
		// (EN) Create a DateFormatter to parse the date string
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		
		guard let startDate = formatter.date(from: dateString) else {
			return nil
		}
		
		// (EN) Get current date and set up the calendar
		let currentDate = Date()
		var date = startDate
		var months: [String] = []
		
		while date <= currentDate {
			// (EN) Get month and year in "YYYY-MM" format
			formatter.dateFormat = "yyyy-MM"
			months.append(formatter.string(from: date))
			
			// (EN) Increment date by one month
			// (FR) Augmenter la date d'un mois
			date = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
		}
		
		return months
	}
}
