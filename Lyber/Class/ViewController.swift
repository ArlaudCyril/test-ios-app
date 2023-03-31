//
//  ViewController.swift
//  Lyber
//
//  Created by Lyber on 29/03/2023.
//

import Foundation
import UIKit


/// This class permit to handle the language of the app
class ViewController : UIViewController{
	var language = userData.shared.language
	
	override func viewWillAppear(_ animated: Bool) {
		if(self.language != userData.shared.language){
			self.setUpUI()
			self.language = userData.shared.language
		}
	}
	
	func setUpUI(){
		
	}
}
