//
//  AboutTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 16/06/22.
//

import UIKit
import ExpandableLabel

class AboutTVC: UITableViewCell, ExpandableLabelDelegate {
    //MARK: - Variables
    var isExpand = false
    var controller : PortfolioDetailVC?
    
    //MARK:- IB OUTLETS
    @IBOutlet var descvw: UIView!
    @IBOutlet var descriptionLbl: ExpandableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//MARK: - SetUpUI
extension AboutTVC{
    func setUpCell(assetData : AssetDetailApi?){
        self.descvw.layer.cornerRadius = 16
        if !isExpand {
            DispatchQueue.main.async {

                self.descriptionLbl.delegate = self
                self.descriptionLbl.numberOfLines = 3
                self.descriptionLbl.shouldCollapse = true
                self.descriptionLbl.collapsed = true
                
                
                self.descriptionLbl.collapsedAttributedLink = NSAttributedString(string: CommonFunctions.localisation(key: "VIEW_MORE"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.PurpleColor,NSAttributedString.Key.font : UIFont.MabryProBold(Size.Large.sizeValue()),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue])
                self.descriptionLbl.ellipsis = NSAttributedString(string: "...")
				if(userData.shared.language == "fr")
				{
					self.descriptionLbl.text = assetData?.data?.about?.fr ?? ""
				}else{
					self.descriptionLbl.text = assetData?.data?.about?.en ?? ""
				}
                self.descriptionLbl.layoutIfNeeded()
                self.descriptionLbl.layoutSubviews()
                self.contentView.setNeedsLayout()
                
            }
        }else{
                self.descriptionLbl.expandedAttributedLink = NSAttributedString(string: CommonFunctions.localisation(key: "READ_LESS"), attributes: [NSAttributedString.Key.foregroundColor : UIColor.PurpleColor,NSAttributedString.Key.font : UIFont.MabryProBold(Size.Large.sizeValue()),NSAttributedString.Key.underlineStyle : NSUnderlineStyle.thick.rawValue])
                self.descriptionLbl.ellipsis = NSAttributedString(string: "...")
			if(userData.shared.language == "fr")
				{
					self.descriptionLbl.text = assetData?.data?.about?.fr ?? ""
				}else{
					self.descriptionLbl.text = assetData?.data?.about?.en ?? ""
				}
                self.descriptionLbl.layoutIfNeeded()
                self.descriptionLbl.layoutSubviews()
                self.contentView.setNeedsLayout()
        }
        
    }
    
}


extension AboutTVC{
    func willExpandLabel(_ label: ExpandableLabel) {
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        isExpand = true
        self.controller?.tblView.reloadData()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        isExpand = false
        self.controller?.tblView.reloadData()
    }
}
