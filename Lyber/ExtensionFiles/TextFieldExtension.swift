//
//  TextFieldExtension.swift
//  Lyber
//
//  Created by sonam's Mac on 31/05/22.
//

import Foundation
import UIKit

extension UITextField {
  var placeholder: String? {
      get {
          attributedPlaceholder?.string
      }

      set {
          guard let newValue = newValue else {
              attributedPlaceholder = nil
              return
          }

          let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.TFplaceholderColor]

          let attributedText = NSAttributedString(string: newValue, attributes: attributes)

          attributedPlaceholder = attributedText
      }
  }
}
