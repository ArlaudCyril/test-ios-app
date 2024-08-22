//
//  RecurringTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 15/06/22.
//

import UIKit

class RecurringTVC: UITableViewCell {
    var controller: UIViewController?
    //MARK:- IB OUTLETS
    @IBOutlet var recurringVw: UIView!
    @IBOutlet var strategyImgVw: UIImageView!
    @IBOutlet var strategyLbl: UILabel!
    @IBOutlet var frequenceLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension RecurringTVC{
    func setUpCell(data : RecurrentInvestmentStrategy?,index : Int,lastIndex : Int){
		
		self.strategyImgVw.image = Assets.intermediate_strategy.image()
        
        CommonUI.setUpLbl(lbl: self.strategyLbl, text: data?.strategyName , textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.frequenceLbl, text: CommonFunctions.frequenceDecoder(frequence: data?.frequency ?? ""), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: self.dateLbl, text:"\(CommonFunctions.localisation(key: "NEXT_PAYMENT")):  \(CommonFunctions.getDateFormat(date: data?.nextExecution ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMMM"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: self.euroLbl, text: "\(String(data?.amount ?? 0))€", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        if index == 0{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if index == lastIndex{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
            recurringVw.layer.cornerRadius = 0
        }
        
        if lastIndex == 0{
            recurringVw.layer.cornerRadius = 16
            recurringVw.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
        
        let recurringTap = UITapGestureRecognizer(target: self, action: #selector(recurringTapped))
        self.recurringVw.addGestureRecognizer(recurringTap)
    }
    
    @objc func recurringTapped(){
        let vc = InvestmentStrategyVC.instantiateFromAppStoryboard(appStoryboard: .Strategies)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.controller?.present(nav, animated: false, completion: nil)
    }
}
