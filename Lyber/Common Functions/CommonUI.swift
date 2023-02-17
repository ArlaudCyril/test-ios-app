//
//  CommonUI.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit

class CommonUI{
    static func setUpLbl(lbl:UILabel, text: String? = nil, textColor:UIColor, font: UIFont) {
        lbl.text = text
        lbl.font = font
        lbl.textColor = textColor
    }
    
    static func setUpTextField(textfield:UITextField, text: String? = nil, placeholder:String, font: UIFont) {
        textfield.text = text
        textfield.font = font
        textfield.placeholder = placeholder
    }
    
    static func setUpViewBorder(vw:UIView,radius: CGFloat?,borderWidth: CGFloat?,borderColor: CGColor?,backgroundColor: UIColor? = UIColor.whiteColor){
        vw.layer.cornerRadius = radius ?? 0
        vw.layer.borderColor = borderColor ?? UIColor() as! CGColor
        vw.layer.borderWidth = borderWidth ?? 0
        vw.backgroundColor = backgroundColor
    }
    
    static func errorOnView(vw:UIView,borderColor: CGColor?){
        vw.layer.borderColor = UIColor.red.cgColor
    }
    
    static func setUpButton(btn : UIButton,text: String,textcolor: UIColor,backgroundColor: UIColor,cornerRadius: CGFloat,font: UIFont){
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(textcolor, for: .normal)
        btn.backgroundColor = backgroundColor
        btn.layer.cornerRadius = cornerRadius
        btn.titleLabel?.font = font
    }
    
    static func setTextWithLineSpacing(label:UILabel,text:String,lineSpacing:CGFloat,textAlignment : NSTextAlignment)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        label.attributedText = attrString
        label.textAlignment = textAlignment
    }
    
    static func StrikeThroughLabel(lbl : UILabel,textcolor : UIColor){
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: lbl.text ?? "")
//        attributeString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        lbl.attributedText = attributeString
        lbl.textColor = textcolor
    }
    
    static func removeStrikeThrough(lbl : UILabel,textcolor : UIColor){
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: lbl.text ?? "")
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
        lbl.attributedText = attributeString
        lbl.textColor = textcolor
    }
    
    static func showAttributedString(firstStr : String,secondStr: String,firstFont : UIFont,secondFont: UIFont, firstColor : UIColor, secondColor : UIColor) -> (NSAttributedString){
        let myAttribute1 = [ NSAttributedString.Key.font: firstFont,NSAttributedString.Key.foregroundColor :  firstColor]
        let myString1 = NSMutableAttributedString(string: firstStr, attributes: myAttribute1)
        myString1.addAttributes(myAttribute1, range: NSRange(secondStr) ?? NSRange())

        let myAttribute2 = [ NSAttributedString.Key.font: secondFont,NSAttributedString.Key.foregroundColor :  secondColor]
        let myString2 = NSMutableAttributedString(string: secondStr, attributes: myAttribute2)

        myString1.append(myString2)
        return myString1
    }

    static func attributedString(firstStr : String,secondStr: String,firstFont : UIFont,secondFont: UIFont, firstColor : UIColor, secondColor : UIColor) -> (NSAttributedString){
        let myAttribute2 = [ NSAttributedString.Key.font: secondFont,NSAttributedString.Key.foregroundColor :  secondColor]
        let attrString = NSMutableAttributedString(string: firstStr)
        let substringRange = firstStr.range(of: secondStr)!
        attrString.addAttributes(myAttribute2, range: NSRange(substringRange, in: firstStr))
        return attrString
    }
}
