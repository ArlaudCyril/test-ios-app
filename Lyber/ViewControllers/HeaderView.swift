//
//  HeaderView.swift
//  Lyber
//
//  Created by sonam's Mac on 26/07/22.
//

import UIKit

class HeaderView: UIView {
    //MARK: - IB OUTLETS
    @IBOutlet var contentView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!
    
    override init(frame: CGRect) {
           super.init(frame: frame)
        
           commonInit()
       }
        required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
        }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        CommonUI.setUpLbl(lbl: self.headerLbl, text: L10n.enterEmail.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
    }
}
