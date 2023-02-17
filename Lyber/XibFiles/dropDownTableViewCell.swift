//
//  dropDownTableViewCell.swift
//  Lyber
//
//  Created by sonam's Mac on 05/08/22.
//

import UIKit
import DropDown

class dropDownTableViewCell: DropDownCell {

    @IBOutlet var textLbl: UILabel!
    @IBOutlet var imgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
