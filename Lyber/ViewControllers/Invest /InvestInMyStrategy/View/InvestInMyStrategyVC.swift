//
//  InvestInMyStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/06/22.
//

import UIKit
import IQKeyboardManagerSwift
import StripeApplePay

class InvestInMyStrategyVC: ViewController {
    //MARK: - Variables
    var strategyType : InvestStrategyModel = .activateStrategy
    var enteredText : String = ""
    var isFloatTyped : Bool = false

    //withdraw
    var network : NetworkAsset?
    var withdrawToAccountData : [buyDepositeModel] = []
    var addressSelected = false
    var exchangeCoinToEuro = false
    var minimumWithdrawal : Double?
    var feeWithdrawal : Double = 0
    var coinWithdrawPrice : Decimal = 0.0
    var maxAmountWithdraw : Decimal = 0.0
    
    //withdraw euro
    var indexRibSelected : Int?
    var ribSelected : RibData?
    var bic : String?
    
    //exchange and withdraw
    var fromAssetId : String?
    var fromBalance : Balance?
    
    //exchange
    var fromCurrency : AssetBaseData?
    var fromBalanceTotal : String?
    var fromAssetPrice : String?
    
    var toAssetId : String?
    var toAssetPrice : String?
    var toBalance : Balance?
    var toCurrency : AssetBaseData?
    
    var assetsData : Trending?, strategyCoinsData : [InvestmentStrategyAsset] = [],strategyData : Strategy?
    var totalNoOfCoinsInvest = NSDecimalNumber() , totalEuroInvested = NSDecimalNumber()
    var selectedFrequency = "",exchangeCoin1ToCoin2 = false
    var exchangeData : exchangeFromModel?
    var cursorPosition = 0
    var MaxCoin = Double()
    var maxCoinExchange = NSDecimalNumber()
    var minPriceExchange = 1.05
    var minAmountExchange : Double?
    //singleCoin || activateStrategy || editActiveStrategy || oneTimeInvestment
    var minInvestPerAsset : Decimal = 10
    var asset : PriceServiceResume?
    var maxAmountBuy : Decimal = 1000
    
    var numberOfDecimals = -1
    
    //send
    var sendMean = ""
    var phone = ""
    
    //MARK: - IB OUTLETS
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var investInMyStrategyLbl: UILabel!
    @IBOutlet var coinsLbl: UILabel!
    @IBOutlet var stackViewPrices: UIStackView!
    @IBOutlet var bottomPrices: UIView!
    @IBOutlet var amountTF: UITextField!
    @IBOutlet var noOfCoinVw: UIView!
    @IBOutlet var noOfCoinLbl: UILabel!
    @IBOutlet var maximumBtn: UIButton!
    //withdraw
    @IBOutlet var switchPriceAssetBtn: UIButton!
    @IBOutlet var feesLbl: UILabel!
    
    @IBOutlet var minimumWithdrawVw: UIView!
    @IBOutlet var minimumWithdrawLbl: UILabel!
    
    @IBOutlet var addressVw: UIView!
    @IBOutlet var addressImg: UIImageView!
    @IBOutlet var addressNameLbl: UILabel!
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var creditCardVw: UIView!
    @IBOutlet var creditCardImg: UIImageView!
    @IBOutlet var creditCardNumberLbl: UILabel!
    @IBOutlet var creditCardLbl: UILabel!
    
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
    @IBOutlet var exchangeAlertLbl: UILabel!
    
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
            self.exchangeData = exchangeFromModel(exchangeFromCoinId: self.fromAssetId ?? "", exchangeFromCoinImg: self.fromCurrency?.imageUrl ?? "", exchangeFromCoinPrice: Double(self.fromAssetPrice ?? "") ?? 0, exchangeFromCoinBalance: fromBalance ?? Balance(), exchangeToCoinId: self.toAssetId ?? "", exchangeToCoinPrice: Double(self.toAssetPrice ?? "") ?? 0, exchangeToCoinImg: self.toCurrency?.imageUrl ?? "")
            
            self.minAmountExchange = self.minPriceExchange / (exchangeData?.exchangeFromCoinPrice ?? 1)
            
            CommonUI.setUpLbl(lbl: self.exchangeAlertLbl, text: "\(CommonFunctions.localisation(key: "MINIMUM_AMOUNT_EXCHANGE")) \(CommonFunctions.formattedAssetBinance(value: self.minAmountExchange?.description ?? "", numberOfDecimals: CommonFunctions.getDecimal(id: self.exchangeData?.exchangeFromCoinId ?? ""))) \(exchangeData?.exchangeFromCoinId.uppercased() ?? "")", textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Small.sizeValue()))
            
                self.exchangeAlertLbl.isHidden = false
            
        }else{
            self.exchangeAlertLbl.isHidden = true
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
            getAddresses()
        }else if strategyType == .withdrawEuro{
            getRibs()
        }
    }

    //MARK: - SetUpUI
    override func setUpUI(){
        self.strategyCoinsData = self.strategyData?.bundle ?? []
        self.maximumBtn.isHidden = true
        CommonUI.setUpLbl(lbl: self.investInMyStrategyLbl, text:"", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        // address
        self.addressVw.layer.cornerRadius = 12
        self.addressVw.backgroundColor = UIColor.greyColor
        let addressTapped = UITapGestureRecognizer(target: self, action: #selector(selectAddress))
        self.addressVw.addGestureRecognizer(addressTapped)
        self.addressVw.isHidden = true
        
        
        // credit card
        self.creditCardVw.backgroundColor = UIColor.greyColor
        self.creditCardVw.layer.cornerRadius = 16
        let creditTapped  = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        self.creditCardVw.addGestureRecognizer(creditTapped)
        self.creditCardVw.isHidden = true
        
        //exchange
        self.exchangeView.isHidden = true
        
        self.coinsLbl.isHidden = true
        self.noOfCoinVw.isHidden = true
        self.frequencyVw.isHidden = true
        self.switchPriceAssetBtn.isHidden = true
        self.feesLbl.isHidden = true
        self.minimumWithdrawVw.isHidden = true
        
        CommonUI.setUpLbl(lbl: self.coinsLbl, text: "\(CommonFunctions.getTwoDecimalValue(number: totalEuroAvailable ?? 0)) USDC \(CommonFunctions.localisation(key: "AVAILABLE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        
        CommonUI.setUpLbl(lbl: creditCardNumberLbl, text: CommonFunctions.localisation(key: "SELECT_CREDIT_CARD"), textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: creditCardLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        
        self.BalanceView.backgroundColor = UIColor.greyColor
        self.BalanceView.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.balanceLbl, text: "\(CommonFunctions.localisation(key: "BALANCE")): ", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalBalanceLbl, text: "\(fromBalanceTotal ?? "0") €", textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
        self.BalanceView.isHidden = true
        amountTF.text = "0€"
        amountTF.font = UIFont.AtypDisplayMedium(60.0)
        amountTF.textColor = UIColor.PurpleColor
        
        
        CommonUI.setUpButton(btn: self.maximumBtn, text: "MAX", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 8, font: UIFont.MabryProMedium(Size.VSmall.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.frequencyVw, radius: 12, borderWidth: 0, borderColor: UIColor.PurpleColor.cgColor, backgroundColor: UIColor.PurpleColor)
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: CommonFunctions.localisation(key: "ADD_A_FREQUENCY"), textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: fromLbl, text: CommonFunctions.localisation(key: "FROM"), textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: fromCoinnameLbl, text: exchangeData?.exchangeFromCoinId.uppercased(), textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.fromCoinImg.sd_setImage(with: URL(string: fromCurrency?.imageUrl ?? ""))
        
        
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
        self.switchPriceAssetBtn.addTarget(self, action: #selector(switchPriceAssetBtnAction), for: .touchUpInside)
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
        if strategyType == .singleCoin || strategyType == .singleCoinWithFrequence || strategyType == .Send{
            if(strategyType == .singleCoinWithFrequence){
                self.frequencyVw.isHidden = false
                self.frequencyLbl.text = "\(CommonFunctions.localisation(key: "ONCE"))"
                self.selectedFrequency = "\(CommonFunctions.localisation(key: "ONCE"))"
                self.frequencyVw.backgroundColor = UIColor.greyColor
                self.frequencyLbl.textColor = UIColor.ThirdTextColor
                self.frequencyDropDown.image = Assets.drop_down.image()
                self.frequencyImg.image = Assets.calendar_black.image()
            }else{
                self.frequencyVw.isHidden = true
            }
            self.noOfCoinVw.isHidden = false
            self.switchPriceAssetBtn.isHidden = false
            self.noOfCoinLbl.text = "~\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(self.asset?.id.uppercased() ?? "")"
            
            if(strategyType != .Send){
                self.maximumBtn.isHidden = true
                self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "BUY")) \(self.asset?.id.uppercased() ?? "")"
                self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_MY_PURCHASE"), for: .normal)
            }else{
                self.maximumBtn.isHidden = false
                self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "SEND")) \(self.asset?.id.uppercased() ?? "")"
                self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
            }
            
            PortfolioDetailVM().getCoinInfoApi(AssetId: asset?.id ?? "eur", isNetwork: false, completion: {
                response in
                if response != nil{
                    self.numberOfDecimals = response?.data?.decimals ?? 2
                }
            })
        }else if (strategyType == .activateStrategy || strategyType == .editActiveStrategy || strategyType == .oneTimeInvestment){
            
            if(strategyType == .oneTimeInvestment){
                self.maximumBtn.isHidden = false
                self.noOfCoinVw.isHidden = false
                self.frequencyVw.isHidden = true
                
                CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "~0.0 €", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            }else{
                self.frequencyVw.isHidden = false
            }
            
            self.creditCardVw.isHidden = true //it is temporary
            self.coinsLbl.isHidden = false
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_MY_INVESTMENT"), for: .normal)
            if(strategyData?.activeStrategy != nil)
            {//we take the informations of the active strategy
                self.selectedFrequency = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyLbl.text = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyVw.backgroundColor = UIColor.greyColor
                self.frequencyLbl.textColor = UIColor.ThirdTextColor
                self.frequencyDropDown.image = Assets.drop_down.image()
                self.frequencyImg.image = Assets.calendar_black.image()
                
                amountTF.text = "\(self.strategyData?.minAmount ?? 0) USDC"
                totalNoOfCoinsInvest = NSDecimalNumber(integerLiteral: self.strategyData?.minAmount ?? 0)
                
                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
                self.previewMyInvest.isUserInteractionEnabled = true
            }else{
                amountTF.text = "0 USDC"
            }
        }else if strategyType == .deposit{
            self.investInMyStrategyLbl.text = CommonFunctions.localisation(key: "EURO_DESPOSIT")
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_DEPOSIT"), for: .normal)
            
        }else if strategyType == .Exchange{
            self.noOfCoinVw.isHidden = false
            self.exchangeView.isHidden = false
            self.maximumBtn.isHidden = false
            self.coinsLbl.isHidden = false
            self.feesLbl.isHidden = false
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "PREVIEW_EXCHANGE"), for: .normal)
            self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "EXCHANGE")) \(exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
            
            
            CommonUI.setUpLbl(lbl: self.coinsLbl, text: "\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(CommonFunctions.localisation(key: "AVAILABLE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
            CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "~0.0 \(self.ToCoinNameLbl.text ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: self.feesLbl, text: "~0.00 €", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
            self.amountTF.text = "0 \(self.exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
            self.fromView.layer.cornerRadius = 16
            self.ToView.layer.cornerRadius = 16
            self.exchangeBtn.layer.cornerRadius = 8
            
            maxCoinExchange = NSDecimalNumber(string: exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0")
            
            PortfolioDetailVM().getCoinInfoApi(AssetId: self.fromAssetId ?? "", isNetwork: false, completion: {
                response in
                if response != nil{
                    self.numberOfDecimals = response?.data?.decimals ?? 2
                }
            })
                    
        }else if strategyType == .withdraw || strategyType == .withdrawEuro{
            self.noOfCoinVw.isHidden = false
            self.addressVw.isHidden = false
            self.maximumBtn.isHidden = false
            self.switchPriceAssetBtn.isHidden = false
            self.feesLbl.isHidden = false
            self.coinsLbl.isHidden = false
            self.minimumWithdrawVw.isHidden = false
            
            
            self.coinWithdrawPrice =  Decimal((Double(fromBalance?.balanceData.euroBalance ?? "") ?? 0.0) / (Double(fromBalance?.balanceData.balance ?? "") ?? 0.0))
            self.maxAmountWithdraw = Decimal((Double(self.toBalance?.balanceData.balance ?? "") ?? 0.0))
            
            
            self.previewMyInvest.setTitle(CommonFunctions.localisation(key: "NEXT"), for: .normal)
            self.investInMyStrategyLbl.text = "\(CommonFunctions.localisation(key: "WITHDRAW")) \(toAssetId?.uppercased() ?? "")"
            
            CommonUI.setUpLbl(lbl: self.minimumWithdrawLbl, text: "\(CommonFunctions.localisation(key: "MINIMUM_WITHDRAWAL")) : \(self.minimumWithdrawal ?? 0.0) \(self.toAssetId?.symboleTranslation.uppercased() ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
            CommonUI.setUpLbl(lbl: self.coinsLbl, text: "\(CommonFunctions.formattedAssetBinance(value: toBalance?.balanceData.balance ?? "", numberOfDecimals: self.numberOfDecimals)) \(CommonFunctions.localisation(key: "AVAILABLE"))", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
            CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "0.0 \(self.fromAssetId?.symboleTranslation.uppercased() ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: self.feesLbl, text: "\(CommonFunctions.localisation(key: "FEES")) : \(CommonFunctions.formattedAssetBinance(value: self.feeWithdrawal.description, numberOfDecimals: self.numberOfDecimals))  \(toAssetId?.symboleTranslation.uppercased() ?? "")", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            
            self.switchPriceAssetBtn.layer.cornerRadius = 8
            
        }else if strategyType == .anotherWallet{
            self.amountTF.placeholder = "0"
        }else if strategyType == .sell{
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func previewMyInvestAction(){
        if strategyType == .Exchange || strategyType == .withdraw || strategyType == .withdrawEuro || strategyType == .singleCoin || strategyType == .singleCoinWithFrequence || strategyType == .Send{
            goToConfirmInvestment()
        }else if strategyType == .sell{
            SellCoinApi()
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
        CryptoAddressBookVM().getWithdrawalAdressAPI(completion: {[weak self]response in
            if response != nil{
                CommonFunctions.hideLoader(self?.view ?? UIView())
                let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                vc.popupType = .PayWith
                vc.accountSelectedCallback = {[weak self] accountSelected, row in
                    
                    self?.creditCardLbl.text = accountSelected.subName
                    self?.creditCardNumberLbl.text = accountSelected.name
                    if accountSelected.svgUrl == ""{
                        self?.creditCardImg.image = accountSelected.icon
                    }else{
                        self?.creditCardImg.sd_setImage(with: URL(string: accountSelected.svgUrl ?? ""))
                    }
                }
                self?.present(vc, animated: true, completion: nil)
            }
        })
        
    }
    
    @objc func selectAddress(){
        let vc = DepositeOrBuyVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        if(self.strategyType == .withdraw){
            vc.popupType = .withdrawTo
        }else if(self.strategyType == .withdrawEuro){
            vc.popupType = .withdrawToEuro
            self.indexRibSelected = nil
        }
        
        vc.investStrategyController = self
        vc.network = self.network?.id
        vc.withdrawToAccountData = self.withdrawToAccountData
        vc.accountSelectedCallback = {[weak self] accountSelected, row in
            if(self?.strategyType == .withdrawEuro){
                self?.indexRibSelected = row
                self?.ribSelected = accountSelected.ribData
            }
            self?.addressLbl.text = accountSelected.subName
            self?.addressNameLbl.text = accountSelected.name
            if accountSelected.svgUrl == ""{
                self?.addressImg.image = accountSelected.icon
            }else{
                self?.addressImg.sd_setImage(with: URL(string: accountSelected.svgUrl ?? ""))
            }
        }
        self.present(vc, animated: true, completion: nil)
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
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func exchangeFromTapped(){
        let vc = ExchangeFromVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
        vc.screenType = .exchange
        vc.toAssetId = self.exchangeData?.exchangeToCoinId
        vc.toAssetPrice = self.exchangeData?.exchangeToCoinPrice.description
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyTyped(sender : UIButton){
        switch sender.tag{
        case 0: // "0" key
            if enteredText == "0" {
                break // Do nothing if the current text is already "0"
            }
            enteredText += "0" // Append "0" to the current text
            updateValues(value: enteredText)
        case 1, 2, 3, 4, 5, 6, 7, 8, 9: // Numbers 1 to 9
            if enteredText == "0" {
                enteredText = "\(sender.tag)" // Replace "0" with the tapped digit
            } else {
                enteredText += "\(sender.tag)" // Append the tapped digit
            }
            updateValues(value: enteredText)
        case 10:
            if isFloatTyped == false{
                if enteredText.count != 0{
                    print("typed ",sender.tag)
                    enteredText = "\(enteredText)."
                    updateValues(value: enteredText)
                    isFloatTyped = true
                }
            }
            break
        case 11:
            if enteredText != ""{
                if enteredText.count == 1{
                    enteredText = "0"
                    updateValues(value: enteredText)
                    isFloatTyped = false
                    self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
                    self.previewMyInvest.isUserInteractionEnabled = false
                }else{
                    let lastRemove = enteredText.removeLast()
                    updateValues(value: enteredText)
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
        if(toBalance != nil){
            self.enteredText = ""
            exchangeCoin1ToCoin2 = !exchangeCoin1ToCoin2
            
            if exchangeCoin1ToCoin2 == false{
                exchangeData?.exchangeFromCoinId = fromAssetId ?? ""
                exchangeData?.exchangeFromCoinImg = fromCurrency?.imageUrl ?? ""
                exchangeData?.exchangeFromCoinBalance = fromBalance ?? Balance()
                exchangeData?.exchangeFromCoinPrice = Double(self.fromAssetPrice ?? "0") ?? 0
                exchangeData?.exchangeToCoinId = toAssetId ?? ""
                exchangeData?.exchangeToCoinImg = toCurrency?.imageUrl ?? ""
                exchangeData?.exchangeToCoinPrice = Double(toAssetPrice ?? "0") ?? 0
                
            }else{
                exchangeData?.exchangeFromCoinId = toAssetId ?? ""
                exchangeData?.exchangeFromCoinImg = toCurrency?.imageUrl ?? ""
                exchangeData?.exchangeFromCoinBalance = toBalance ?? Balance()
                exchangeData?.exchangeFromCoinPrice = Double(toAssetPrice ?? "0") ?? 0
                exchangeData?.exchangeToCoinId = fromAssetId ?? ""
                exchangeData?.exchangeToCoinImg = fromCurrency?.imageUrl ?? ""
                exchangeData?.exchangeToCoinPrice = Double(self.fromAssetPrice ?? "0") ?? 0
            }
            self.minAmountExchange = self.minPriceExchange / (exchangeData?.exchangeFromCoinPrice ?? 1)
            
            CommonUI.setUpLbl(lbl: self.exchangeAlertLbl, text: "\(CommonFunctions.localisation(key: "MINIMUM_AMOUNT_EXCHANGE")) \(CommonFunctions.formattedAssetBinance(value: self.minAmountExchange?.description ?? "", numberOfDecimals: CommonFunctions.getDecimal(id: exchangeData?.exchangeFromCoinId ?? ""))) \(exchangeData?.exchangeFromCoinId.uppercased() ?? "")", textColor: UIColor.Red_500, font: UIFont.MabryPro(Size.Small.sizeValue()))
            
            self.maxCoinExchange = NSDecimalNumber(string: exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0")
            self.fromBalanceTotal = String((Double(exchangeData?.exchangeFromCoinBalance.balanceData.euroBalance ?? "0") ?? 0))
            
            self.investInMyStrategyLbl.text =  "\(CommonFunctions.localisation(key: "INVEST_IN"))\(exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
            
            fromCoinnameLbl.text = exchangeData?.exchangeFromCoinId.uppercased()
            self.fromCoinImg.sd_setImage(with: URL(string: exchangeData?.exchangeFromCoinImg ?? ""))
            
            ToCoinNameLbl.text = exchangeData?.exchangeToCoinId.uppercased()
            self.ToCoinImg.sd_setImage(with: URL(string: exchangeData?.exchangeToCoinImg ?? ""))
            
            self.coinsLbl.text = "\(exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0") \(CommonFunctions.localisation(key: "AVAILABLE"))"
            
            self.totalBalanceLbl.text = "\(self.fromBalanceTotal ?? "0") €"
            
            //update numbers printed
            self.noOfCoinLbl.text = "~ 0 \(exchangeData?.exchangeToCoinId.uppercased() ?? "")"
            amountTF.text = "0 \(exchangeData?.exchangeFromCoinId.uppercased() ?? "")"
            let fromAssetId = self.fromAssetId
            self.fromAssetId = self.toAssetId
            self.toAssetId = fromAssetId
            
        }else{
            CommonFunctions.toster(CommonFunctions.localisation(key: "CANT_EXCHANGE_ASSET_DONT_HAVE"))
        }
    }
    
    @objc func switchPriceAssetBtnAction(){
        self.enteredText = ""
        self.isFloatTyped = false
        exchangeCoinToEuro = !exchangeCoinToEuro
        
        let fromAssetId = self.fromAssetId
        
        self.fromAssetId = self.toAssetId
        self.toAssetId = fromAssetId
        
        let noOfCoinText = self.noOfCoinLbl.text
        if(amountTF.text == "" || Int(noOfCoinText?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") == 0){
            self.noOfCoinLbl.text = "0 \(fromAssetId?.symboleTranslation.uppercased() ?? "")"
        }else{
            self.noOfCoinLbl.text = "\(amountTF.text ?? "")"
        }
        let amountText = noOfCoinText
        amountTF.text = amountText
    }
    
    @objc func maximumBtnAct(){
        var value = toBalance?.balanceData.balance
        if(strategyType == .Exchange){
            value = fromBalance?.balanceData.balance
            noOfCoins(value: value ?? "", max: true)
        }else{
            noOfCoins(value: value ?? "", max: true)
        }
        self.handlePreviewInvestButton(value: value ?? "")
        
//        if strategyType == .withdraw || strategyType == .withdrawEuro{
//            let maxAmountWithdrawableString = CommonFunctions.formattedAssetBinance(value: fromBalance?.balanceData.balance ?? "", numberOfDecimals: self.numberOfDecimals)
//            var enteredSubText = ""
//            
//            self.maxAmountWithdraw = Decimal(string:maxAmountWithdrawableString) ?? 0.0
//            let maxEuroWithdraw = maxAmountWithdraw * self.coinWithdrawPrice
//            
//            if exchangeCoinToEuro == false{
//                enteredText = CommonFunctions.getFormatedPrice(number: NSDecimalNumber(decimal: maxEuroWithdraw).doubleValue)
//                enteredSubText = CommonFunctions.formattedAssetDecimal(from: maxAmountWithdraw, price: self.coinWithdrawPrice)
//            }else{
//                enteredText = CommonFunctions.formattedAssetBinance(value: maxAmountWithdraw.description, numberOfDecimals: self.numberOfDecimals)
//                enteredSubText = CommonFunctions.getFormatedPrice(number: NSDecimalNumber(decimal: maxEuroWithdraw).doubleValue)
//            }
//            noOfCoins(value: enteredText, subValue: enteredSubText)
//            
//        }else if strategyType == .Exchange{
//            enteredText = CommonFunctions.formattedAssetBinance(value: exchangeData?.exchangeFromCoinBalance.balanceData.balance ?? "0", numberOfDecimals: fromCurrency?.decimals ?? 0)
//            noOfCoins(value: enteredText)
//        }else if strategyType == .oneTimeInvestment{
//            enteredText = fromBalance?.balanceData.balance.euroFormat ?? ""
//            noOfCoins(value: enteredText)
//        }else if strategyType == .Send{
//            if exchangeCoinToEuro == false{
//                enteredText = fromBalance?.balanceData.euroBalance.euroFormat ?? ""
//            }else{
//                enteredText = CommonFunctions.formattedAssetBinance(value: fromBalance?.balanceData.balance ?? "", numberOfDecimals: self.numberOfDecimals)
//            }
//            noOfCoins(value: enteredText)
//        }
        
//        if enteredText.contains("."){
//            self.isFloatTyped = true
//        }
        
    }
    
    
    func getAddedWalletAddress(){
        CommonFunctions.showLoader(self.view)
        CryptoAddressBookVM().getWithdrawalAdressAPI(completion: {[weak self]response in
            if let response = response{
                CommonFunctions.hideLoader(self?.view ?? UIView())
                if (response.data?.count ?? 0) > 0{
                    self?.creditCardLbl.text = response.data?[0].address ?? ""
                    self?.creditCardNumberLbl.text = response.data?[0].name ?? ""
                }
            }
        })
    }
    
   func  SellCoinApi(){
       self.previewMyInvest.showLoading()
       self.previewMyInvest.isUserInteractionEnabled = false
       ConfirmInvestmentVM().SellApi(assetId: self.assetsData?.symbol?.uppercased() ?? "", amount: self.totalEuroInvested.decimalValue, assetAmount: self.totalNoOfCoinsInvest.decimalValue, completion: {[weak self]response in
           self?.previewMyInvest.hideLoading()
           self?.previewMyInvest.isUserInteractionEnabled = true
           if let _ = response{
               let vc = BuySellPopUpVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
               vc.popUpType = .Sell
               vc.assetData = self?.assetsData
               vc.coinInvest = "\(CommonFunctions.formattedCurrency(from: self?.totalEuroInvested.doubleValue))"
               self?.present(vc, animated: true, completion: nil)
           }
       })
    }
}

//MARK: - Other functions
extension InvestInMyStrategyVC {
    
    func noOfCoins(value: String, max: Bool = false, completion: @escaping (() -> Void) = {}){
        let valueDouble = Double(value) ?? 0
        
        if strategyType == .Exchange{
            getValueConvertedExchange(value: valueDouble, completion: {
                completion()
            })
            
        }else{
            getValueConverted(value: valueDouble, isEuro: !exchangeCoinToEuro, max: max, completion: {
                completion()
            })
        }
        
        
        //TODO: continue here
//        let cleanedValue = value.replacingOccurrences(of: ",", with: "")
        
        
//        else if (strategyType == .withdraw || strategyType == .withdrawEuro){
//
//            
//            if exchangeCoinToEuro == false{
//                totalEuroInvested = NSDecimalNumber(string: cleanedValue)
//                totalNoOfCoinsInvest = NSDecimalNumber(string:cleanedSubValue)
//                
//                amountTF.text = "\(cleanedValue)€"
//                self.noOfCoinLbl.text = "~\(totalNoOfCoinsInvest) \(self.fromAssetId?.uppercased() ?? "")"
//                
//                if (strategyType == .withdraw){
//                    self.feesLbl.text = "\(CommonFunctions.localisation(key: "FEES")) : \(CommonFunctions.formattedAssetBinance(value: self.feeWithdrawal?.description ?? "0", numberOfDecimals: self.numberOfDecimals)) \(fromAssetId?.uppercased() ?? "")"
//                }
//            }else{
//                totalNoOfCoinsInvest = NSDecimalNumber(string:cleanedValue)
//                totalEuroInvested = NSDecimalNumber(string: subValue)
//                
//                amountTF.text = "\(cleanedValue) \(fromAssetId?.uppercased() ?? "")"
//                self.noOfCoinLbl.text = "~\(CommonFunctions.formattedCurrency(from: totalEuroInvested.doubleValue))€"
//                
//                if (strategyType == .withdraw){
//                    self.feesLbl.text = "\(CommonFunctions.localisation(key: "FEES")) : \(CommonFunctions.formattedAssetDecimal(from: Decimal(self.feeWithdrawal ?? 0), price: self.coinWithdrawPrice)) \(fromAssetId?.uppercased() ?? "")"
//                }
//                
//            }
//        }else if(strategyType == .singleCoin || strategyType == .singleCoinWithFrequence || strategyType == .Send){
//            if exchangeCoinToEuro == false{
//                amountTF.text = "\(cleanedValue)€"
//                let coinPrice = NSDecimalNumber(string: asset?.priceServiceResumeData.lastPrice ?? "0")
//                totalEuroInvested = NSDecimalNumber(string: cleanedValue)
//                totalNoOfCoinsInvest = (totalEuroInvested.decimalValue/coinPrice.decimalValue) as NSDecimalNumber
//                self.noOfCoinLbl.text = "~\(CommonFunctions.formattedAssetDecimal(from: totalNoOfCoinsInvest.decimalValue, price: coinPrice.decimalValue)) \(self.asset?.id.uppercased() ?? "")"
//            }else{
//                self.amountTF.text = "\(cleanedValue) \(self.asset?.id.uppercased() ?? "")"
//                let coinPrice = Decimal(string: asset?.priceServiceResumeData.lastPrice ?? "0") ?? 0
//                totalNoOfCoinsInvest = NSDecimalNumber(string: cleanedValue)
//                totalEuroInvested = CommonFunctions.getTwoDecimalValueDecimal(number: totalNoOfCoinsInvest.decimalValue * coinPrice) as NSDecimalNumber
//                self.noOfCoinLbl.text = "~\(CommonFunctions.formattedCurrency(from:  totalEuroInvested.doubleValue))€"
//            }
//            
//        }else if(strategyType == .oneTimeInvestment){
//            
//            let coinPrice = CommonFunctions.getTwoDecimalValue(number: (Double(fromBalance?.balanceData.euroBalance ?? "") ?? 0.0) / (Double(fromBalance?.balanceData.balance ?? "") ?? 0.0))
//            totalNoOfCoinsInvest = NSDecimalNumber(string: cleanedValue)
//            totalEuroInvested = (totalNoOfCoinsInvest.decimalValue * Decimal(coinPrice)) as NSDecimalNumber
//            
//            amountTF.text = "\(cleanedValue) USDC"
//            self.noOfCoinLbl.text = "~\(CommonFunctions.getTwoDecimalValueDecimal(number: totalEuroInvested.decimalValue)) €"
//        }else{
//            if exchangeCoin1ToCoin2 == false{
//                    amountTF.text = "\(CommonFunctions.numberFormat(from: Double(cleanedValue))) USDC"
//                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (Double(fromBalance?.balanceData.euroBalance ?? "") ?? 0.0) / (Double(fromBalance?.balanceData.balance ?? "") ?? 0.0))
//                totalNoOfCoinsInvest = NSDecimalNumber(string: cleanedValue)
//                totalEuroInvested = (totalEuroInvested.decimalValue / Decimal(coinPrice)) as NSDecimalNumber
//                    
//                self.noOfCoinLbl.text = "~\(CommonFunctions.getTwoDecimalValue(number: totalNoOfCoinsInvest.doubleValue)) \(self.fromAssetId?.uppercased() ?? "")"
//            }else{
//                amountTF.text = "\(CommonFunctions.numberFormat(from: Double(cleanedValue))) \(self.assetsData?.symbol?.uppercased() ?? (self.exchangeData?.exchangeFromCoinId ?? ""))"
//                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
//                totalEuroInvested = NSDecimalNumber(value: CommonFunctions.getTwoDecimalValue(number: ((Double(cleanedValue) ?? 0.0)*(coinPrice))))
//                
//                totalNoOfCoinsInvest = NSDecimalNumber(string: cleanedValue)
//                self.noOfCoinLbl.text = "~\(totalEuroInvested)€"
//            }
//        }
    }
    
    func updateValues(value: String){
        noOfCoins(value: value, completion: {
            self.amountNotTooHigh()
            self.handlePreviewInvestButton(value: value)
        })
    }
            
            
    
    func goToConfirmInvestment(){
        if strategyType == .activateStrategy || strategyType == .oneTimeInvestment || strategyType == .editActiveStrategy{
            if(CommonFunctions.frequenceEncoder(frequence: self.selectedFrequency) == "now"){
                strategyType = .oneTimeInvestment
            }
            if totalNoOfCoinsInvest.decimalValue > Decimal(totalEuroAvailable ?? 0){
                CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_USDC"))
            }else if totalNoOfCoinsInvest.decimalValue < Decimal(self.strategyData?.minAmount ?? 0){
                CommonFunctions.toster("\(CommonFunctions.localisation(key: "NOT_ENOUGH_INVESTMENT_PART_1")) \(self.strategyData?.minAmount ?? 0) \(CommonFunctions.localisation(key: "NOT_ENOUGH_INVESTMENT_PART_2"))")
            }else{
                self.goToPreviewINvest()
            }
        }else if strategyType == .singleCoin || strategyType == .singleCoinWithFrequence{
            if(self.strategyType == .singleCoin){
                if(StripeAPI.deviceSupportsApplePay() == false){
                    let alert = UIAlertController(title: CommonFunctions.localisation(key: "APPLE_PAY_ERROR"), message: CommonFunctions.localisation(key: "MUST_HAVE_CARD_REGISTERED_APPLE_PAY"), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: CommonFunctions.localisation(key: "UNDERSTAND"), style: .default, handler: {(action : UIAlertAction) in
                        
                    }))
                    present(alert, animated: true, completion: nil)
                }else{
                    self.goToPreviewINvest()
                }
            }else{
                self.goToPreviewINvest()
            }
            
        }else if strategyType == .Exchange{
            if totalEuroInvested.compare(maxCoinExchange) == .orderedDescending {
                CommonFunctions.toster(CommonFunctions.localisation(key: "NOT_ENOUGH_COINS"))
            }else{
                self.goToPreviewINvest()
            }
        }else if strategyType == .withdraw || strategyType == .withdrawEuro{
            if(totalNoOfCoinsInvest.decimalValue < Decimal(self.minimumWithdrawal ?? 0.0))
            {
                CommonFunctions.toster(CommonFunctions.localisation(key: "ALERT_AMOUNT_WITHDRAWAL_INFERIOR"))
            }else if(totalNoOfCoinsInvest.decimalValue > self.maxAmountWithdraw)
            {
                CommonFunctions.toster(CommonFunctions.localisation(key: "ALERT_AMOUNT_WITHDRAWAL_SUPERIOR"))
            }else{
                self.goToPreviewINvest()
            }
        }else{
            goToPreviewINvest()
        }
       
    }
    
    
    func goToPreviewINvest(){
        if(strategyType == .Exchange){
            let vc = ConfirmExecutionVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            self.previewMyInvest.showLoading()
                
            InvestInMyStrategyVM().ordersGetQuoteApi(fromAssetId: self.exchangeData?.exchangeFromCoinId ?? "", toAssetId: self.exchangeData?.exchangeToCoinId ?? "", exchangeFromAmount: self.totalNoOfCoinsInvest.decimalValue, controller: self, completion: {response in
                self.previewMyInvest.hideLoading()
                if( response != nil){
                    vc.InvestmentType = .Exchange
                    vc.fromAssetId = response?.data.fromAsset ?? ""
                    vc.exchangeTo = response?.data.toAsset ?? ""
                    vc.amountFrom = response?.data.fromAmount ?? ""
                    vc.amountFromDeductedFees = response?.data.fromAmountDeductedFees ?? ""
                    vc.amountTo = response?.data.toAmount ?? ""
                    vc.timeLimit = response?.data.validTimestamp ?? 0
                    vc.ratioCoin = response?.data.ratio ?? "0"
                    vc.orderId = response?.data.orderId ?? ""
                    vc.numberOfDecimal = self.numberOfDecimals
                    vc.fees = Double(response?.data.fees ?? "")
                    vc.coinFromPrice = Double(self.fromAssetPrice ?? "")
                    vc.coinToPrice = Decimal(string: self.toAssetPrice ?? "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }else if(strategyType == .withdraw){
            let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.InvestmentType = .withdraw
            vc.totalEuroInvested = totalEuroInvested.doubleValue
            vc.totalCoinsInvested = totalNoOfCoinsInvest.decimalValue
            vc.minimumWithdraw = self.minimumWithdrawal
            vc.address = self.addressLbl.text
            vc.network = self.network
            vc.fees = (self.feeWithdrawal)
            vc.assetId = self.toAssetId ?? ""
            vc.coinPrice = NSDecimalNumber(decimal: self.coinWithdrawPrice).doubleValue
            self.navigationController?.pushViewController(vc, animated: true)

        }else if(strategyType == .withdrawEuro){
            let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            vc.InvestmentType = .withdrawEuro
            vc.totalEuroInvested = totalEuroInvested.doubleValue
            vc.totalCoinsInvested = totalNoOfCoinsInvest.decimalValue
            vc.minimumWithdraw = self.minimumWithdrawal
            vc.ribSelected = self.ribSelected
            vc.assetId = self.fromAssetId ?? ""
            vc.coinPrice = NSDecimalNumber(decimal: self.coinWithdrawPrice).doubleValue
            self.navigationController?.pushViewController(vc, animated: true)

        }else if(strategyType == .singleCoin || strategyType == .singleCoinWithFrequence){
            let vc = ConfirmExecutionVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            self.previewMyInvest.showLoading()
            InvestInMyStrategyVM().ordersGetQuoteApi(fromAssetId: "eur", toAssetId: asset?.id ?? "", exchangeFromAmount: totalEuroInvested.decimalValue, controller: self, completion: {response in
                self.previewMyInvest.hideLoading()
                if response != nil{
                    vc.clientSecret = response?.data.clientSecret
                    vc.asset = self.asset
                    vc.orderId = response?.data.orderId ?? ""
                    vc.validTimeStamp = response?.data.validTimestamp
                    vc.paymentIntentId = response?.data.paymentIntentId
                    vc.amountFromDeductedFees = response?.data.fromAmountDeductedFees
                    vc.fromAmountInvested = Double(response?.data.fromAmount ?? "") ?? 0
                    vc.toAmountToObtain = Double(response?.data.toAmount ?? "") ?? 0
                    vc.InvestmentType = self.strategyType
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            })
            
        }else if(strategyType == .activateStrategy || strategyType == .oneTimeInvestment || strategyType == .editActiveStrategy){
            let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
            if(strategyType == .activateStrategy || strategyType == .editActiveStrategy){
                vc.frequency = self.selectedFrequency
            }
            
            vc.asset = asset
            vc.fees = totalNoOfCoinsInvest.doubleValue * 0.03
            vc.totalEuroInvested = totalNoOfCoinsInvest.doubleValue
            vc.InvestmentType = strategyType
            vc.strategyData = self.strategyData
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else if(strategyType == .Send){
            if(self.sendMean == "phone"){
                let vc = InformationPopUpVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
                vc.typeInformation = "sendMoneyPhone"
                vc.fromAssetId = self.asset?.id ?? ""
                vc.totalEuroInvested = Double(truncating: self.totalEuroInvested)
                vc.totalCoinsInvested = self.totalNoOfCoinsInvest as Decimal
                vc.numberOfDecimals = self.numberOfDecimals
                vc.controller = self
                self.present(vc, animated: true, completion: nil)
            }else{
                let qrScannerVC = QRCodeScannerViewController()
                qrScannerVC.onQRCodeScanned = { [weak self] qrCode in
                    InformationPopUpVM().getUserNameByPhoneApi(phone: qrCode, completion: {response in
                        if response != nil{
                            let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
                            vc.InvestmentType = .Send
                            vc.assetId = self?.asset?.id ?? ""
                            vc.totalCoinsInvested = (self?.totalNoOfCoinsInvest ?? 0)as Decimal
                            vc.totalEuroInvested = Double(truncating: self?.totalEuroInvested ?? 0)
                            vc.friendInfo = response?.data
                            vc.numberOfDecimals = self?.numberOfDecimals
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                }
                present(qrScannerVC, animated: true)
            }
            
        }
    }
    
    func handlePreviewInvestButton(value: String){
        if(self.strategyType == .Exchange)
        {
            if(Double(value) ?? 0 >= self.minAmountExchange ?? 0){
                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
                self.previewMyInvest.isUserInteractionEnabled = true
                self.exchangeAlertLbl.isHidden = true
            }
            else{
                self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
                self.previewMyInvest.isUserInteractionEnabled = false
                self.exchangeAlertLbl.isHidden = false
            }
        }else if(self.strategyType == .withdraw || self.strategyType == .withdrawEuro){
            if(self.addressSelected == true){
                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
                self.previewMyInvest.isUserInteractionEnabled = true
            }
        }else{
            
            self.previewMyInvest.backgroundColor = UIColor.PurpleColor
            self.previewMyInvest.isUserInteractionEnabled = true
        }
    }
    
    func getAddresses(){
        self.withdrawToAccountData.removeAll()
        CryptoAddressBookVM().getWithdrawalAdressAPI(completion: {[weak self]response in
            if let response = response{
                for address in response.data ?? []{
                    if(address.network == self?.network?.id){
                        self?.withdrawToAccountData.append(buyDepositeModel(icon: UIImage(), svgUrl: self?.network?.imageUrl, iconBackgroundColor: UIColor.clear, name: address.name , subName: address.address ?? "", rightBtnName: ""))
                    }
                }
            }
            if(self?.withdrawToAccountData.count ?? 0 > 0)
            {
                self?.addressSelected = true
            }
            self?.withdrawToAccountData.append(buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "ADD_ADRESS"))", subName: CommonFunctions.localisation(key: "UNLIMITED_WITHDRAWAL"), rightBtnName: ""))
            
            CommonUI.setUpLbl(lbl: self?.addressNameLbl ?? UILabel(), text: self?.withdrawToAccountData.first?.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: self?.addressLbl ?? UILabel(), text: self?.withdrawToAccountData.first?.subName, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
            if self?.withdrawToAccountData.first?.svgUrl == "" || self?.withdrawToAccountData.first?.svgUrl == nil{
                self?.addressImg.image = self?.withdrawToAccountData.first?.icon
            }else{
                self?.addressImg.sd_setImage(with: URL(string: self?.withdrawToAccountData.first?.svgUrl ?? ""))
            }
        })
        
    }
    
    func getRibs(){
        self.withdrawToAccountData.removeAll()
        AddNewRIBVM().getRibsApi(completion: {[weak self]response in
            if let response = response{
                for rib in response.data {
                    if(rib.ribStatus == "VALIDATED"){
                        self?.withdrawToAccountData.append(buyDepositeModel(icon: Assets.euro.image(), svgUrl: "", iconBackgroundColor: UIColor.clear, name: rib.name , subName: rib.iban.addressFormat , rightBtnName: "", ribData: rib))
                    }
                }
            }
            
            self?.withdrawToAccountData.append(buyDepositeModel(icon: Assets.invest_single_assets.image(), iconBackgroundColor: UIColor.LightPurple, name: "\(CommonFunctions.localisation(key: "ADD_ADRESS"))", subName: CommonFunctions.localisation(key: "UNLIMITED_WITHDRAWAL"), rightBtnName: ""))
            
            var ribSelected = self?.withdrawToAccountData[self?.indexRibSelected ?? (self?.withdrawToAccountData.count ?? 1) - 1]
            
            if(self?.withdrawToAccountData.count ?? 0 > 0)
            {
                self?.addressSelected = true
                ribSelected = self?.withdrawToAccountData[self?.indexRibSelected ?? (self?.withdrawToAccountData.count ?? 2) - 2]
            }
            self?.ribSelected = ribSelected?.ribData
            CommonUI.setUpLbl(lbl: self?.addressNameLbl ?? UILabel(), text: ribSelected?.name, textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
            CommonUI.setUpLbl(lbl: self?.addressLbl ?? UILabel(), text: ribSelected?.subName.addressFormat, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
            
            if self?.withdrawToAccountData.first?.svgUrl == "" || self?.withdrawToAccountData.first?.svgUrl == nil{
                self?.addressImg.image = ribSelected?.icon
            }else{
                self?.addressImg.sd_setImage(with: URL(string: ribSelected?.svgUrl ?? ""))
            }
        })
        
    }
    
    private func getValueConverted(value: Double, isEuro: Bool = false, max: Bool = false, completion: @escaping (() -> Void)) {
        let idCoin = (self.fromAssetId == "eur" ? self.toAssetId : self.fromAssetId) ?? ""

        let viewToLoad = (isEuro && max ? self.stackViewPrices : self.noOfCoinLbl) ?? UIView()
        let valueFormated = CommonFunctions.formattedAssetBinance(value: value.description, numberOfDecimals: CommonFunctions.getDecimal(id: self.fromAssetId ?? ""))
        let valueFormatedDouble = Double(valueFormated) ?? 0
        
        if(isEuro && max){
            CommonFunctions.showLoaderCalculation(viewToLoad, width: 50)
        }else{
            self.enteredText = valueFormated
            self.amountTF.text = "\(valueFormated) \(self.fromAssetId!.symboleTranslation.uppercased())"
                
            CommonFunctions.showLoaderCalculation(viewToLoad)
        }
       
        
        InvestInMyStrategyVM().getLastPriceApi(assetId: idCoin) { response in
            CommonFunctions.hideLoaderCalculation(viewToLoad)
            guard let priceString = response?.data.price, let price = Double(priceString) else {
                print("Error - getValueConverted") // Handle error if response is invalid
                return
            }
            
           
            if isEuro && !max {
                let resultOperation = valueFormatedDouble / price
                
                self.noOfCoinLbl.text = "\(CommonFunctions.formattedAssetBinance(value: resultOperation.description, numberOfDecimals: CommonFunctions.getDecimal(id: idCoin))) \(idCoin.uppercased())"
                self.totalEuroInvested = NSDecimalNumber(value: value)
                self.totalNoOfCoinsInvest = NSDecimalNumber(value: resultOperation)
                
            } else {
                let resultOperation = valueFormatedDouble * price
                var noOfCoinLblText = resultOperation.description
                let resultOperationFormated = CommonFunctions.formattedAssetBinance(value: resultOperation.description, numberOfDecimals: CommonFunctions.getDecimal(id: self.fromAssetId ?? ""))
                let resultOperationFormatedDouble = Double(resultOperationFormated) ?? 0
                
                if(isEuro && max){
                    self.enteredText = resultOperationFormated
                    self.amountTF.text = "\(resultOperationFormated) \(self.fromAssetId!.symboleTranslation.uppercased())"
                    
                    noOfCoinLblText = value.description
                }
                
                self.noOfCoinLbl.text = "\(CommonFunctions.formattedAssetBinance(value: noOfCoinLblText.description, numberOfDecimals: CommonFunctions.getDecimal(id: self.toAssetId ?? ""))) \(self.toAssetId!.symboleTranslation.uppercased())"
                
                self.totalEuroInvested = NSDecimalNumber(value: resultOperationFormatedDouble)
                self.totalNoOfCoinsInvest = NSDecimalNumber(value: valueFormatedDouble)
            }
            completion()
        }
    }
    
    private func getValueConvertedExchange(value: Double, completion: @escaping (() -> Void)) {
        // TODO: Fetch prices for both assets in parallel to get exact conversion; display a loader
        let viewToLoad = self.bottomPrices ?? UIView()
        CommonFunctions.showLoaderCalculation(viewToLoad, width: 50)
        
        let dispatchGroup = DispatchGroup()
        var coinFromPrice: Double?
        var coinToPrice: Double?
        
        // Fetch price for "from" asset
        dispatchGroup.enter()
        InvestInMyStrategyVM().getLastPriceApi(assetId: self.fromAssetId ?? "") { response in
            defer { dispatchGroup.leave() } // Ensure dispatchGroup.leave is called
            guard let priceString = response?.data.price, let price = Double(priceString) else {
                print("Error - getValueConverted (from asset)") // Handle error
                return
            }
            coinFromPrice = price
        }
        
        // Fetch price for "to" asset
        dispatchGroup.enter()
        InvestInMyStrategyVM().getLastPriceApi(assetId: self.toAssetId ?? "") { response in
            defer { dispatchGroup.leave() } // Ensure dispatchGroup.leave is called
            guard let priceString = response?.data.price, let price = Double(priceString) else {
                print("Error - getValueConverted (to asset)") // Handle error
                return
            }
            coinToPrice = price
        }
        
        // When both API calls are complete
        dispatchGroup.notify(queue: .main) {
            CommonFunctions.hideLoaderCalculation(viewToLoad)
            
            guard let fromPrice = coinFromPrice, let toPrice = coinToPrice else {
                print("Error - Missing prices for conversion")
                return
            }
            
            let valueFormated = CommonFunctions.formattedAssetBinance(value: value.description, numberOfDecimals: self.fromCurrency?.decimals ?? 0)
            self.enteredText = valueFormated
            self.amountTF.text = "\(valueFormated) \(self.exchangeData?.exchangeFromCoinId.symboleTranslation.uppercased() ?? "")"
            
            let euroInvested = (Double(valueFormated) ?? 0) * fromPrice
            self.totalEuroInvested = NSDecimalNumber(value: euroInvested)
            
            self.totalNoOfCoinsInvest = NSDecimalNumber(string: valueFormated)
            
            self.noOfCoinLbl.text = "~\(CommonFunctions.formattedAssetBinance(value: (self.totalNoOfCoinsInvest.decimalValue * Decimal(fromPrice / toPrice)).description, numberOfDecimals: self.toCurrency?.decimals ?? 0)) \(self.exchangeData?.exchangeToCoinId.uppercased() ?? "")"
            
            let resultEuro = value * fromPrice
            self.feesLbl.text = "\(CommonFunctions.formattedAssetBinance(value: resultEuro.description, numberOfDecimals: 2)) €"
            
            completion()
        }
    }
    
    private func amountNotTooHigh(){
        let enteredAmount = totalNoOfCoinsInvest
       
        let balance = fromBalance == nil ? self.toBalance?.balanceData.balance : self.fromBalance?.balanceData.balance
        if enteredAmount.decimalValue > Decimal(string: balance ?? "") ?? 0 {
            amountTF.shake()
            
            // Vibration
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.impactOccurred()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.maximumBtnAct() }
        }
    }
}


