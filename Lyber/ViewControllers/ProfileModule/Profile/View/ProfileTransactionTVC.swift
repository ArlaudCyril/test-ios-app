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
	
	@IBOutlet var amountVw: UIView!
    @IBOutlet var euroLbl: UILabel!
    @IBOutlet var noOfCoinLbl: UILabel!
    
    @IBOutlet var viewAllVw: UIView!
    @IBOutlet var viewAllBtn: UIButton!
    
    @IBOutlet var noTransactionVw: UIView!
    @IBOutlet var noTransactionLbl: UILabel!
	
	@IBOutlet var failureIcon: UIImageView!
    
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
		self.dateLbl.numberOfLines = 0
		
		
		if data?.type == "order"{
			self.coinImg.image = Assets.exchange.image()
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "EXCHANGE_NOUN"))"
			self.dateLbl.text = "\(data?.fromAsset?.uppercased() ?? "") -> \(data?.toAsset?.uppercased() ?? "")"
			self.euroLbl.text = "-\(data?.fromAmount ?? "") \(data?.fromAsset?.uppercased() ?? "")"
			self.noOfCoinLbl.text = "+\(data?.toAmount ?? "") \(data?.toAsset?.uppercased() ?? "")"
			
		}else if data?.type == "deposit"{
			self.coinImg.image = Assets.money_deposit.image()
			self.transactionTypeLbl.text = "\(CommonFunctions.localisation(key: "DEPOSIT_TRANSACTION", parameter: data?.asset?.uppercased() ?? ""))"
			self.euroLbl.text = "+\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
			self.dateLbl.text = data?.status?.decoderStatusDeposit
			
		}else if data?.type == "withdraw"{
			self.coinImg.image = Assets.withdraw.image()
			self.transactionTypeLbl.text = CommonFunctions.localisation(key: "WITHDRAWAL_TRANSACTION", parameter: data?.asset?.uppercased() ?? "")
			self.euroLbl.text = "-\(data?.amount ?? "") \(data?.asset?.uppercased() ?? "")"
			self.dateLbl.text = data?.status?.decoderStatusWithdraw
			
		}else if data?.type == "strategy"{
			if(data?.status == "FAILURE")
			{
				self.failureIcon.isHidden = false
				self.amountVw.isHidden = true
			}else{
				self.euroLbl.text = "\(data?.totalStableAmountSpent ?? "0") USDT"
			}
			self.coinImg.image = Assets.intermediate_strategy_outline.image()
			self.transactionTypeLbl.text = data?.strategyName
			if(!(data?.nextExecution?.isEmpty ?? true)){
				self.dateLbl.text = "\(CommonFunctions.localisation(key: "NEXT_PAYMENT")):  \(CommonFunctions.getDateFormat(date: data?.nextExecution ?? "", inputFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", outputFormat: "dd MMMM"))"
			}
		}
		
        
        CommonUI.setUpButton(btn: viewAllBtn, text: CommonFunctions.localisation(key: "VIEW_ALL"), textcolor: UIColor.PurpleColor, backgroundColor: UIColor.clear, cornerRadius: 16, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        viewAllBtn.setAttributedTitle(CommonFunctions.underlineString(str: CommonFunctions.localisation(key: "VIEW_ALL")), for: .normal)
        viewAllBtn.addTarget(self, action: #selector(viewAllBtnAction), for: .touchUpInside)
		viewAllVw.isHidden = true
		
		if row == 0 && row == lastIndex{
			viewAllVw.isHidden = false
			stackView.layer.cornerRadius = 16
			stackView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
		}else if row == 0{
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }else if row == lastIndex{
            viewAllVw.isHidden = false
            stackView.layer.cornerRadius = 16
            stackView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }else{
			stackView.layer.cornerRadius = 0
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
