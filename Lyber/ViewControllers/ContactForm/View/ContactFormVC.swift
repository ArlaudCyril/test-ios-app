//
//  ContactFormVC.swift
//  Lyber
//
//  Created by Lyber on 02/10/2023.
//

import Foundation
import UIKit

class ContactFormVC: SwipeGesture{
	
	//MARK: - Variables
	
	//MARK:- IB OUTLETS
	@IBOutlet var backBtn: UIButton!
	@IBOutlet var contactFormLbl: UILabel!
	
	@IBOutlet var emailVw: UIView!
	@IBOutlet var emailIcon: UIImageView!
	@IBOutlet var emailTitleLbl: UILabel!
	@IBOutlet var emailDescTV: UITextView!
	
	@IBOutlet var contactVw: UIView!
	@IBOutlet var contactLbl: UILabel!
	@IBOutlet var messageTV: UITextView!
	
	@IBOutlet var sendBtn: PurpleButton!
	
	@IBOutlet var addressVw: UIView!
	@IBOutlet var addressIcon: UIImageView!
	@IBOutlet var addressTitleLbl: UILabel!
	@IBOutlet var addressDescLbl: UILabel!
	
	@IBOutlet var footerLbl: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	override func setUpUI(){
		CommonUI.setUpLbl(lbl: self.contactFormLbl, text: CommonFunctions.localisation(key: "CONTACT_US"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		self.emailVw.backgroundColor = UIColor.greyBackgroundColor
		self.emailVw.layer.cornerRadius = 16
		
		CommonUI.setUpLbl(lbl: self.emailTitleLbl, text: CommonFunctions.localisation(key: "EMAIL"), textColor: UIColor.titleFontColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		self.emailIcon.image = UIImage(asset: Assets.mail)
		
        //emailDescTV
        self.emailDescTV.dataDetectorTypes = [.link]
        emailDescTV.isScrollEnabled = false
        self.emailDescTV.backgroundColor = .clear

        self.emailDescTV.textContainerInset = UIEdgeInsets.zero
        self.emailDescTV.textContainer.lineFragmentPadding = 0
        
        let attributedString = NSMutableAttributedString(string: CommonFunctions.localisation(key: "SEND_US_OR_FILL_OUT"))
        let range = (attributedString.string as NSString).range(of: "contact@lyber.com")
        attributedString.addAttribute(.link, value: "mailto:contact@lyber.com", range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        
        emailDescTV.linkTextAttributes = [
                .foregroundColor: UIColor.purple_500
            ]
        self.emailDescTV.attributedText = attributedString
        self.emailDescTV.font = UIFont.MabryProMedium(Size.Medium.sizeValue())
        self.emailDescTV.textColor = UIColor.descFontColor
		
        //contactVw
		self.contactVw.backgroundColor = UIColor.greyBackgroundColor
		self.contactVw.layer.cornerRadius = 16
		
		CommonUI.setUpLbl(lbl: self.contactLbl, text: CommonFunctions.localisation(key: "CONTACT_FORM"), textColor: UIColor.primaryTextcolor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
        self.messageTV.delegate = self
		self.messageTV.text = CommonFunctions.localisation(key: "DESCRIBE_PROBLEM")
        self.messageTV.textColor = UIColor.lightGray
        
        
		self.addressVw.backgroundColor = UIColor.greyBackgroundColor
		self.addressVw.layer.cornerRadius = 16
		
		CommonUI.setUpLbl(lbl: self.addressTitleLbl, text: CommonFunctions.localisation(key: "ADDRESS"), textColor: UIColor.titleFontColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		
		self.addressIcon.image = UIImage(asset: Assets.locationIcon)
		
		CommonUI.setUpLbl(lbl: self.addressDescLbl, text: CommonFunctions.localisation(key: "CONTACT_LYBER_ADDRESS"), textColor: UIColor.descFontColor, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
		self.addressDescLbl.numberOfLines = 0
		
		self.addressDescLbl.attributedText = CommonFunctions.underlineStringInText(str: "274 ter/3, Avenue de la Marne, 59700 Marcq-en-Baroeul, Lille, France.", text: self.addressDescLbl.text ?? "")
		
		CommonUI.setUpLbl(lbl: self.footerLbl, text: CommonFunctions.localisation(key: "WILL_GET_BACK_TO_YOU", parameter: userData.shared.email), textColor: UIColor.descFontColor, font: UIFont.MabryProMedium(Size.Medium.sizeValue()))
		self.footerLbl.numberOfLines = 0
		
		self.backBtn.setImage(Assets.back.image(), for: .normal)
		
		self.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
		
		self.sendBtn.setTitle(CommonFunctions.localisation(key: "SEND"), for: .normal)
		
		self.sendBtn.addTarget(self, action: #selector(sendBtnAct), for: .touchUpInside)
	}
	
	
	
}

//MARK: - objective functions
extension ContactFormVC{
	@objc func backBtnAct(){
		self.navigationController?.popViewController(animated: false)
	}
	
	@objc func sendBtnAct(){
		sendBtn.isUserInteractionEnabled = false
		ContactFormVM().contactSupportAPI(message: self.messageTV.text ?? "", completion:{response in
			self.sendBtn.isUserInteractionEnabled = true
			if(response != nil){
				CommonFunctions.toster(CommonFunctions.localisation(key: "MESSAGE_SENT_SUCCESSFULLY"))
				self.navigationController?.popToViewController(ofClass: PortfolioHomeVC.self)
			}
		})
	}
}

//MARK: - UITextViewDelegate
extension ContactFormVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
}
