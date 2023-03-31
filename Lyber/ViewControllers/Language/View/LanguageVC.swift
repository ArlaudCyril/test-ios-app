//
//  LanguageVC.swift
//  Lyber
//
//  Created by Lyber on 28/03/2023.
//

import Foundation
import UIKit
import SwiftUI

final class LanguageVC: ViewController{
	
	//MARK: - Variables
	
	//MARK:- IB OUTLETS
	@IBOutlet var cancelBtn: UIButton!
	@IBOutlet var languageLbl: UILabel!
	@IBOutlet var tblView: UITableView!
	@IBOutlet var tblViewHeightConst: NSLayoutConstraint!
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	override func setUpUI(){
		CommonUI.setUpLbl(lbl: self.languageLbl, text: CommonFunctions.localisation(key: "LANGUAGE"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.tblView.delegate = self
		self.tblView.dataSource = self
		self.tblView.layer.cornerRadius = 15
		self.tblView.tableFooterView = UIView()
		self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
	}
	
	
	
}

//Mark:- table view delegates and dataSource
extension LanguageVC : UITableViewDelegate, UITableViewDataSource{
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return GlobalVariables.languageArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTVC", for: indexPath)as! LanguageTVC
		cell.setupCell(language: GlobalVariables.languageArray[indexPath.row])
		if (indexPath.row == GlobalVariables.languageArray.count-1) {
			/*cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)*/
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		setNewLanguage(language: GlobalVariables.languageArray[indexPath.row])
		tableView.reloadData()
	}
	
}

// MARK: - TABLE VIEW OBSERVER
extension LanguageVC{
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

//MARK: - objective functions
extension LanguageVC{
	@objc func cancelBtnAct(){
		self.navigationController?.popViewController(animated: true)
	}
}

//MARK: - others functions
extension LanguageVC{
	func setNewLanguage(language: Language){
		//changement faster on the screen
		userData.shared.language = language.id
		userData.shared.dataSave()
		self.tblView.reloadData()
		LanguageVM().setLanguageAPI(language: language.id, completion: {[]response in
			if response != nil{
				let path = Bundle.main.path(forResource: language.id, ofType: "lproj")!
				GlobalVariables.bundle = Bundle(path: path)!
			}
		})
	}
}

