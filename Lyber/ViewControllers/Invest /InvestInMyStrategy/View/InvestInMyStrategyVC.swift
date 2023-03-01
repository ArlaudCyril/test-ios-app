//
//  InvestInMyStrategyVC.swift
//  Lyber
//
//  Created by sonam's Mac on 10/06/22.
//

import UIKit
import IQKeyboardManagerSwift

class InvestInMyStrategyVC: UIViewController {
    //MARK: - Variables
    var strategyType : InvestStrategyModel = .activateStrategy
    var fromCoinData : Asset?
    var enteredText : String = ""
    var isFloatTyped : Bool = false
    var assetsData : Trending? , strategyCoinsData : [InvestmentStrategyAsset] = [],strategyData : Strategy?
    var totalNoOfCoinsInvest = Double() , totalEuroInvested = Double()
    var selectedFrequency = "",exchangeCoinToEuro = false
    var secondCoinPrice : Double = 1461.99
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
    @IBOutlet var rightExchangeBtn: UIButton!
    
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
        setUpUI()
        checkInvestInStrategy()
        self.amountTF.becomeFirstResponder()
        self.amountTF.inputView = UIView()
        IQKeyboardManager.shared.enableAutoToolbar = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if strategyType == .withdraw{
            getAddedWalletAddress()
        }
    }
}

//MARK: - SetUpUI
extension InvestInMyStrategyVC{
    func setUpUI(){
        self.strategyCoinsData = self.strategyData?.bundle ?? []
        self.rightExchangeBtn.layer.cornerRadius = 8
        self.maximumBtn.isHidden = true
        self.rightExchangeBtn.isHidden = true
        CommonUI.setUpLbl(lbl: self.investInMyStrategyLbl, text: L10n.InvestInMyStrat.description, textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.coinsLbl, text: "BTC, ETH, SOL, AVAX +5 other assets", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Small.sizeValue()))
        CommonUI.setUpLbl(lbl: self.noOfCoinLbl, text: "0.0 BTC", textColor: UIColor.grey877E95, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        
        self.creditCardVw.backgroundColor = UIColor.greyColor
        self.creditCardVw.layer.cornerRadius = 16
        let creditTapped  = UITapGestureRecognizer(target: self, action: #selector(selectCard))
        self.creditCardVw.addGestureRecognizer(creditTapped)
        self.creditCardVw.isHidden = true
        
        self.BalanceView.backgroundColor = UIColor.greyColor
        self.BalanceView.layer.cornerRadius = 12
        CommonUI.setUpLbl(lbl: self.balanceLbl, text: "Balance: ", textColor: UIColor.Grey423D33, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: self.totalBalanceLbl, text: "\(CommonFunctions.formattedCurrency(from: totalEuroAvailable ?? 0))€", textColor: UIColor.Grey423D33, font: UIFont.MabryPro(Size.Large.sizeValue()))
        
        amountTF.font = UIFont.AtypDisplayMedium(60.0)
        //        amountTF.inputView = UIView()
        amountTF.delegate = self
        self.amountTF.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        amountTF.textColor = UIColor.PurpleColor
        CommonUI.setUpLbl(lbl: creditCardNumberLbl, text: "select credit card", textColor: UIColor.grey36323C, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        CommonUI.setUpLbl(lbl: creditCardLbl, text: "", textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpButton(btn: self.maximumBtn, text: "MAX", textcolor: UIColor.ThirdTextColor, backgroundColor: UIColor.greyColor, cornerRadius: 8, font: UIFont.MabryProMedium(Size.VSmall.sizeValue()))
        
        CommonUI.setUpViewBorder(vw: self.frequencyVw, radius: 12, borderWidth: 0, borderColor: UIColor.PurpleColor.cgColor, backgroundColor: UIColor.PurpleColor)
        CommonUI.setUpLbl(lbl: self.frequencyLbl, text: L10n.AddAFrequency.description, textColor: UIColor.whiteColor, font: UIFont.MabryProMedium(Size.XLarge.sizeValue()))
        
        CommonUI.setUpLbl(lbl: fromLbl, text: L10n.From.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: fromCoinnameLbl, text: assetsData?.symbol?.uppercased() ?? self.fromCoinData?.assetID ?? "", textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.fromCoinImg.sd_setImage(with: URL(string: assetsData?.image ?? ""))
        
        
        CommonUI.setUpLbl(lbl: ToLbl, text: L10n.To.description, textColor: UIColor.grey877E95, font: UIFont.MabryPro(Size.Medium.sizeValue()))
        CommonUI.setUpLbl(lbl: ToCoinNameLbl, text: L10n.ETH.description, textColor: UIColor.ThirdTextColor, font: UIFont.MabryProMedium(Size.Large.sizeValue()))
        self.ToCoinImg.sd_setImage(with: URL(string: "https://assets.coingecko.com/coins/images/279/large/ethereum.png?1595348880"))
        
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
        self.previewMyInvest.setTitle(L10n.PreviewMyInvestment.description, for: .normal)
        self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
        self.previewMyInvest.isUserInteractionEnabled = false
        
        self.cancelBtn.addTarget(self, action: #selector(cancelBtnAct), for: .touchUpInside)
        self.exchangeBtn.addTarget(self, action: #selector(exchangeBtnAction), for: .touchUpInside)
        self.maximumBtn.addTarget(self, action: #selector(maximumBtnAct), for: .touchUpInside)
        self.rightExchangeBtn.addTarget(self, action: #selector(rightExchangeBtnAction), for: .touchUpInside)
        self.previewMyInvest.addTarget(self, action: #selector(previewMyInvestAction), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(exchangeToTapped))
        self.ToView.addGestureRecognizer(tap)
        
        let frequencyTap = UITapGestureRecognizer(target: self, action: #selector(frequencyBtnAction))
        self.frequencyVw.addGestureRecognizer(frequencyTap)
    }
    
    func checkInvestInStrategy(){
        if strategyType == .singleCoin{
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = true
            self.noOfCoinVw.isHidden = false
            self.maximumBtn.isHidden = false
            self.rightExchangeBtn.isHidden = false
            self.investInMyStrategyLbl.text = "\(L10n.InvestIn.description)\(self.assetsData?.name ?? "")"
            self.noOfCoinLbl.text = "0.0 \(self.assetsData?.symbol?.uppercased() ?? "")"
            self.frequencyLbl.text = "\(L10n.AddAFrequency.description) (Optional)"
            self.maximumMoneyInvest()
        }else if (strategyType == .activateStrategy || strategyType == .editActiveStrategy){
            self.exchangeView.isHidden = true
            self.coinsLbl.isHidden = false
            self.noOfCoinVw.isHidden = true
            if(strategyData?.activeStrategy != nil)
            {//we take the informations of the active strategy
                self.selectedFrequency = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyLbl.text = CommonFunctions.frequenceDecoder(frequence: strategyData?.activeStrategy?.frequency)
                self.frequencyVw.backgroundColor = UIColor.greyColor
                self.frequencyLbl.textColor = UIColor.ThirdTextColor
                self.frequencyDropDown.image = Assets.drop_down.image()
                self.frequencyImg.image = Assets.calendar_black.image()
                
                amountTF.text = "\(strategyData?.activeStrategy?.amount ?? 0)€"
                totalEuroInvested = Double(strategyData?.activeStrategy?.amount ?? 0)
                
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
            self.investInMyStrategyLbl.text = L10n.EuroDesposit.description
            self.previewMyInvest.setTitle(L10n.PreviewDeposit.description, for: .normal)
        }else if strategyType == .Exchange{
            self.frequencyVw.isHidden = true
            self.maximumBtn.isHidden = false
            self.previewMyInvest.setTitle(L10n.PreviewExchange.description, for: .normal)
            self.investInMyStrategyLbl.text = "\(L10n.Exchange.description)\(fromCoinData?.assetID ?? (self.assetsData?.symbol?.uppercased() ?? ""))"
            if fromCoinData == nil{
                self.coinsLbl.text = "\((assetsData?.total_balance ?? 0)*(assetsData?.currentPrice ?? 0))€ Available"
            }else{
                self.coinsLbl.text = "\((fromCoinData?.totalBalance ?? 0)*(fromCoinData?.euroAmount ?? 0))€ Available"
            }
            
            self.noOfCoinLbl.text = "0.0 \(self.ToCoinNameLbl.text ?? "")"
            self.amountTF.placeholder = "0\(self.assetsData?.symbol?.uppercased() ?? self.fromCoinData?.assetID ?? "")"
            self.fromView.layer.cornerRadius = 16
            self.ToView.layer.cornerRadius = 16
            self.exchangeBtn.layer.cornerRadius = 8
            self.exchangeData = exchangeFromModel(exchangeFromCoin: self.fromCoinnameLbl.text ?? "", exchangeFromCoinImg: self.fromCoinImg.image ?? UIImage(), exchangeToCoin: self.ToCoinNameLbl.text ?? "", exchangeToCoinImg: self.ToCoinImg.image ?? UIImage())
            self.MaxMoneyExchange()
        }else if strategyType == .withdraw{
            self.creditCardVw.isHidden = false
            self.exchangeView.isHidden = true
            self.frequencyVw.isHidden = true
            self.maximumBtn.isHidden = false
            self.rightExchangeBtn.isHidden = false
            self.previewMyInvest.setTitle(L10n.Next.description, for: .normal)
            self.investInMyStrategyLbl.text = "\(L10n.WithdrawFrom.description)\(assetsData?.name ?? "")"
            self.coinsLbl.text = "\((fromCoinData?.totalBalance ?? 0)*(fromCoinData?.euroAmount ?? 0))€ Available"
            self.noOfCoinLbl.text = "0.0 \(fromCoinData?.assetID ?? "")"
            self.maxMoneyWithdraw()
        } else if strategyType == .withdrawEuro{
            self.exchangeView.isHidden = true
            self.frequencyVw.isHidden = true
            self.previewMyInvest.setTitle(L10n.Next.description, for: .normal)
            self.investInMyStrategyLbl.text = "\(L10n.Withdraw.description) Euro"
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
            self.investInMyStrategyLbl.text = "\(L10n.Sell.description) \(self.assetsData?.name ?? "")"
            self.previewMyInvest.setTitle(L10n.Sell.description, for: .normal)
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
            if totalEuroInvested > maxEuroWithdraw{
                CommonFunctions.toster("you don't have enough coins to withdraw")
            }else{
                let vc = EnterWalletAddressVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
                vc.fromCoinsData = fromCoinData
                vc.assetData = self.assetsData
                vc.totalEuroInvested = totalEuroInvested
                vc.noOfCoinsinvested = totalNoOfCoinsInvest
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if strategyType == .singleCoin{
            self.goToConfirmInvestment()
        }else if strategyType == .sell{
            SellCoinApi()
        }else if strategyType == .withdrawEuro{
            self.previewMyInvest.showLoading()
            EnterWalletAddressVM().withdrawFiatApi(amount: totalEuroInvested, completion: {[weak self]response in
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
                    CommonFunctions.toster(L10n.pleaseSelectFrequency.description)
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
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isHidden = true
        self.present(nav, animated: true, completion: nil)
        vc.coinSelectedCallback = {[weak self]coinData in
            self?.ToCoinImg.yy_setImage(with: URL(string: coinData?.image ?? ""), placeholder: UIImage(), options: .progressiveBlur, completion: {_,_,_,_,_ in 
                self?.exchangeData = exchangeFromModel(exchangeFromCoin: self?.fromCoinnameLbl.text ?? "", exchangeFromCoinImg: self?.fromCoinImg.image ?? UIImage(), exchangeToCoin: self?.ToCoinNameLbl.text ?? "", exchangeToCoinImg: self?.ToCoinImg.image ?? UIImage())
            })
            self?.ToCoinNameLbl.text = coinData?.symbol?.uppercased()
            self?.secondCoinPrice = CommonFunctions.getTwoDecimalValue(number: (coinData?.currentPrice ?? 0.0))
            
            
        }
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
        
        
        //        switch sender.tag{
        //        case 1,2,3,4,5,6,7,8,9,0:
        //            print("typed ",sender.tag)
        //            if enteredText.count == 0{
        //                if sender.tag == 0{
        //
        //                }else{
        //                    self.enteredText.insert(contentsOf: "\(sender.tag)", at : enteredText.index(enteredText.startIndex, offsetBy: cursorPosition))
        //                    amountTF.text = "\(self.enteredText)€"
        //                    //                          amountTF.text = "\(CommonFunction.numberFormat(from: Double(enteredText)))€"
        //                    //                          let startPosition: UITextPosition = amountTF.beginningOfDocument
        //                    //                          let endPosition: UITextPosition = amountTF.endOfDocument
        //                    //                          let selectedRange: UITextRange? = amountTF.selectedTextRange
        //                    //                          if let selectedRange = amountTF.selectedTextRange {
        //                    //                              let cursorPosition = amountTF.offset(from: amountTF.beginningOfDocument, to: selectedRange.start)
        //                    //                              print("cursor position -----\(cursorPosition)")
        //                    //                          }
        //                    //                          noOfCoins(value: enteredText)
        //                }
        //            }else{
        //                self.enteredText.insert(contentsOf: "\(sender.tag)", at : enteredText.index(enteredText.startIndex, offsetBy: cursorPosition - 1))
        //                amountTF.text = "\(self.enteredText)€"
        //                //                      amountTF.text = "\(CommonFunction.numberFormat(from: Double(enteredText)))€"
        //                //                      enteredText = "\(enteredText)\(sender.tag)"
        //                //                      noOfCoins(value: enteredText)
        //            }
        //            if enteredText != ""{
        //                self.previewMyInvest.backgroundColor = UIColor.PurpleColor
        //                self.previewMyInvest.isUserInteractionEnabled = true
        //            }
        //            break
        //        case 10:
        //            if isFloatTyped == false{
        //                if enteredText.count == 0{
        //                    print("typed ",sender.tag)
        //                    enteredText = "0."
        //                }else{
        //                    print("typed ",sender.tag)
        //                    enteredText = "\(enteredText)."
        //                }
        //                //                print("typed ",sender.tag)
        //                //                enteredText = "\(enteredText)."
        //                amountTF.text = "\(self.enteredText)€"
        //                isFloatTyped = true
        //            }
        //            break
        //        case 11:
        //            if cursorPosition > 0{
        //                if enteredText != ""{
        //                    if enteredText.count == 1{
        //                        enteredText.removeLast()
        ////                        noOfCoins(value: enteredText)
        //                        amountTF.text?.removeAll()
        //                        isFloatTyped = false
        //                        self.previewMyInvest.backgroundColor = UIColor.TFplaceholderColor
        //                        self.previewMyInvest.isUserInteractionEnabled = false
        //                    }else{
        //                        //                          let lastRemove = enteredText.removeLast()
        //                        //                          noOfCoins(value: enteredText)
        //                        //                          if lastRemove == "."{
        //                        //                              isFloatTyped = false
        //                        //                          }
        //                        if cursorPosition == ((self.amountTF.text?.count ?? 0)){
        //                            self.enteredText.remove(at: enteredText.index(enteredText.startIndex, offsetBy: cursorPosition - 2))
        //                            self.amountTF.text = "\(self.enteredText)€"
        //                        }else{
        //                            self.enteredText.remove(at: enteredText.index(enteredText.startIndex, offsetBy: cursorPosition - 1))
        //                            self.amountTF.text = "\(self.enteredText)€"
        //                        }
        //
        //
        ////                        let str = self.enteredText.remove(at: enteredText.index(enteredText.startIndex, offsetBy: cursorPosition - 2))
        ////                        print(str)
        //////                        if enteredText.removeLast() == "."{
        //////                            isFloatTyped = false
        //////                        }
        ////                        self.amountTF.text = "\(self.enteredText)€"
        //                    }
        //                }
        //            }
        //                break
        //            default:
        //                break
        //            }
    }
    
    @objc func rightExchangeBtnAction(){
        exchangeCoinToEuro = !exchangeCoinToEuro
        if exchangeCoinToEuro == false{
                amountTF.text = "\(totalEuroInvested)€"
                self.noOfCoinLbl.text = "\(totalNoOfCoinsInvest)\(self.assetsData?.symbol?.uppercased() ?? (self.fromCoinData?.assetID ?? ""))"
                self.enteredText = "\(totalEuroInvested)"
        }else{
                self.noOfCoinLbl.text = "\(totalEuroInvested)€"
                self.amountTF.text = "\(totalNoOfCoinsInvest)\(self.assetsData?.symbol?.uppercased() ?? (self.fromCoinData?.assetID ?? ""))"
                self.enteredText = "\(totalNoOfCoinsInvest)"
        }
    }
    
    @objc func exchangeBtnAction(){
        self.enteredText = ""
        exchangeCoinToEuro = !exchangeCoinToEuro
        if exchangeCoinToEuro == false{
            amountTF.text = "\(0)\(exchangeData?.exchangeFromCoin ?? "")"
            self.noOfCoinLbl.text = "\(0) \(exchangeData?.exchangeToCoin ?? "")"
            self.fromCoinnameLbl.text = exchangeData?.exchangeFromCoin ?? ""
            self.fromCoinImg.image = exchangeData?.exchangeFromCoinImg ?? UIImage()
            self.ToCoinNameLbl.text = exchangeData?.exchangeToCoin ?? ""
            self.ToCoinImg.image = exchangeData?.exchangeToCoinImg ?? UIImage()
        }else{
            amountTF.text = "\(0)\(exchangeData?.exchangeToCoin ?? "")"
            self.noOfCoinLbl.text = "\(0) \(exchangeData?.exchangeFromCoin ?? "")"
            self.fromCoinnameLbl.text = exchangeData?.exchangeToCoin ?? ""
            self.fromCoinImg.image = exchangeData?.exchangeToCoinImg ?? UIImage()
            self.ToCoinNameLbl.text = exchangeData?.exchangeFromCoin ?? ""
            self.ToCoinImg.image = exchangeData?.exchangeFromCoinImg ?? UIImage()
        }
    }
    
    @objc func maximumBtnAct(){
        if strategyType == .singleCoin{
            if exchangeCoinToEuro {
                enteredText = "\(MaxCoin)"
                noOfCoins(value: enteredText)
            }else{
                enteredText = "\(CommonFunctions.getTwoDecimalValue(number: totalEuroAvailable ?? (assetsData?.total_balance ?? 0)))"
                noOfCoins(value: enteredText)
            }
        }else if strategyType == .withdraw{
            if exchangeCoinToEuro{
                enteredText = "\(maxCoinWithdraw)"
                noOfCoins(value: enteredText)
            }else{
                if self.fromCoinData?.totalBalance == 0 || self.fromCoinData?.totalBalance == nil{
                    enteredText = "\(CommonFunctions.getTwoDecimalValue(number: ((assetsData?.total_balance ?? 0)*(assetsData?.currentPrice ?? 0))))"
                }else{
                    enteredText = "\(CommonFunctions.getTwoDecimalValue(number: ((fromCoinData?.totalBalance ?? 0)*(fromCoinData?.euroAmount ?? 0))))"
                }
                noOfCoins(value: enteredText)
            }
            
        }else if strategyType == .Exchange{
            enteredText = "\(CommonFunctions.getTwoDecimalValue(number: ((fromCoinData?.totalBalance ?? (self.assetsData?.total_balance ?? 0)))))"
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
       ConfirmInvestmentVM().SellApi(assetId: self.assetsData?.symbol?.uppercased() ?? "", amount: self.totalEuroInvested, assetAmount: self.totalNoOfCoinsInvest, completion: {[weak self]response in
           self?.previewMyInvest.hideLoading()
           self?.previewMyInvest.isUserInteractionEnabled = true
           if let _ = response{
               let vc = BuySellPopUpVC.instantiateFromAppStoryboard(appStoryboard: .SwapWithdraw)
               vc.popUpType = .Sell
               vc.assetData = self?.assetsData
               vc.coinInvest = "\(CommonFunctions.formattedCurrency(from: self?.totalEuroInvested))"
               self?.present(vc, animated: true, completion: nil)
           }
       })
    }
}

//MARK: - Other functions
extension InvestInMyStrategyVC {
    
    func noOfCoins(value: String){
        if strategyType == .Exchange{
            if exchangeCoinToEuro == false{
                amountTF.text = "\(value)\(self.exchangeData?.exchangeFromCoin ?? "")"
                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
                totalEuroInvested = Double(value) ?? 0.0
                
                let totalEuro = ((Double(value) ?? 0.0)*(coinPrice))
                //                CommonFunction.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(coinPrice)))
                totalNoOfCoinsInvest = CommonFunctions.getTwoDecimalValue(number: (totalEuro*(1/secondCoinPrice)))
                self.noOfCoinLbl.text = "\(totalNoOfCoinsInvest) \(self.exchangeData?.exchangeToCoin ?? "")"
            }else{
                amountTF.text = "\(value)\(self.exchangeData?.exchangeToCoin ?? "")"
                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (secondCoinPrice))
                totalEuroInvested = Double(value) ?? 0.0
                let totalEuro = ((Double(value) ?? 0.0)*(coinPrice))
                //                CommonFunction.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(coinPrice)))
                
                totalNoOfCoinsInvest =
//                (totalEuro*(1/(self.assetsData?.currentPrice ?? 0.0)))
                                CommonFunctions.getTwoDecimalValue(number: (totalEuro*(1/(self.assetsData?.currentPrice ?? 0.0))))
                self.noOfCoinLbl.text = "\(totalNoOfCoinsInvest) \(self.exchangeData?.exchangeFromCoin ?? "")"
            }
        }else{
            if exchangeCoinToEuro == false{
                    amountTF.text = "\(CommonFunctions.numberFormat(from: Double(value)))€"
                    let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
                    totalEuroInvested = Double(value) ?? 0.0
                    totalNoOfCoinsInvest =
//                ((Double(value) ?? 0.0)*(1/coinPrice))
                                    CommonFunctions.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(1/coinPrice)))
                    
                    self.noOfCoinLbl.text = "\(CommonFunctions.getTwoDecimalValue(number: totalNoOfCoinsInvest)) \(self.assetsData?.symbol?.uppercased() ?? (self.fromCoinData?.assetID ?? ""))"
            }else{
                amountTF.text = "\(CommonFunctions.numberFormat(from: Double(value)))\(self.assetsData?.symbol?.uppercased() ?? (self.fromCoinData?.assetID ?? ""))"
                let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
                totalEuroInvested =
//                ((Double(value) ?? 0.0)*(coinPrice))
                CommonFunctions.getTwoDecimalValue(number: ((Double(value) ?? 0.0)*(coinPrice)))
                
                totalNoOfCoinsInvest = Double(value) ?? 0.0
                self.noOfCoinLbl.text = "\(totalEuroInvested)€"
            }
        }
    }
    
    func goToConfirmInvestment(){
        if strategyType == .singleCoin || strategyType == .activateStrategy || strategyType == .editActiveStrategy{
            if totalEuroInvested > (totalEuroAvailable ?? 0){
                CommonFunctions.toster("you don't have enough balance to invest")
            }else{
                self.goToPreviewINvest()
            }
        }else if strategyType == .Exchange{
            if totalEuroInvested > maxCoinExchange {
                CommonFunctions.toster("you don't have enough coins to exchange")
            }else{
                self.goToPreviewINvest()
            }
        }
       
    }
    
    
    func goToPreviewINvest(){
        let vc = ConfirmInvestmentVC.instantiateFromAppStoryboard(appStoryboard: .InvestStrategy)
        vc.assetData = assetsData
        vc.totalCoinsInvested = totalNoOfCoinsInvest
        vc.totalEuroInvested = totalEuroInvested
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
        }else if strategyType == .Exchange{
            vc.InvestmentType = .Exchange
            vc.exchangeFrom = self.fromCoinnameLbl.text ?? ""
            vc.exchangeTo = self.ToCoinNameLbl.text ?? ""
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func maximumMoneyInvest(){
        let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
        print(CommonFunctions.getTwoDecimalValue(number: ((totalEuroAvailable ?? 0)*(1/coinPrice))))
        MaxCoin = CommonFunctions.getTwoDecimalValue(number: ((totalEuroAvailable ?? 0)*(1/coinPrice)))
    }
    
    func maxMoneyWithdraw(){
        if self.fromCoinData?.totalBalance == 0 || self.fromCoinData?.totalBalance == nil{
            maxEuroWithdraw = (CommonFunctions.getTwoDecimalValue(number: ((assetsData?.total_balance ?? 0)*(assetsData?.currentPrice ?? 0))))
        }else{
            maxEuroWithdraw = (CommonFunctions.getTwoDecimalValue(number: ((fromCoinData?.totalBalance ?? 0)*(fromCoinData?.euroAmount ?? 0))))
        }
        let coinPrice = CommonFunctions.getTwoDecimalValue(number: (self.assetsData?.currentPrice ?? 0.0))
        maxCoinWithdraw = CommonFunctions.getTwoDecimalValue(number: ((maxEuroWithdraw)*(1/coinPrice)))
        
    }
    func MaxMoneyExchange(){
        maxCoinExchange = (CommonFunctions.getTwoDecimalValue(number: ((fromCoinData?.totalBalance ?? (self.assetsData?.total_balance ?? 0)))))
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
