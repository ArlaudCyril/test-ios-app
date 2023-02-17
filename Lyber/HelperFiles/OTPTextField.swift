//
//  OTptextField.swift
//  Lyber
//
//  Created by sonam's Mac on 27/05/22.
//

import Foundation
import UIKit
protocol MyTextFieldDelegate: AnyObject {
    func textFieldDidDelete(_ tf: UITextField)
}

class otpTextField: UITextField {

    weak var otpDelegate: MyTextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()
        otpDelegate?.textFieldDidDelete(self)
    }
}
