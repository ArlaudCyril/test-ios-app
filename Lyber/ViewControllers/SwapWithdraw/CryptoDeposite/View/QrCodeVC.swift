//
//  QrCodeVC.swift
//  Lyber
//
//  Created by Lyber on 19/04/2023.
//

import Foundation
import UIKit
import SwiftUI

//MARK: - Initialisation
class QrCodeVC : ViewController {
	
	//MARK: - Variables
	var urlQrCode: String?
	//MARK: - IB OUTLETS
	@IBOutlet var headerView: HeaderView!
	
	@IBOutlet var qrCode: UIImageView!

	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpUI()
	}
	
	
	//MARK: - Functions
	override func setUpUI(){
		self.headerView.backBtn.setImage(Assets.back.image(), for: .normal)
		self.headerView.headerLbl.isHidden = true
		
		self.qrCode.image = self.generateQRCode(string:urlQrCode ?? "")
		self.headerView.backBtn.addTarget(self, action: #selector(backBtnAct), for: .touchUpInside)
	}
	
	@objc func backBtnAct(){
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	func generateQRCode(string: String)->UIImage?{
		let data = string.data(using: String.Encoding.ascii)
		
		if let filter = CIFilter(name: "CIQRCodeGenerator"){
			filter.setValue(data, forKey: "inputMessage")
			
			let transform = CGAffineTransform(scaleX: 10, y: 10)
			if let output = filter.outputImage?.transformed(by: transform)
			{
				return UIImage(ciImage: output)
				
			}
			
		}
		return nil
	}
	
	
}

