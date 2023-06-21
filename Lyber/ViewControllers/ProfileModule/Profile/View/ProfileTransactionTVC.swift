//
//  ProfileTransactionTVC.swift
//  Lyber
//
//  Created by sonam's Mac on 22/06/22.
//

import UIKit

class ProfileTransactionTVC: UITableViewCell {
    //MARK: - Variables
    var controller : ProfileVC?
    //MARK: - IB OUTLETS
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var coinImg: UIImageView!
    @IBOutlet var transactionTypeLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    
    @IBOutlet var viewAllVw: UIView!
    @IBOutlet var viewAllBtn: UIButton!
    
    @IBOutlet var noTransactionVw: UIView!
    @IBOutlet var noTransactionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ProfileTransactionTVC{
    func setUpCell(data : Transaction?,row : Int,lastIndex : Int){
		CommonUI.setUpLbl(lbl: transactionTypeLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: euroLbl, text: "", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: dateLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: noOfCoinLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		
		
		if data?.type == "order"{
			self.coinImg.image = Assets.exchange.image()
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "EXCH")) \(data?.fromAsset?.uppercased() ?? "") -> \(data?.toAsset?.uppercased() ?? "")"
			self.euroLbl.text = "-\(data?.fromAmount ?? "") \(data?.fromAsset?.uppercased() ?? "")"
			self.noOfCoinLbl.text = "+\(data?.toAmount ?? "") \(data?.toAsset?.uppercased() ?? "")"
		}else if data?.type == "deposit"{
			self.coinImg.image = Assets.money_deposit.image()
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "DEPOSIT")) \(data?.asset?.uppercased() ?? "")"
			self.euroLbl.text = "+\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
		}else if data?.type == "withdraw"{
			self.coinImg.image = Assets.withdraw.image()
			self.transactionTypeLbl.text = CommonFunctions.localisation(key: "WITHDRAWAL")
			self.euroLbl.text = "-\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
		}
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"
		let date = formatter.date(from: data?.date ?? "") ?? Date()
		self.dateLbl.text = dateFormatter.string(from: date)
        
        
        CommonUI.setUpButton(btn: viewAllBtn, text: CommonFunctions.localisation(key: "VIEW_ALL"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 16, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        viewAllBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "VIEW_ALL")), for: .normal)
        viewAllBtn.addTarget(self, action: #selector(viewAllBtnAction), for: .touchUpInside)
        
        if row == 0{
            viewAllVw.isHidden = true
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if row == lastIndex{
            viewAllVw.isHidden = false
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
            viewAllVw.isHidden = true
			stackView.layer.cornerRadius = 0
        }
        
        if row == lastIndex{
            viewAllVw.isHidden = false
        }
        self.noTransactionVw.isHidden = true
    }
}

//MARK: - objective functions
extension ProfileTransactionTVC{
    @objc func viewAllBtnAction(){
        let vc = TransactionVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
        self.controller?.navigationController?.pushViewController(vc, animated: true)
    }
}
