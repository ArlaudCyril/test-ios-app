//
//  MaintenanceVC.swift
//  Lyber
//
//  Created by Elie Boyrivent on 26/05/22.
//

import UIKit


class MaintenanceVC: ViewController {
	
	//MARK: - IB OUTLETS
	@IBOutlet var backgroundImgVw: UIImageView!
	@IBOutlet var titleLbl: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
	
	
	//MARK: - SetUpUI
	override func setUpUI(){
		CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_UNDER_MAINTENANCE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
	}
}
