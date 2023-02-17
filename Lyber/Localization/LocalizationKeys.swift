//
//  LocalizationKeys.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import CoreText
// MARK:- Language key enum
enum L10n {
    
    // MARK: -  Login Screen
    case lyberReInvented
    case diversifiedRegularSimple
    case SignUp
    case LogIn
    case YourPhoneNumber
    case enterPhoneDescription
    case Next
    case EnterCode
    case confirmationCode
    case resendCodeWillBeSend
    case ResendCode
    case CreatePIN
    case fourDigitCode
    case ConfirmPIN
    case EnableNotifications
    case Activate
    case ActivateFaceID
    case AccessLyberFaceID
    case Decline
    case AskMeLater
    case dontMissAnyUpdate
    case NotNow
    
    //MARK: - education Strategy
    case DiversifiedStrategy
    case flexibleFrequency
    case EvolvingAndAutomatedPortfolio
    case educationSubDescription1
    case educationSubDescription2
    case educationSubDescription3
    case ChooseAStrategy
    
    
    //MARK: - own starategy
    case BuildMyOwnStrategy
    case AddManyAssetsAsYouWish
    case AddAnAsset
    case SauvegarderMaStratégie
    case VousDevezAjouter
    case Trending
    case TopGainers
    case TopLoosers
    case Stable
    case Bitcoin
    case BTC
    case Ether
    case ETH
    case Dogecoin
    case DOGE
    case Solana
    case SOL
    case USDC
    case ADA
    case LUNA
    case XND
    case MATIC
    case ViewAllAvailableAssets
    case Allocation
    case Auto
    case SaveMyStrategy
    case YourStrategyReadyToBeSaved
    case asset
    case assets
    case AllAssets
    case Proportion
    case SetThisProportion
    case SetThisAllocation
    case yourAllocationIsGreaterThan
    case yourAllocationIslessThan
    case InvestmentStrategies
    case strategiesAreThereToHelpYou
    case MyOwnStrategy
    case LearnMore
    case Yield
    case RiskLow
    case RiskMedium
    case RiskHigh
    case ChooseThisStrategy
    case Safe
    case Indermediate
    case Bold
    //
    //MARK: - Portfolio Home
    case Portfolio
    case completeAccountToStartInvesting
    case stepCompleted
    case CreateAnAccount
    case FillPersonalData
    case VerifyYourIdentity
    case MakeYourFirstInvesment
    case InvestMoney
    case InvestIN
    case CompleteYourAccount
    case ToStartInvesting
    case Withdraw
    case YourAssetsYourBankAccount
    case Exchange
    case TradeOneAssetAgainstAnother
    case MyAssets
    case Analytics
    case TotalEarnings
    case RecurringInvestment
    case ReturnOnInvestment
    case IntermediateStrategy
    case UpcomingPayment
    case AllAssetsAvailable
    case ViewAll
    case MyBalance
    case Infos
    case About
    case Resources
    case MarketCap
    case Volume
    case TradingActivity
    case CirculatingSupply
    case ShareOfCryptoMarket
    case Popularity
    case Balance
    case ROI
    case AnnualPercentage
    case Historique
    case History
    case Bought
    
    //MARK: - Personal Info
    case PersonalData
    case ForLegalReasons
    case FirstName
    case CardholderName
    case LastName
    case BirthDate
    case BirthPlace
    case BirthCountry
    case AreYouAUSCitizen
    case Yes
    case No
    case Nationality
    case SelectBirthDate
    case Done
    case Cancel
    
    case AddressEmail
    case informtionUsed
    case Email
    
    case VérificationEmail
    case weHaveSentEmailTo
    case CheckYourMailbox
    case OpenAppleMail
    case OpenGmail
    case ResendEmail
    
    case Address
    case toEnsureCryptoServicesAreLegal
    case StreetNumber
    case BuildingFloor
    case City
    case State
    case ZIPCode
    case Country
    
    case InvestmentExperience
    case mustAnswerTheseQuestions
    case investExperienceWithCryptos
    case Choose
    case YourSourceOfIncome
    case YourWorkIndustry
    case YourAnnualIncome
    case YourPersonalAssets
    case HowManyPersonalAssetsYouHave
    case SendtoLyber
    
    case WhatYourInvestmentExperienceWithCryptos
    case IHaveNeverInvested
    case lessThan1000€
    case between1000€and9999€
    case Between10000€And99999€
    case greaterThan100000€
    
    case WhatYourSourceOfIncome
    case Salary
    case Investments
    case Savings
    case Inheritance
    case CreditLoan
    case FamillyOthers
    
    case WhatYourWorkIndustry
    case Agriculture
    case ArtsMedia
    case CasinosGames
    case Building
    case Defense
    case Entertainement
    case Education
    case Energy
    case MediaTV
    case NewTechnologies
    
    case WhatSalaryRangeYouFallInto
    case Lessthan800€PerMonth
    case between801and1100€PerMonth
    case between1101and2000€PerMonth
    case between2001and4000€PerMonth
    case between4001and10000€PerMonth
    case Over10001€PerMonth
    
    case IdentityVerification
    case stepsProtectYouFromFraudsAndTheft
    case TakePictureOfYourPapers
    case NationalIDCardPassportOrDrivingLicense
    case TakeASelfie
    case OpenCamera
    case Camera
    case SelectFromGallery
    case SetDefaultPictures
    case SendPicturesToLyber
    case Start
    case EditPersonalData
    case WelcometoLyber
    case LetVerifyYourIdentity
    case VerificationInProgress
    
    
    //MARK: - Invest money
    case UsingMyStrategy
    case InvestUsingMyStrategy
    case MakeInvestment
    case PickAnotherStrategy
    case DepositSingularBuy
    case InvestInStrategiesOrSingleAsset
    case investWithStrategies
    case InvestInMyStrat
    case InvestInStrategies
    case BuildYourOwnStrategy
    case InvestInSingleAsset
    case ChooseAmong80DifferentAssets
    case InvestIn
    case CreditCard
    case AddAFrequency
    case PreviewMyInvestment
    case Monthly
    case ConfirmInvestment
    case ConfirmExchange
    case ConfirmMyDeposit
    case ConfirmDeposit
    case Amount
    case Frequency
    case Payment
    case Buy
    case Sell
    case LyberFees
    case Total
    case price
    case priceOfCryptoCurrencyIsvolatile
    case EuroDesposit
    case PreviewDeposit
    case chooseAnAsset
    case InvestOnSingleAsset
    case MoneyDeposit
    case WithoutGoingThroughMyStrategy
    case InEurosFromMyBankAccount
    case ApplePay
    case BankAccount
    case AddBankAccount
    case AddCreditCard
    case LimitedTo25000€PerWeek
    case LimitedTo1000€PerWeek
    case PayWith
    case Max
    case Once
    case UniqueInvestment
    case Daily
    case Everyday
    case Weekly
    case EveryThursday
    case Every21stOfTheMonth
    case Recommended
    case Deposit
    case DepositFIAT
    case MoneyToLyber
    case DepositFees
    
    //SWAP WITHDRAW
    case WithdrawOrExchange
    case ExchangeFrom
    case LyberPortfolio
    case From
    case To
    case PreviewExchange
    case AvailableFlAT
    case ExchangeTo
    case IWantToWithdraw
    case AllMyPortfolio
    case APreciseAsset
    case WithdrawFrom
    case WithdrawTo
    case WithdrawAllMyPortfolio
    case PreviewWithdraw
    case Paypal
    case ManageYourAssets
    case depositFunds
    case bankAccountDetails
    case pleaseDepositMoneyInMentioned
    case IBANumber
    case BICNumber
    case yourAmountWillReflected
    case OneTimeInvestment
    case ExecuteStrategySingleTime
    case AdjustInvestment
    case ChangeFrequencyAmount
    case TailorStrategy
    case ChangeAssetRepartition
    case PauseStrategy
    case DeleteStrategy
    case RecurrentInvestment
    case ExecuteStrategyRegularBasis
    
    //MARK: - Profile
    case Transaction
    case Exch
    case Withdrawal
    case PaymentMethod
    case AddPaymentMethod
    case Account
    case Currency
    case PhoneNumber
    case Notifications
    case ExtractDocuments
    case Security
    case StrongAuthentification
    case ChangePin
    case FaceID
    case LogOut
    case ListOfAllTransactions
    case UsedOnlyForWithdrawals
    case CardNumber
    case Expire
    case CVV
    case Add
    case ByAddingNewCardYouAcceptTermsConditions
    
    //MARK: - Strong Authentication
    case forAddedSecurityOnLyberAccount
    case BySMS
    case ManageApplicationCasesOfSMSAuthentication
    case ValidateWithdrawal
    case EnableDisablewhitelisting
    case EditAccount
    case CryptoAdressBook
    case viewAndAddfavouriteCryptoAddressesHere
    case Whitelisting
    case Search
    case AddACryptoAdress
    case EditCryptoAdress
    case AdressName
    case Network
    case NameMYAddress
    case EnterOrScanAnAddress
    case Adress
    case Origin
    case Wallet
    case SelectExchange
    case enterValidAddress
    case ImportantNote
    case yourNoteGoesHere
    case AddAdress
    case EditAdress
    case EnableWhitelisting
    case DisableWhitelisting
    case WhitelistingIsFeatureThatLimitsWithdrawls
    case ExtraSecurity
    case Hours
    case NoExtraSecurity
    case AllowYouToBlockTheAdditionOfAddress
    case ActiveDuring
    case AddNewAdress
    case Disabled
    case Enabled
    case disabled
    case enabled
    case AddAndUseThisAdress
    case CryptoAssetDeposit
    case DepositAdress
    case sendOnlyBitcoin
    case BuyBitcoinOnLyber
    case AddPaymentMethodOrFundLyberAccount
    case FundAccount
    case FromYourBankAccount
    case AddCreditDebitCard
    case FundYourAccountFromYourBankAccount
    case makeSureNameOfBankAccount
    case LoginByEmail
    case HappyToSeeYouBack
    case EnterPhoneNumberToLogin
    case NiceToSeeYouAgain
    case enterYourEmailToLogin
    case LoginByPhone
    case Delete
    case Edit
    case Confirm
    case SelectDefaultPicture
    case SelectedProfilePicture
    
    //MARK: - Alert Messages
    case enterPhoneNumber
    case enterValidPhoneNumber
    case enterCorrectPin
    case enterFirstName
    case enterLastName
    case selectBirthDate
    case selectNationality
    case enterEmail
    case enterValidEmail
    case enterStreetNumber
    case pleaseSelectFrequency
    case enterBuildingFloor
    case enterCityName
    case enterZipcode
    case enterCountry
    case chooseInvestmentExp
    case chooseSourceOfIncome
    case chooseWorkIndustry
    case chooseAnnualIncome
    case AreYouSureLogOut
    
}




extension L10n: CustomStringConvertible{
    var description: String{ return self.string }
    
    var string: String{
        switch self {
        case .lyberReInvented:
            return L10n.tr("Lyber, investments reinvented")
        case .diversifiedRegularSimple:
            return L10n.tr("Diversified. Regular. Simple.")
        case .SignUp:
            return L10n.tr("Sign up")
        case .LogIn:
            return L10n.tr("Log in")
        case .YourPhoneNumber:
            return L10n.tr("Your phone number")
        case .enterPhoneDescription:
            return L10n.tr("For security reasons, we need your phone number. We’ll send you a confirmation code by message.")
        case .Next:
            return L10n.tr("Next")
        case .EnterCode:
            return L10n.tr("Enter code")
        case .confirmationCode:
            return L10n.tr("We’ve sent you a confirmation code.")
        case .resendCodeWillBeSend:
            return L10n.tr("A new code will be sent in ")
        case .ResendCode:
            return L10n.tr("Resend Code")
        case .CreatePIN:
            return L10n.tr("Create a PIN")
        case .fourDigitCode:
            return L10n.tr("Secure your account by creating a 4 digit code.")
        case .ConfirmPIN:
            return L10n.tr("Confirm PIN")
        case .EnableNotifications:
            return L10n.tr("Enable notifications")
        case .Activate:
            return L10n.tr("Activate")
        case .ActivateFaceID:
            return L10n.tr("Activate Face ID")
        case .AccessLyberFaceID:
            return L10n.tr("Access Lyber fast and easily by logging with Face ID.")
        case .Decline:
            return L10n.tr("Decline")
        case .AskMeLater:
            return L10n.tr("Ask me later")
        case .dontMissAnyUpdate:
            return L10n.tr("Enable notifications so you don't miss any updates from Lyber.")
        case .NotNow:
            return L10n.tr("Not now")
            
            //MARK: - Education Strategy
        case .DiversifiedStrategy:
            return L10n.tr("A diversified strategy")
        case .flexibleFrequency:
            return L10n.tr("A flexible frequency")
        case .EvolvingAndAutomatedPortfolio:
            return L10n.tr("An evolving and automated portfolio")
        case .educationSubDescription1:
            return L10n.tr("Choose an investment strategy according to your risk profile. The allocation to crypto-currencies or FIAT will depend on your selection.")
        case .educationSubDescription2:
            return L10n.tr("Investing the same amount regularly is the best way to see profits. Every week, every month, it's up to you.")
        case .educationSubDescription3:
            return L10n.tr("Once the regular investment is set, your portfolio will be managed automatically and you will be able to see its evolution.")
        case .ChooseAStrategy:
            return L10n.tr("Choose a strategy")
            
            
            //MARK: - Own strategy
        case .BuildMyOwnStrategy:
            return L10n.tr("Build my own strategy")
        case .AddManyAssetsAsYouWish:
            return L10n.tr("Add as many assets as you wish and choose their respective allocation.")
        case .AddAnAsset:
            return L10n.tr("Add an asset")
        case .SauvegarderMaStratégie:
            return L10n.tr("Sauvegarder ma stratégie")
        case .VousDevezAjouter:
            return L10n.tr("Vous devez ajouter un asset minimum pour créer votre stratégie.")
        case .Trending:
            return L10n.tr("Trending")
        case .TopGainers:
            return L10n.tr("Top gainers")
        case .TopLoosers:
            return L10n.tr("Top loosers")
        case .Stable:
            return L10n.tr("Stable")
        case .Bitcoin:
            return L10n.tr("Bitcoin")
        case .BTC:
            return L10n.tr("BTC")
        case .Ether:
            return L10n.tr("Ether")
        case .ETH:
            return L10n.tr("ETH")
        case .Dogecoin:
            return L10n.tr("Dogecoin")
        case .DOGE:
            return L10n.tr("DOGE")
        case .Solana:
            return L10n.tr("Solana")
        case .SOL:
            return L10n.tr("SOL")
        case .USDC:
            return L10n.tr("USDC")
        case .ADA:
            return L10n.tr("ADA")
        case .LUNA:
            return L10n.tr("LUNA")
        case .XND:
            return L10n.tr("XND")
        case .MATIC:
            return L10n.tr("MATIC")
        case .ViewAllAvailableAssets:
            return L10n.tr("View all 16 available assets")
        case .Allocation:
            return L10n.tr("Allocation")
        case .Auto:
            return L10n.tr("Auto")
        case .SaveMyStrategy:
            return L10n.tr("Save my strategy")
        case .YourStrategyReadyToBeSaved:
            return L10n.tr("Your stratégy is ready to be saved.")
        case .asset:
            return L10n.tr("asset")
        case .assets:
            return L10n.tr("assets")
        case .AllAssets:
            return L10n.tr("All assets")
        case .Proportion:
            return L10n.tr("Proportion")
        case .SetThisProportion:
            return L10n.tr("Set this proportion")
        case .SetThisAllocation:
            return L10n.tr("Set this allocation")
        case .yourAllocationIsGreaterThan:
            return L10n.tr("Your allocation is greater than 100%,remove ")
        case .yourAllocationIslessThan:
            return L10n.tr("Your allocation is less than 100%,add ")
        case .InvestmentStrategies:
            return L10n.tr("Investment strategies")
        case .strategiesAreThereToHelpYou:
            return L10n.tr("The strategies are there to help you dilute your investments over several assets.")
        case .MyOwnStrategy:
            return L10n.tr("My own strategy")
        case .LearnMore:
            return L10n.tr("Learn more ...")
        case .Yield:
            return L10n.tr("Yield: ")
        case .RiskLow:
            return L10n.tr("Risk: ")
        case .RiskMedium:
            return L10n.tr("Risk: Medium")
        case .RiskHigh:
            return L10n.tr("Risk: High")
        case .ChooseThisStrategy:
            return L10n.tr("Choose this strategy")
        case .Safe:
            return L10n.tr("Safe")
        case .Indermediate:
            return L10n.tr("Indermediate")
        case .Bold:
            return L10n.tr("Bold")
            //        case .RiskLow:
            //            return L10n.tr("Risk: Low")
            //        case .RiskLow:
            //            return L10n.tr("Risk: Low")
            //        case .RiskLow:
            //            return L10n.tr("Risk: Low")
            //        case .RiskLow:
            //            return L10n.tr("Risk: Low")
            //        case .RiskLow:
            //            return L10n.tr("Risk: Low")
            
            
            
            //MARK: - Portfolio Home
            
        case .Portfolio:
            return L10n.tr("Portfolio")
        case .completeAccountToStartInvesting:
            return L10n.tr("Complete your account to start investing")
        case .stepCompleted:
            return L10n.tr("step completed")
        case .CreateAnAccount:
            return L10n.tr("Create an account")
        case .FillPersonalData:
            return L10n.tr("Fill personal data")
        case .VerifyYourIdentity:
            return L10n.tr("Verify your identity")
        case .MakeYourFirstInvesment :
            return L10n.tr("Make your first invesment")
        case .InvestMoney:
            return L10n.tr("Invest money")
        case .InvestIN:
            return L10n.tr("Invest in ")
        case .CompleteYourAccount:
            return L10n.tr("Complete your account")
        case .ToStartInvesting:
            return L10n.tr("To start investing")
        case .Withdraw:
            return L10n.tr("Withdraw")
        case .YourAssetsYourBankAccount:
            return L10n.tr("Send assets to your bank account")
        case .Exchange:
            return L10n.tr("Exchange")
        case .TradeOneAssetAgainstAnother:
            return L10n.tr("Trade one asset for another")
        case .MyAssets:
            return L10n.tr("My assets")
        case .Analytics:
            return L10n.tr("Analytics")
        case .TotalEarnings:
            return L10n.tr("Total earnings")
        case .RecurringInvestment:
            return L10n.tr("Recurring investment")
        case .ReturnOnInvestment:
            return L10n.tr("Return on Investment")
        case .IntermediateStrategy:
            return L10n.tr("Intermediate strategy")
        case .UpcomingPayment:
            return L10n.tr("Upcoming payment : April 27")
        case .AllAssetsAvailable:
            return L10n.tr("All assets available")
        case .ViewAll:
            return L10n.tr("View all")
        case .MyBalance:
            return L10n.tr("My balance")
        case .Infos:
            return L10n.tr("Infos")
        case .About:
            return L10n.tr("About")
        case .Resources:
            return L10n.tr("Resources")
        case .MarketCap:
            return L10n.tr("Market cap")
        case .Volume:
            return L10n.tr("Volume")
        case .TradingActivity:
            return L10n.tr("Trading activity")
        case .CirculatingSupply:
            return L10n.tr("Circulating supply")
        case .ShareOfCryptoMarket:
            return L10n.tr("Share of crypto market")
        case .Popularity:
            return L10n.tr("Popularity")
        case .Balance:
            return L10n.tr("Balance")
        case .ROI:
            return L10n.tr("ROI")
        case .AnnualPercentage:
            return L10n.tr("*Annual Percentage")
        case .Historique:
            return L10n.tr("Historique")
        case .History:
            return L10n.tr("History")
        case .Bought:
            return L10n.tr("Bought ")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            //        case .ROI:
            //            return L10n.tr("ROI")
            
            
            
            //MARK: - Personal Info
        case .PersonalData :
            return L10n.tr("Personal data")
        case .ForLegalReasons:
            return L10n.tr("For legal reasons, we need you to answer some questions and provide us with personal information.")
        case .FirstName:
            return L10n.tr("First name")
        case .CardholderName:
            return L10n.tr("Cardholder's name")
        case .LastName:
            return L10n.tr("Last name")
        case .BirthDate:
            return L10n.tr("Birth date")
        case .BirthPlace:
            return L10n.tr("Birth Place")
        case .BirthCountry:
            return L10n.tr("Birth Country")
        case .AreYouAUSCitizen:
            return L10n.tr("Are you a US Citizen?")
        case .Yes:
            return L10n.tr("Yes")
        case .No:
            return L10n.tr("No")
        case .Nationality:
            return L10n.tr("Nationality")
        case .SelectBirthDate:
            return L10n.tr("Select Birth Date")
        case .Done:
            return L10n.tr("Done")
        case .Cancel:
            return L10n.tr("Cancel")
            
        case .AddressEmail:
            return L10n.tr("Address email")
        case .informtionUsed:
            return L10n.tr("This information will be used for security purposes and to confirm your transactions.")
        case .Email:
            return L10n.tr("Email")
            
        case .VérificationEmail:
            return L10n.tr("Email verification")
        case .weHaveSentEmailTo:
            return L10n.tr("We have sent an email to ")
        case .CheckYourMailbox:
            return L10n.tr("Check your mailbox and click on the confirmation link to continue.")
        case .OpenAppleMail:
            return L10n.tr("Open Apple Mail")
        case .OpenGmail:
            return L10n.tr("Open Gmail")
        case .ResendEmail:
            return L10n.tr("RESEND EMAIL")
            
        case .Address:
            return L10n.tr("Address")
        case .toEnsureCryptoServicesAreLegal:
            return L10n.tr("We need this information to ensure that crypto services are legal in your country of residence.")
        case .StreetNumber:
            return L10n.tr("Street number")
        case .BuildingFloor:
            return L10n.tr("Building, floor")
        case .City:
            return L10n.tr("City")
        case .State:
            return L10n.tr("State")
        case .ZIPCode:
            return L10n.tr("ZIP code")
        case .Country:
            return L10n.tr("Country")
            
        case .InvestmentExperience:
            return L10n.tr("Investment experience")
        case .mustAnswerTheseQuestions:
            return L10n.tr("You must answer these questions within the \nlegal framework of international investment \nregulations.")
        case .investExperienceWithCryptos:
            return L10n.tr("Your investment experience with cryptos")
        case .Choose:
            return L10n.tr("Choose")
        case .YourSourceOfIncome:
            return L10n.tr("Your source of income")
        case .YourWorkIndustry:
            return L10n.tr("Your work industry")
        case .YourAnnualIncome:
            return L10n.tr("Your annual income")
        case .YourPersonalAssets:
            return L10n.tr("Your Personal Assets")
        case .HowManyPersonalAssetsYouHave:
            return L10n.tr("How many personal Assets Do you have?")
        case .SendtoLyber:
            return L10n.tr("Send to Lyber")
            
        case .WhatYourInvestmentExperienceWithCryptos:
            return L10n.tr("What’s your investment experience with cryptos ?")
        case .IHaveNeverInvested:
            return L10n.tr("I have never invested")
        case .lessThan1000€:
            return L10n.tr("< 1 000€")
        case .between1000€and9999€:
            return L10n.tr("Between 1 000€ and 9 999€")
        case .Between10000€And99999€:
            return L10n.tr("Between 10 000€ and 99 999€")
        case .greaterThan100000€:
            return L10n.tr("> 100 000€")
            
        case .WhatYourSourceOfIncome:
            return L10n.tr("What’s your source of income ?")
        case .Salary:
            return L10n.tr("Salary")
        case .Investments:
            return L10n.tr("Investments")
        case .Savings:
            return L10n.tr("Savings")
        case .Inheritance:
            return L10n.tr("Inheritance")
        case .CreditLoan:
            return L10n.tr("Credit/loan")
        case .FamillyOthers:
            return L10n.tr("Familly or others")
            
        case .WhatYourWorkIndustry:
            return L10n.tr("What’s your work industry ?")
        case .Agriculture:
            return L10n.tr("Agriculture")
        case .ArtsMedia:
            return L10n.tr("Arts & Media")
        case .CasinosGames:
            return L10n.tr("Casinos & games")
        case .Building:
            return L10n.tr("Building")
        case .Defense:
            return L10n.tr("Defense")
        case .Entertainement:
            return L10n.tr("Entertainement")
        case .Education:
            return L10n.tr("Education")
        case .Energy:
            return L10n.tr("Energy")
        case .MediaTV:
            return L10n.tr("Media & TV")
        case .NewTechnologies:
            return L10n.tr("New technologies")
            
        case .WhatSalaryRangeYouFallInto:
            return L10n.tr("What salary range do you fall into ?")
        case .Lessthan800€PerMonth:
            return L10n.tr("Less than 800€/month")
        case .between801and1100€PerMonth:
            return L10n.tr("801 - 1100€/month")
        case .between1101and2000€PerMonth:
            return L10n.tr("1101 - 2000€/month")
        case .between2001and4000€PerMonth:
            return L10n.tr("2001 - 4000€/month")
        case .between4001and10000€PerMonth:
            return L10n.tr("4000 - 10 000€/month")
        case .Over10001€PerMonth:
            return L10n.tr("Over 10 001€/month")
            
        case .IdentityVerification:
            return L10n.tr("Identity verification")
        case .stepsProtectYouFromFraudsAndTheft:
            return L10n.tr("This step protects you from fraud and identity theft. Use your phone to:")
        case .TakePictureOfYourPapers:
            return L10n.tr("Take a picture of your documents")
        case .NationalIDCardPassportOrDrivingLicense:
            return L10n.tr("National ID card, passport or driving licence")
        case .TakeASelfie:
            return L10n.tr("Take a selfie")
        case .OpenCamera:
            return L10n.tr("Open camera")
        case .Camera:
            return L10n.tr("Camera")
        case .SelectFromGallery:
            return L10n.tr("Select from gallery")
        case .SetDefaultPictures:
            return L10n.tr("Set default pictures")
        case .SendPicturesToLyber:
            return L10n.tr("Send pictures to Lyber")
        case .Start:
            return L10n.tr("Start")
        case .EditPersonalData:
            return L10n.tr("Edit Personal Data")
        case .WelcometoLyber:
            return L10n.tr("Welcome to Lyber")
        case .LetVerifyYourIdentity:
            return L10n.tr("Let's verify your identity.")
        case .VerificationInProgress:
            return L10n.tr("Verification in progress")
            
        //MARK: - Invest money
            
        case .UsingMyStrategy:
            return L10n.tr("Using my strategy")
        case .InvestUsingMyStrategy:
            return L10n.tr("Invest using my strategy")
        case .MakeInvestment:
            return L10n.tr("Make Investment")
        case .PickAnotherStrategy:
            return L10n.tr("Pick another strategy")
        case .DepositSingularBuy:
            return L10n.tr("Deposit or singular buy")
        case .InvestInStrategiesOrSingleAsset:
            return L10n.tr("Invest in Strategies or a Single \nAsset")
        case .investWithStrategies:
            return L10n.tr("Invest with strategies")
        case .InvestInMyStrat:
            return L10n.tr("Invest in my strat.")
        case .InvestInStrategies:
            return L10n.tr("Invest in strategies")
        case .BuildYourOwnStrategy:
            return L10n.tr("Build your own strategy")
        case .InvestInSingleAsset:
            return L10n.tr("Invest in a single asset")
        case .ChooseAmong80DifferentAssets:
            return L10n.tr("Choose among 80 different assets")
        case .InvestIn:
            return L10n.tr("Invest in ")
        case .CreditCard:
            return L10n.tr("Credit card")
        case .AddAFrequency:
            return L10n.tr("Add a frequency")
        case .PreviewMyInvestment:
            return L10n.tr("Preview my investment")
        case .Monthly:
            return L10n.tr("Monthly")
        case .ConfirmInvestment:
            return L10n.tr("Confirm investment")
        case .ConfirmExchange:
            return L10n.tr("Confirm exchange")
        case .ConfirmMyDeposit:
            return L10n.tr("Confirm my deposit")
        case .ConfirmDeposit:
            return L10n.tr("Confirm deposit")
        case .Amount:
            return L10n.tr("Amount")
        case .Frequency:
            return L10n.tr("Frequency")
        case .Payment:
            return L10n.tr("Payment")
        case .Buy:
            return L10n.tr("Buy")
        case .Sell:
            return L10n.tr("Sell")
        case .LyberFees:
            return L10n.tr("Lyber fees")
        case .Total:
            return L10n.tr("Total")
        case .price:
            return L10n.tr("Price")
        case .priceOfCryptoCurrencyIsvolatile:
            return L10n.tr("The price of cryptocurrencies is volatile. The value of your investment can go up, down or to zero.")
        case .EuroDesposit:
            return L10n.tr("Euro desposit")
        case .PreviewDeposit:
            return L10n.tr("Preview deposit")
        case .chooseAnAsset:
            return L10n.tr("Choose an asset")
        case .InvestOnSingleAsset:
            return L10n.tr("Invest on a single asset")
        case .MoneyDeposit:
            return L10n.tr("Money deposit")
        case .WithoutGoingThroughMyStrategy:
            return L10n.tr("Without going through my strategy")
        case .InEurosFromMyBankAccount:
            return L10n.tr("In Euros, from my bank account")
        case .ApplePay:
            return L10n.tr("Apple pay")
        case .BankAccount:
            return L10n.tr("Bank account")
        case .AddBankAccount:
            return L10n.tr("Add a bank account")
        case .AddCreditCard:
            return L10n.tr("Add a credit card")
        case .LimitedTo25000€PerWeek:
            return L10n.tr("Limited to 25 000€ per week")
        case .LimitedTo1000€PerWeek:
            return L10n.tr("Limited to 1000€ per week")
        case .PayWith:
            return L10n.tr("Pay with")
        case .Max:
            return L10n.tr("€ Max.")
        case .Once:
            return L10n.tr("Once")
        case .UniqueInvestment:
            return L10n.tr("Unique investment")
        case .Daily:
            return L10n.tr("Daily")
        case .Everyday:
            return L10n.tr("Everyday")
        case .Weekly:
            return L10n.tr("Weekly")
        case .EveryThursday:
            return L10n.tr("Every thursday")
        case .Every21stOfTheMonth:
            return L10n.tr("Every 21st of the month")
        case .Recommended:
            return L10n.tr("Recommended")
        case .Deposit:
            return L10n.tr("Deposit")
        case .DepositFIAT:
            return L10n.tr("Deposit FIAT")
        case .MoneyToLyber:
            return L10n.tr("Add money on Lyber")
        case .DepositFees:
            return L10n.tr("Deposit fees")
            
            //SWAP WITHDRAW
        case .WithdrawOrExchange:
            return L10n.tr("Withdraw or exchange")
        case .ExchangeFrom:
            return L10n.tr("Exchange → From")
        case .LyberPortfolio:
            return L10n.tr("Lyber portfolio")
        case .From:
            return L10n.tr("From")
        case .To:
            return L10n.tr("To")
        case .PreviewExchange:
            return L10n.tr("Preview exchange")
        case .AvailableFlAT:
            return L10n.tr("Available FlAT")
        case .ExchangeTo:
            return L10n.tr("Exchange → To")
        case .IWantToWithdraw:
            return L10n.tr("I want to withdraw")
        case .AllMyPortfolio:
            return L10n.tr("All my portfolio")
        case .APreciseAsset:
            return L10n.tr("A precise asset")
        case .WithdrawFrom:
            return L10n.tr("Withdraw from ")
        case .WithdrawTo:
            return L10n.tr("Withdraw → To")
        case .WithdrawAllMyPortfolio:
            return L10n.tr("Withdraw all my portfolio")
        case .PreviewWithdraw:
            return L10n.tr("Preview withdraw")
        case .Paypal:
            return L10n.tr("Paypal")
        case .ManageYourAssets:
            return L10n.tr("Manage your assets")
        case .depositFunds:
            return L10n.tr("Deposit Funds")
        case .bankAccountDetails:
            return L10n.tr("Bank Account Details")
        case .pleaseDepositMoneyInMentioned:
            return L10n.tr("Please deposit money in the below mentioned account details.")
        case .IBANumber:
            return L10n.tr("IBAN number")
        case .BICNumber:
            return L10n.tr("BIC number")
        case .yourAmountWillReflected:
            return L10n.tr("Your amount will be reflected in the wallet in 30 minutes.")
        case .OneTimeInvestment:
            return L10n.tr("One-Time Investment")
        case .ExecuteStrategySingleTime:
            return L10n.tr("Execute a strategy a single time")
        case .AdjustInvestment:
            return L10n.tr("Adjust Investment")
        case .ChangeFrequencyAmount:
            return L10n.tr("Change frequency and amount")
        case .TailorStrategy:
            return L10n.tr("Tailor Strategy")
        case .ChangeAssetRepartition:
            return L10n.tr("Change asset repartition")
        case .PauseStrategy:
            return L10n.tr("Pause Strategy")
        case .DeleteStrategy:
            return L10n.tr("Delete Strategy")
        case .RecurrentInvestment:
            return L10n.tr("Recurrent Investment")
        case .ExecuteStrategyRegularBasis:
            return L10n.tr("Execute a strategy a regular basis")
        
            
            
            //MARK: - Profile
        case .Transaction:
            return L10n.tr("Transaction")
        case .Exch:
            return L10n.tr("Exch. ")
        case .Withdrawal:
            return L10n.tr("Withdrawal")
        case .PaymentMethod:
            return L10n.tr("Payment method")
        case .AddPaymentMethod:
            return L10n.tr("Add payment method")
        case .Account:
            return L10n.tr("Account")
        case .Currency:
            return L10n.tr("Currency")
        case .PhoneNumber:
            return L10n.tr("Phone number")
        case .Notifications:
            return L10n.tr("Notifications")
        case .ExtractDocuments:
            return L10n.tr("Extract documents")
        case .Security:
            return L10n.tr("Security")
        case .StrongAuthentification:
            return L10n.tr("Strong authentification")
        case .ChangePin:
            return L10n.tr("Change Pin")
        case .FaceID:
            return L10n.tr("Face ID")
        case .LogOut:
            return L10n.tr("Log out")
        case .ListOfAllTransactions:
            return L10n.tr("List of all transactions (purchase, exchange or withdrawal) made on your account.")
        case .UsedOnlyForWithdrawals:
            return L10n.tr("Used only for withdrawals")
        case .CardNumber:
            return L10n.tr("Card number")
        case .Expire:
            return L10n.tr("Expire")
        case .CVV:
            return L10n.tr("CVV")
        case .Add:
            return L10n.tr("Add")
        case .ByAddingNewCardYouAcceptTermsConditions:
            return L10n.tr("By adding a new card, you accept the terms and conditions.")
        
            //MARK: - Strong Authentication
        case .forAddedSecurityOnLyberAccount:
            return L10n.tr("For added security on your Lyber account, enable strong authentication. ")
        case .BySMS:
            return L10n.tr("By SMS")
        case .ManageApplicationCasesOfSMSAuthentication:
            return L10n.tr("Manage the application cases of SMS authentication")
        case .ValidateWithdrawal:
            return L10n.tr("Validate a withdrawal")
        case .EnableDisablewhitelisting:
            return L10n.tr("Enable/Disable whitelisting")
        case .EditAccount:
            return L10n.tr("Edit account")
        case .CryptoAdressBook:
            return L10n.tr("Crypto address book")
        case .viewAndAddfavouriteCryptoAddressesHere:
            return L10n.tr("View and add your favorite crypto addresses here, you can also enable Whitelisting for these addresses.")
        case .Whitelisting:
            return L10n.tr("Whitelisting")
        case .Search:
            return L10n.tr("Search")
        case .AddACryptoAdress:
            return L10n.tr("Add a crypto address")
        case .EditCryptoAdress:
            return L10n.tr("Edit crypto address")
        case .AdressName:
            return L10n.tr("Address name")
        case .Network:
            return L10n.tr("Network")
        case .NameMYAddress:
            return L10n.tr("Name my address")
        case .EnterOrScanAnAddress:
            return L10n.tr("Enter or scan an address")
        case .Adress:
            return L10n.tr("Adress")
        case .Origin:
            return L10n.tr("Origin")
        case .Wallet:
            return L10n.tr("Wallet")
        case .SelectExchange:
            return L10n.tr("Select exchange")
        case .enterValidAddress:
            return L10n.tr("Please enter valid address")
        case .ImportantNote:
            return L10n.tr("Important note: ")
        case .yourNoteGoesHere:
            return L10n.tr("Your note goes here and goes on a big amount of line")
        case .AddAdress:
            return L10n.tr("Add address")
        case .EditAdress:
            return L10n.tr("Edit address")
        case .EnableWhitelisting:
            return L10n.tr("Enable whitelisting")
        case .DisableWhitelisting:
            return L10n.tr("Disable whitelisting")
        case .WhitelistingIsFeatureThatLimitsWithdrawls:
            return L10n.tr("Whitelisting is a feature that limits your withdrawals and deposits to addresses in your Lyber address book.")
        case .ExtraSecurity:
            return L10n.tr("Extra security")
        case .Hours:
            return L10n.tr("Hours")
        case .NoExtraSecurity:
            return L10n.tr("No extra security")
        case .AllowYouToBlockTheAdditionOfAddress:
            return L10n.tr("Allows you to block the addition of new addresses during a given period (effective 4H after its activation).")
        case .ActiveDuring:
            return L10n.tr("Active during : ")
        case .AddNewAdress:
            return L10n.tr("Add a new address")
        case .Disabled:
            return L10n.tr("Disabled")
        case .Enabled:
            return L10n.tr("Enabled")
        case .disabled:
            return L10n.tr("disabled")
        case .enabled:
            return L10n.tr("enabled")
        case .AddAndUseThisAdress:
            return L10n.tr("Add and use this adress")
        case .CryptoAssetDeposit:
            return L10n.tr("Crypto asset deposit")
        case .DepositAdress:
            return L10n.tr("Deposit adress")
        case .sendOnlyBitcoin:
            return L10n.tr("Send only Bitcoin (BTC) to this address, using the native Bitcoin protocol.")
        case .BuyBitcoinOnLyber:
            return L10n.tr("Buy Bitcoin on Lyber")
        case .AddPaymentMethodOrFundLyberAccount:
            return L10n.tr("Add payment method or fund your Lyber account")
        case .FundAccount:
            return L10n.tr("Fund account")
        case .FromYourBankAccount:
            return L10n.tr("From your bank account")
        case .AddCreditDebitCard:
            return L10n.tr("Add a credit/debit card")
        case .FundYourAccountFromYourBankAccount:
            return L10n.tr("Fund your account from your bank account")
        case .makeSureNameOfBankAccount:
            return L10n.tr("Make sure the name of the bank account is the same as your name on Lyber (Frida Kahlo).")
        case .LoginByEmail:
            return L10n.tr("Login by email")
        case .HappyToSeeYouBack:
            return L10n.tr("Happy to see you back!")
        case .EnterPhoneNumberToLogin:
            return L10n.tr("Enter your phone number to login, we’ll send you a verification code.")
        case .NiceToSeeYouAgain:
            return L10n.tr("Nice to see you again!")
        case .enterYourEmailToLogin:
            return L10n.tr("Enter your email to login, we’ll send you a link by email.")
        case .LoginByPhone:
            return L10n.tr("Login by phone")
        case .Delete:
            return L10n.tr("Delete")
        case .Edit:
            return L10n.tr("Edit")
        case .Confirm:
            return L10n.tr("Confirm")
        case .SelectDefaultPicture:
            return L10n.tr("Select Default Picture")
        case .SelectedProfilePicture:
            return L10n.tr("Selected Profile Picture")
            
            
            //MARK: - Alert Messages
        case .enterPhoneNumber:
            return L10n.tr("Please enter Phone number")
        case .enterValidPhoneNumber:
            return L10n.tr("Please enter valid phone number")
        case .enterCorrectPin:
            return L10n.tr("Please enter the correct pin")
        case .enterFirstName:
            return L10n.tr("Please enter first name")
        case .enterLastName:
            return L10n.tr("Please enter last name")
        case .selectBirthDate:
            return L10n.tr("Please select your birth date")
        case .selectNationality:
            return L10n.tr("Please select nationality")
        case .enterEmail:
            return L10n.tr("Please enter email address")
        case .enterValidEmail:
            return L10n.tr("Please enter valid email address")
        case .enterStreetNumber:
            return L10n.tr("Please enter street number")
        case .pleaseSelectFrequency:
            return L10n.tr("Please select frequency")
        case .enterBuildingFloor:
            return L10n.tr("Please enter building, floor number")
        case .enterCityName:
            return L10n.tr("Please enter city name")
        case .enterZipcode:
            return L10n.tr("Please enter zip code")
        case .enterCountry:
            return L10n.tr("Please enter country name")
        case .chooseInvestmentExp:
            return L10n.tr("Please choose your investment experience with Cryptos")
        case .chooseSourceOfIncome:
            return L10n.tr("Please select your source of income")
        case .chooseWorkIndustry:
            return L10n.tr("Please select your work industry")
        case .chooseAnnualIncome:
            return L10n.tr("Please Select your annual Income")
        case .AreYouSureLogOut:
            return L10n.tr("Are you sure you want to Log Out?")
        }
        
    }
    
    private static func tr(_ key: String, _ args: CVarArg...) -> String{
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, locale: NSLocale.current , arguments: args)
        //        if selectedLanguage.code == "en"{
        //            return keyValEng[key] ?? ""
        //        }else{
        //            return keyValAr[key] ?? ""
        //        }
    }
}
