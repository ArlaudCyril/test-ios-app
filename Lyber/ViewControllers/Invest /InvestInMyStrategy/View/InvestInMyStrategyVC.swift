//
//  InvestInMyStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/06/22.
//

import UIKit
import IQKeyboardManagerSwift

class InvestInMyStrategyVC: ViewController {
    //MARK: - Variables
    var strategyType : InvestStrategyModel = .activateStrategy
    var enteredText : String = ""
    var isFloatTyped : Bool = false

    var fromAssetId : String?
	var fromBalance : Balance?
	var fromCurrency : AssetBaseData?
	var fromBalanceTotal : String?
	
	var toAssetId : String?
	var toAssetPrice : String?
	var toBalance : Balance?
	var toCurrency : AssetBaseData?
	
	var assetsData : Trending?, strategyCoinsData : [InvestmentStrategyAsset] = [],strategyData : Strategy?
    var totalNoOfCoinsInvest = Double() , totalCoinInvested = Double()
    var selectedFrequency = "",exchangeCoin1ToCoin2 = false
    var exchangeData : exchangeFromModel?
    var cursorPosition = 0
    var MaxCoin = Double()
    var maxEuroWithdraw = Double(), maxCoinWithdraw = Double()
    var maxCoinExchange = Double()
    
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var investInMyStrategyLbl: UILabel!
    @IBOutlet var coinsLbl: UILabel!
    @IBOutlet var amountTF: UITextField!
    @IBOutlet var noOfCoinVw: UIView!
    @IBOutlet var noOfCoinLbl: UILabel!
    @IBOutlet var maximumBtn: UIButton!
    
    @IBOutlet var creditCardVw: UIView!
    @IBOutlet var creditCardImgVw: UIView!
    @IBOutlet var creditCardImg: UIImageView!
    @IBOutlet var creditCardNumberLbl: UILabel!
    @IBOutlet var creditCardLbl: UILabel!
    @IBOutlet var maximumBtnb: UIButton!
    
    @IBOutlet var BalanceView: UIView!
    @IBOutlet var balanceLbl: UILabel!
    @IBOutlet var totalBalanceLbl: UILabel!
    @IBOutlet var frequencyVw: UIView!
    @IBOutlet var frequencyLbl: UILabel!
    @IBOutlet var frequencyImg: UIImageView!
    @IBOutlet var frequencyDropDown: UIImageView!
    //      @IBOutlet var addFrequencyBtn: PurpleButton!
    @IBOutlet var exchangeView: UIView!
    @IBOutlet var fromView: UIView!
    @IBOutlet var fromCoinImg: UIImageView!
    @IBOutlet var fromLbl: UILabel!
    @IBOutlet var fromCoinnameLbl: UILabel!
    @IBOutlet var ToView: UIView!
    @IBOutlet var ToCoinImg: UIImageView!
    @IBOutlet var ToLbl: UILabel!
    @IBOutlet var ToCoinNameLbl: UILabel!
    @IBOutlet var exchangeBtn: UIButton!
    
    @IBOutlet var key1: UIButton!
    @IBOutlet var key2: UIButton!
    @IBOutlet var key3: UIButton!
    @IBOutlet var key4: UIButton!
    @IBOutlet var key5: UIButton!
    @IBOutlet var key6: UIButton!
    @IBOutlet var key7: UIButton!
    @IBOutlet var key8: UIButton!
    @IBOutlet var key9: UIButton!
    @IBOutlet var decimalKey: UIButton!
    @IBOutlet var key0: UIButton!
    @IBOutlet var keyCancel: UIButton!
    @IBOutlet var previewMyInvest: PurpleButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		if(self.fromAssetId != nil){
			self.fromBalance = CommonFunctions.getBalance(id: self.fromAssetId ?? "")
			self.fromCurrency = CommonFunctions.getCurrency(id: self.fromAssetId ?? "")
		}
		if(self.toAssetId != nil){
			self.toBalance = CommonFunctions.getBalance(id: self.toAssetId ?? "")
			self.toCurrency = CommonFunctions.getCurrency(id: self.toAssetId ?? "")
		}
		
		if strategyType == .Exchange{
			self.exchangeData = exchangeFromModel(exchangeFromCoinId: self.fromAssetId ?? "", exchangeFromCoinImg: self.fromCurrency?.image ?? "", exchangeFromCoinBalance: fromBalance ?? Balance(), exchangeToCoinId: self.toAssetId ?? "", exchangeToCoinPrice: self.toAssetPrice ?? "", exchangeToCoinImg: self.toCurrency?.image ?? "")
			
		}
		
		self.fromBalanceTotal = String((Double(fromBalance?.balanceData.euroBalance ?? "0") ?? 0))
		
        setUpUI()
		checkInvestInStrategy()
        
        self.amountTF.becomeFirstResponder()
        self.amountTF.inputView = UIView()
        IQKeyboardManager.shared.enableAutoToolbar = false

		
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if strategyType == .withdraw{
        }
    }

	//MARK: - SetUpUI
    override func setUpUI(){
        self.strategyCoinsData = self.strategyData?.bundle ?? []
        self.maximumBtn.isHidden = true
        CommonUI.setUpLbl(lbl: self.investInMyStrategyLbl, text:"", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.creditCardVw.backgroundColor = UIColor.greyColor
        self.creditCardVw.layer.cornerRadius = 16
        let creditTapped  = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        self.creditCardVw.addGestureRecognizer(creditTapped)
        self.creditCardVw.isHidden = true
        
        self.BalanceView.backgroundColor = UIColor.greyColor
        self.BalanceView.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.balanceLbl, text: "Balance: ", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		CommonUI.setUpLbl(lbl: self.totalBalanceLbl, text: "\(fromBalanceTotal ?? "0") €", textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        amountTF.font = UIFont.AtypDisplayMedium(60.0)
        amountTF.delegate = self
		
        self.amountTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        amountTF.textColor = UIColor.PurpleColor
		
        CommonUI.setUpLbl(lbl: creditCardNumberLbl, text: "select credit card", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: creditCardLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.maximumBtn, text: "MAX", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 8, font: UIFont.MabryProMedium(Size.VSmall.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.frequencyVw, radius: 12, borderWidth: 0, borderColor: UIColor.PurpleColor.cgColor, backgroundColor: UIColor.PurpleColor)
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: CommonFunctions.localisation(key: "ADD_A_FREQUENCY"), textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: fromLbl, text: CommonFunctions.localisation(key: "FROM"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: fromCoinnameLbl, text: exchangeData?.exchangeFromCoinId.uppercased(), textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.fromCoinImg.sd_setImage(with: URL(string: fromCurrency?.image ?? ""))
        
        
        CommonUI.setUpLbl(lbl: ToLbl, text: CommonFunctions.localisation(key: "TO"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
		CommonUI.setUpLbl(lbl: ToCoinNameLbl, text: exchangeData?.exchangeToCoinId.uppercased() ?? "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
		self.ToCoinImg.sd_setImage(with: URL(string: exchangeData?.exchangeToCoinImg ?? ""))
        
        let btnKeys : [UIButton] = [key0,key1,key2,key3,key4,key5,key6,key7,key8,key9,decimalKey,keyCancel]
        for (index,key) in btnKeys.enumerated(){
            CommonUI.setUpButton(btn: key , text: "\(index)", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.whiteColor, cornerRadius: 0, font: UIFont.AtypDisplayMedium(Size.XXXLarge.sizeValue()))
            if index == 10 {
                key.setTitle(".", for: .normal)
            }else if index == 11{
                key.setTitle("", for: .normal)
            }
            key.tag = index
            key.addTarget(self, action: #selector(keyTyped), for: .touchUpInside)
        }
        
        self.enteredText = ""
        self.isFloatTyped = false
		
        self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
        self.previewMyInvest.isUserInteractionEnabled = false
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.exchangeBtn.addTarget(self, action: #selector(exchangeBtnAction), for: .touchUpInside)
        self.maximumBtn.addTarget(self, action: #selector(maximumBtnAct), for: .touchUpInside)
        self.previewMyInvest.addTarget(self, action: #selector(previewMyInvestAction), for: .touchUpInside)
        
        let tapTo = UITapGestureRecognizer(target: self, action: #selector(exchangeToTapped))
        self.ToView.addGestureRecognizer(tapTo)
		
		let tapFrom = UITapGestureRecognizer(target: self, action: #selector(exchangeFromTapped))
        self.fromView.addGestureRecognizer(tapFrom)
        
        let frequencyTap = UITapGestureRecognizer(target: self, action: #selector(frequencyBtnAction))
        self.frequencyVw.addGestureRecognizer(frequencyTap)
    }
    
    func checkInvestInStrategy(){
        if strategyType == .singleCoin{
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = true
            self.noOfCoinVw.isHidden = false
            self.maximumBtn.isHidden = false
            self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "INVEST_IN"))\(self.assetsData?.name ?? "")"
            self.noOfCoinLbl.text = "~\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(self.assetsData?.symbol?.uppercased() ?? "")"
            self.frequencyLbl.text = "\(CommonFunctions.localisation(key: "ADD_A_FREQUENCY")) (\(CommonFunctions.localisation(key: "OPTIONAL")))"
            self.maximumMoneyInvest()
			
        }else if (strategyType == .activateStrategy || strategyType == .editActiveStrategy){
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = false
            self.noOfCoinVw.isHidden = true
			self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_MY_INVESTMENT"), for: .normal)
            if(strategyData?.activeStrategy != nil)
            {//we take the informations of the active strategy
                self.selectedFrequency = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyLbl.text = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyVw.backgroundColor = UIColor.greyColor
                self.frequencyLbl.textColor = UIColor.ThirdTextColor
                self.frequencyDropDown.image = Assets.drop_down.image()
                self.frequencyImg.image = Assets.calendar_black.image()
                
                amountTF.text = "\(strategyData?.activeStrategy?.amount ?? 0)€"
                totalCoinInvested = Double(strategyData?.activeStrategy?.amount ?? 0)
                
                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
                self.previewMyInvest.isUserInteractionEnabled = true
            }
            
            var totalCoins : String = ""
            for index in 0...(strategyCoinsData.count - 1){
                if totalCoins == ""{
                    totalCoins = "\(strategyCoinsData[index].assetID ?? "")"
                }else{
                    if index >= 4{
                        totalCoins = "\(totalCoins) +\(strategyCoinsData.count-4) other assets"
                        break
                    }else{
                        totalCoins = "\(totalCoins), \(strategyCoinsData[index].assetID ?? "")"
                    }
                }
            }
            self.coinsLbl.text = totalCoins
			
        }else if strategyType == .deposit{
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = true
            self.noOfCoinVw.isHidden = true
            self.frequencyVw.isHidden = true
            self.investInMyStrategyLbl.text = CommonFunctions.localisation(key: "EURO_DESPOSIT")
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_DEPOSIT"), for: .normal)
			
        }else if strategyType == .Exchange{
            self.frequencyVw.isHidden = true
            self.maximumBtn.isHidden = false
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_EXCHANGE"), for: .normal)
			self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "EXCHANGE")) \(exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
			
			CommonUI.setUpLbl(lbl: self.coinsLbl, text: "\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(CommonFunctions.localisation(key: "AVAILABLE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
			CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "~0.0 \(self.ToCoinNameLbl.text ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
			self.amountTF.placeholder = "0 \(self.exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
            self.fromView.layer.cornerRadius = 16
            self.ToView.layer.cornerRadius = 16
            self.exchangeBtn.layer.cornerRadius = 8
			
			maxCoinExchange = Double(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") ?? 0
        }else if strategyType == .withdraw{
            self.creditCardVw.isHidden = false
            self.exchangeView.isHidden = true
            self.frequencyVw.isHidden = true
            self.maximumBtn.isHidden = false
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
			self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "WITHDRAW")) \(fromAssetId?.uppercased() ?? "")"
			CommonUI.setUpLbl(lbl: self.coinsLbl, text: "\(fromBalance?.balanceData.balance ?? "0") \(CommonFunctions.localisation(key: "AVAILABLE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
			
            self.noOfCoinLbl.text = ""
            self.maxMoneyWithdraw()
        } else if strategyType == .withdrawEuro{
            self.exchangeView.isHidden = true
            self.frequencyVw.isHidden = true
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
            self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "WITHDRAW")) Euro"
            self.coinsLbl.isHidden = true
            self.noOfCoinLbl.isHidden = true
        }else if strategyType == .anotherWallet{
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = true
            self.noOfCoinVw.isHidden = true
            self.frequencyVw.isHidden = true
            self.exchangeView.isHidden = true
            self.amountTF.placeholder = "0"
        }else if strategyType == .sell{
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = true
            self.noOfCoinLbl.isHidden = false
//            self.noOfCoinVw.isHidden = true
            self.frequencyVw.isHidden = true
            self.creditCardVw.isHidden = true
            self.maximumBtn.isHidden = false
            self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "SELL")) \(self.assetsData?.name ?? "")"
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "SELL"), for: .normal)
            self.noOfCoinLbl.text = "0.0 \(self.assetsData?.symbol?.uppercased() ?? "")"
            
        }
    }
}

//MARK: - objective functions
extension InvestInMyStrategyVC {
    @objc func cancelBtnAct(){
        if strategyType == .Exchange || strategyType == .withdraw || strategyType == .singleCoin || strategyType == .activateStrategy || strategyType == .editActiveStrategy || strategyType == .sell || strategyType == .withdrawEuro{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func previewMyInvestAction(){
        if strategyType == .Exchange{
            goToConfirmInvestment()
        }else if strategyType == .withdraw {
            if totalCoinInvested > maxEuroWithdraw{
                CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_COINS_WITHDRAW"))
            }else{
                let vc = EnterWalletAddressVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                vc.assetData = self.assetsData
                vc.totalEuroInvested = totalCoinInvested
                vc.noOfCoinsinvested = totalNoOfCoinsInvest
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if strategyType == .singleCoin{
            self.goToConfirmInvestment()
        }else if strategyType == .sell{
            SellCoinApi()
        }else if strategyType == .withdrawEuro{
            self.previewMyInvest.showLoading()
            EnterWalletAddressVM().withdrawFiatApi(amount: totalCoinInvested, completion: {[weak self]response in
                self?.previewMyInvest.hideLoading()
                if let response = response{
                    print(response)
                    let vc = ConfirmationVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                    vc.confirmationType = .Withdraw
                    self?.present(vc, animated: true, completion: nil)
                }
            })
        }else{
            if self.frequencyVw.isHidden == false{
                if selectedFrequency == ""{
                    CommonFunctions.toster(CommonFunctions.localisation(key: "ALERT_FREQUENCY"))
                }else{
                    self.goToConfirmInvestment()
                }
            }else{
                self.goToConfirmInvestment()
            }
        }
    }
    
    @objc func selectCard(){
        CommonFunctions.showLoader(self.view)
        CryptoAddressBookVM().getWhiteListingAddressApi(searchText: "", completion: {[weak self]response in
            if let response = response{
                CommonFunctions.hideLoader(self?.view ?? UIView())
                let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                if self?.strategyType == .withdraw{
                    vc.popupType = .withdrawTo
                    vc.investStrategyController = self
                    vc.assetsData = self?.assetsData
                    vc.connectedAccountAddress = response.addresses ?? []
                }else{
                    vc.popupType = .PayWith
                }
                vc.accountSelectedCallback = {[weak self] accountSelected in
                    self?.creditCardLbl.text = accountSelected.subName
                    self?.creditCardNumberLbl.text = accountSelected.name
                    if accountSelected.svgUrl == ""{
                        self?.creditCardImg.image = accountSelected.icon
                    }else{
                        self?.creditCardImg.yy_setImage(with: URL(string: accountSelected.svgUrl ?? ""), options: .progressiveBlur)
                    }
                }
                self?.present(vc, animated: true, completion: nil)
            }
        })
        
    }
    
    @objc func frequencyBtnAction(){
        let vc = FrequencyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.frequencySelectedCallback = {[weak self] value in
            self?.selectedFrequency = value
            self?.frequencyLbl.text = value
            self?.frequencyVw.backgroundColor = UIColor.greyColor
            self?.frequencyLbl.textColor = UIColor.ThirdTextColor
            self?.frequencyDropDown.image = Assets.drop_down.image()
            self?.frequencyImg.image = Assets.calendar_black.image()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func exchangeToTapped(){
        let vc = AllAssetsVC.instantiateFromAppStoryboard(appStoryboard: .Portfolio)
        vc.screenType = .exchange
		vc.fromAssetId = self.exchangeData?.exchangeFromCoinId ?? ""
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
        
    }
	
	@objc func exchangeFromTapped(){
		let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        vc.screenType = .exchange
		vc.toAssetId = self.exchangeData?.exchangeToCoinId
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func keyTyped(sender : UIButton){
        switch sender.tag{
        case 1,2,3,4,5,6,7,8,9,0:
            print("typed ",sender.tag)
            if enteredText.count == 0{
                if sender.tag == 0{
                    //                    enteredText = "\(sender.tag)"
                }else{
                        enteredText = "\(enteredText)\(sender.tag)"
                        noOfCoins(value: enteredText)
                }
            }else{
                if enteredText.count >= 10{
                    
                }else{
                    enteredText = "\(enteredText)\(sender.tag)"
                    noOfCoins(value: enteredText)
                }
                
            }
            if enteredText != ""{
                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
                self.previewMyInvest.isUserInteractionEnabled = true
            }
            break
        case 10:
            if isFloatTyped == false{
                if enteredText.count == 0{
                    print("typed ",sender.tag)
                    enteredText = "0."
                }else{
                    print("typed ",sender.tag)
                    enteredText = "\(enteredText)."
                }
                //                print("typed ",sender.tag)
                //                enteredText = "\(enteredText)."
                amountTF.text = "\(enteredText)€"
                isFloatTyped = true
            }
            break
        case 11:
            if enteredText != ""{
                if enteredText.count == 1{
                    enteredText.removeLast()
                    noOfCoins(value: enteredText)
                    amountTF.text?.removeAll()
                    isFloatTyped = false
                    self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
                    self.previewMyInvest.isUserInteractionEnabled = false
                }else{
                    let lastRemove = enteredText.removeLast()
                    noOfCoins(value: enteredText)
                    if lastRemove == "."{
                        isFloatTyped = false
                    }
                }
            }
            break
        default:
            break
        }
        
    }
    
    
    @objc func exchangeBtnAction(){
		if(toBalance?.id != ""){
			self.enteredText = ""
			exchangeCoin1ToCoin2 = !exchangeCoin1ToCoin2
			
			if exchangeCoin1ToCoin2 == false{
				exchangeData?.exchangeFromCoinId = fromAssetId ?? ""
				exchangeData?.exchangeFromCoinImg = fromCurrency?.image ?? ""
				exchangeData?.exchangeFromCoinBalance = fromBalance ?? Balance()
				exchangeData?.exchangeToCoinId = toAssetId ?? ""
				exchangeData?.exchangeToCoinImg = toCurrency?.image ?? ""
				exchangeData?.exchangeToCoinPrice = toAssetPrice ?? ""
				
			}else{
				exchangeData?.exchangeFromCoinId = toAssetId ?? ""
				exchangeData?.exchangeFromCoinImg = toCurrency?.image ?? ""
				exchangeData?.exchangeFromCoinBalance = toBalance ?? Balance()
				exchangeData?.exchangeToCoinId = fromAssetId ?? ""
				exchangeData?.exchangeToCoinImg = fromCurrency?.image ?? ""
				exchangeData?.exchangeToCoinPrice = String((Double(fromBalance?.balanceData.euroBalance ?? "0") ?? 0)/(Double(fromBalance?.balanceData.balance ?? "0") ?? 0))
			}
			self.maxCoinExchange = Double(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") ?? 0
			self.fromBalanceTotal = String((Double(exchangeData?.exchangeFromCoinBalance.balanceData.euroBalance ?? "0") ?? 0))
			
			self.investInMyStrategyLbl.text =  "\(CommonFunctions.localisation(key: "INVEST_IN"))\(exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
			
			fromCoinnameLbl.text = exchangeData?.exchangeFromCoinId.uppercased()
			self.fromCoinImg.sd_setImage(with: URL(string: exchangeData?.exchangeFromCoinImg ?? ""))
			
			ToCoinNameLbl.text = exchangeData?.exchangeToCoinId.uppercased()
			self.ToCoinImg.sd_setImage(with: URL(string: exchangeData?.exchangeToCoinImg ?? ""))
			
			self.coinsLbl.text = "\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(CommonFunctions.localisation(key: "AVAILABLE"))"
			
			self.totalBalanceLbl.text = "\(self.fromBalanceTotal ?? "0") €"
			
			
			let noOfCoinText = self.noOfCoinLbl.text
			if(amountTF.text == "" || Int(noOfCoinText?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") == 0){
				self.noOfCoinLbl.text = "~ 0 \(exchangeData?.exchangeToCoinId.uppercased() ?? "")"
			}else{
				self.noOfCoinLbl.text = "~\(amountTF.text ?? "")"
			}
			let amountText = noOfCoinText?.dropFirst(1)
			amountTF.text = amountText.map { String($0) }

		}else{
			CommonFunctions.toster(CommonFunctions.localisation(key: "CANT_EXCHANGE_ASSET_DONT_HAVE"))
		}
    }
    
    @objc func maximumBtnAct(){
        if strategyType == .singleCoin{
            if exchangeCoin1ToCoin2 {
                enteredText = "\(MaxCoin)"
                noOfCoins(value: enteredText)
            }else{
                enteredText = "\(CommonFunctions.getTwoDecimalValue(number: totalEuroAvailable ?? (assetsData?.total_balance ?? 0)))"
                noOfCoins(value: enteredText)
            }
        }else if strategyType == .withdraw{
			enteredText = self.fromBalanceTotal ?? "0"
			noOfCoins(value: enteredText)
            
        }else if strategyType == .Exchange{
            enteredText = exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0"
            noOfCoins(value: enteredText)
        }
        
        if enteredText.contains("."){
            self.isFloatTyped = true
        }
        self.previewMyInvest.backgroundColor = UIColor.PurpleColor
        self.previewMyInvest.isUserInteractionEnabled = true
    }
    
    
    func getAddedWalletAddress(){
        CommonFunctions.showLoader(self.view)
        CryptoAddressBookVM().getWhiteListingAddressApi(searchText: "", completion: {[weak self]response in
            if let response = response{
                CommonFunctions.hideLoader(self?.view ?? UIView())
                if (response.count ?? 0) > 0{
                    self?.creditCardLbl.text = response.addresses?[0].address ?? ""
                    self?.creditCardNumberLbl.text = response.addresses?[0].name ?? ""
//                    self?.creditCardImg.setSvgImage(from: URL(string: response.addresses?[0].logo ?? ""))
                    self?.creditCardImg.yy_setImage(with: URL(string: response.addresses?[0].logo ?? ""), options: .progressiveBlur)
                }
            }
        })
    }
    
   func  SellCoinApi(){
       self.previewMyInvest.showLoading()
       self.previewMyInvest.isUserInteractionEnabled = false
       ConfirmInvestmentVM().SellApi(assetId: self.assetsData?.symbol?.uppercased() ?? "", amount: self.totalCoinInvested, assetAmount: self.totalNoOfCoinsInvest, completion: {[weak self]response in
           self?.previewMyInvest.hideLoading()
           self?.previewMyInvest.isUserInteractionEnabled = true
           if let _ = response{
               let vc = BuySellPopUpVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
               vc.popUpType = .Sell
               vc.assetData = self?.assetsData
               vc.coinInvest = "\(CommonFunctions.formattedCurrency(from: self?.totalCoinInvested))"
               self?.present(vc, animated: true, completion: nil)
           }
       })
    }
}

//MARK: - Other functions
extension InvestInMyStrategyVC {
    
    func noOfCoins(value: String){
        if strategyType == .Exchange{
			let coinFromPrice = (Double( exchangeData?.exchangeFromCoinBalance.balanceData.euroBalance ?? "0") ?? 0)/(Double( exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") ?? 0)
			let totalEuro = ((Double(value) ?? 0.0)*(coinFromPrice))
			
			amountTF.text = "\(value) \(self.exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
			
			totalCoinInvested = Double(value) ?? 0.0
			
			
			let coinToPrice = Double(exchangeData?.exchangeToCoinPrice ?? "0") ?? 0
			totalNoOfCoinsInvest = CommonFunctions.getTwoDecimalValue(number: (totalEuro/coinToPrice))
			
			self.noOfCoinLbl.text = "~\(String(CommonFunctions.getTwoDecimalValue(number:(totalCoinInvested * coinFromPrice)/coinToPrice))) \(self.exchangeData?.exchangeToCoinId.uppercased() ?? "")"
            
        }else{
            if exchangeCoin1ToCoin2 == false{
                    amountTF.text = "\(CommonFunctions.numberFormat(from: Double(value)))€"
				let coinPrice = CommonFunctions.getTwoDecimalValue(number: (Double(fromBalance?.balanceData.euroBalance ?? "") ?? 0.0) / (Double(fromBalance?.balanceData.balance ?? "") ?? 0.0))
                    totalCoinInvested = Double(value) ?? 0.0
                    totalNoOfCoinsInvest = CommonFunctions.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(1/coinPrice)))
                    
				self.noOfCoinLbl.text = "~\(CommonFunctions.getTwoDecimalValue(number: totalNoOfCoinsInvest)) \(self.fromAssetId?.uppercased() ?? "")"
            }else{
                amountTF.text = "\(CommonFunctions.numberFormat(from: Double(value))) \(self.assetsData?.symbol?.uppercased() ?? (self.exchangeData?.exchangeFromCoinId ?? ""))"
                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
                totalCoinInvested = CommonFunctions.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(coinPrice)))
                
                totalNoOfCoinsInvest = Double(value) ?? 0.0
                self.noOfCoinLbl.text = "~\(totalCoinInvested)€"
            }
        }
    }
    
    func goToConfirmInvestment(){
        if strategyType == .singleCoin || strategyType == .activateStrategy || strategyType == .editActiveStrategy{
            if totalCoinInvested > (totalEuroAvailable ?? 0){
				CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_BALANCE"))
            }else{
                self.goToPreviewINvest()
            }
        }else if strategyType == .Exchange{
            if totalCoinInvested > maxCoinExchange {
                CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_COINS"))
            }else{
                self.goToPreviewINvest()
            }
        }
       
    }
    
    
    func goToPreviewINvest(){
		let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
		if(strategyType == .Exchange){
			self.previewMyInvest.showLoading()
				
			InvestInMyStrategyVM().ordersGetQuoteApi(fromAssetId: self.exchangeData?.exchangeFromCoinId ?? "", toAssetId: self.exchangeData?.exchangeToCoinId ?? "", exchangeFromAmount: self.totalCoinInvested, completion: {response in
				if( response != nil){
					self.previewMyInvest.hideLoading()
					vc.InvestmentType = .Exchange
					vc.exchangeFrom = response?.data.fromAsset ?? ""
					vc.exchangeTo = response?.data.toAsset ?? ""
					vc.amountFrom = response?.data.fromAmount ?? ""
					vc.amountTo = response?.data.toAmount ?? ""
					vc.timeLimit = response?.data.validTimestamp ?? 0
					vc.ratioCoin = response?.data.ratio ?? "0"
					vc.orderId = response?.data.orderId ?? ""
					self.navigationController?.pushViewController(vc, animated: true)
				}
			})
			
		}else{
			vc.assetData = assetsData
			vc.totalCoinsInvested = totalCoinInvested//totalNoOfCoinsInvest
			vc.totalEuroInvested = totalCoinInvested
			vc.frequency = self.selectedFrequency
			vc.strategyData = self.strategyData
			if strategyType == .singleCoin{
				vc.InvestmentType = .singleCoin
			}else if strategyType == .activateStrategy{
				vc.InvestmentType = .activateStrategy
			}else if strategyType == .editActiveStrategy{
				vc.InvestmentType = .editActiveStrategy
			}else if strategyType == .deposit{
				vc.InvestmentType = .deposit
			}
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
       
    }
    
    func maximumMoneyInvest(){
        let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
        print(CommonFunctions.getTwoDecimalValue(number: ((totalEuroAvailable ?? 0)*(1/coinPrice))))
        MaxCoin = CommonFunctions.getTwoDecimalValue(number: ((totalEuroAvailable ?? 0)*(1/coinPrice)))
    }
    
    func maxMoneyWithdraw(){
		if exchangeData?.exchangeFromCoinBalance.balanceData.balance == "0" || exchangeData?.exchangeFromCoinBalance.balanceData.balance == nil{
            maxEuroWithdraw = (CommonFunctions.getTwoDecimalValue(number: ((assetsData?.total_balance ?? 0)*(assetsData?.currentPrice ?? 0))))
        }else{
			maxEuroWithdraw = Double(exchangeData?.exchangeFromCoinBalance.balanceData.euroBalance ?? "0") ?? 0
        }
        let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
        maxCoinWithdraw = CommonFunctions.getTwoDecimalValue(number: ((maxEuroWithdraw)*(1/coinPrice)))
        
    }
}


extension InvestInMyStrategyVC : UITextFieldDelegate{
    @objc func editChange(_:UITextField){
        print(amountTF.text)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        self.view.endEditing(true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
//        let startPosition: UITextPosition = amountTF.beginningOfDocument
//        let endPosition: UITextPosition = amountTF.endOfDocument
        let selectedRange: UITextRange? = amountTF.selectedTextRange
        if let selectedRange = amountTF.selectedTextRange {
            cursorPosition = amountTF.offset(from: amountTF.beginningOfDocument, to: selectedRange.start)
            print("cursor position -----\(cursorPosition)")
        }
    }
    
}
