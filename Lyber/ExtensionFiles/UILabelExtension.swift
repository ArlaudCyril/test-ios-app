//
//  UILabelExtension.swift
//  Lyber
//
//  Created by Elie Boyrivent on 07/08/2024.
//

import Foundation
import UIKit
import ObjectiveC

private var originalTextKey: UInt8 = 0

extension UILabel {
    var originalText: String? {
        get {
            return objc_getAssociatedObject(self, &originalTextKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &originalTextKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func checkMaskBalance() {
        if userData.shared.hideBalance {
            maskText()
        } else {
            unmaskText()
        }
    }

    private func maskText() {
        if originalText == nil {
            originalText = self.text
        }
        guard let text = originalText else { return }
        self.text = String(repeating: "*", count: text.count)
    }

    private func unmaskText() {
        guard let text = originalText else { return }
        self.text = text
    }
}
