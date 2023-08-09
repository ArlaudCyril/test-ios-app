//
//  TableViewScrollbar.swift
//  Lyber
//
//  Created by Lyber on 28/07/2023.
//

import Foundation
import UIKit

class CustomTableView: UITableView {
	override func layoutSubviews() {
		super.layoutSubviews()
		showVerticalScrollIndicator()
	}
	
	func showVerticalScrollIndicator() {
		for view in subviews {
			if let indicator = view as? UIImageView, view.bounds.width == 4.0 {
				indicator.backgroundColor = UIColor.gray // Change the color as desired
				indicator.layer.cornerRadius = 2.0 // Adjust the corner radius as desired
				indicator.clipsToBounds = true
				
			}
		}
	}
}
