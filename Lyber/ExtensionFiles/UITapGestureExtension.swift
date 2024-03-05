//
//  UITapGestureExtension.swift
//  Lyber
//
//  Created by Elie Boyrivent on 22/02/2024.
//

import Foundation
import UIKit
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        var locationOfTouchInLabel = self.location(in: label)
        locationOfTouchInLabel.x += CGFloat(targetRange.length)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
        //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        let glyphRange = layoutManager.glyphRange(forCharacterRange: targetRange, actualCharacterRange: nil)
        var boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

        let extendUp : CGFloat = 15
        let extendDown : CGFloat = 15
        let shiftRight : CGFloat = 65
        boundingRect.origin.y -= extendUp
        boundingRect.size.height += extendUp + extendDown
        boundingRect.origin.x += shiftRight
        
        let extendedRect = boundingRect.insetBy(dx: -50, dy: 0)
        return extendedRect.contains(locationOfTouchInTextContainer)
    }
    
}
