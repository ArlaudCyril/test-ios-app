//
//  MaintenanceVC.swift
//  Lyber
//
//  Created by Elie Boyrivent on 26/05/22.
//

import UIKit


class MaintenanceVC: ViewController {
    var typePage: TypeMaintenance = .maintenance
    
	//MARK: - IB OUTLETS
    @IBOutlet var backgroundImgVw: UIImageView!
	@IBOutlet var iconImgVw: UIImageView!
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
        if(self.typePage == .update){
            self.iconImgVw.image = Assets.cloud_download.image()
            CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_UPDATE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        }else{
            self.iconImgVw.image = Assets.maintenance_icon.image()
            CommonUI.setUpLbl(lbl: titleLbl, text: CommonFunctions.localisation(key: "LYBER_UNDER_MAINTENANCE"), textColor: UIColor.primaryTextcolor, font: UIFont.AtypDisplayMedium(Size.XVLarge.sizeValue()))
        }
		
	}
}
