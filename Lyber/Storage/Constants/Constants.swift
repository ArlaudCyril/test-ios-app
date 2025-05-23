//
//  Constants.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import Foundation

struct Constants{
    
	static let apiVersion = "0.2"
    static let deviceType = "IOS"
    static let deviceID = "df"

    struct AlertMessages{
		static var enterPhoneNumber = CommonFunctions.localisation(key:"ENTER_PHONE_NUMBER")
        static var enterValidPhoneNumber = CommonFunctions.localisation(key:"ALERT_VALID_PHONE_NUMBER")
        static var enterCorrectPin = CommonFunctions.localisation(key:"ALERT_CORRECT_PIN")
        static var enterFirstName = CommonFunctions.localisation(key:"ALERT_FIRST_NAME")
        static var enterLastName = CommonFunctions.localisation(key:"ALERT_LAST_NAME")
        static var selectBirthDate = CommonFunctions.localisation(key:"SELECT_BIRTH_DATE")
        static var selectNationality = CommonFunctions.localisation(key:"ALERT_NATIONALITY")
        static var enterEmail = CommonFunctions.localisation(key:"ALERT_EMAIL")
        static var enterValidEmail = CommonFunctions.localisation(key:"ALERT_VALID_EMAIL")
        static var enterAddress = CommonFunctions.localisation(key:"ALERT_ADDRESS")
        static var enterCity = CommonFunctions.localisation(key:"ALERT_CITY_NAME")
        static var enterZipcode = CommonFunctions.localisation(key:"ALERT_ZIP_CODE")
        static var enterCountry = CommonFunctions.localisation(key:"ALERT_COUNTRY")
        static var chooseInvestmentExp = CommonFunctions.localisation(key:"ALERT_INVESTMENT_EXP")
        static var chooseSourceOfIncome = CommonFunctions.localisation(key:"ALERT_SOURCE_INCOME")
        static var chooseWorkIndustry = CommonFunctions.localisation(key:"ALERT_WORK_INDUSTRY")
        static var chooseMonthlyIncome = CommonFunctions.localisation(key:"ALERT_MONTHLY_INCOME")
		static var chooseActivity = CommonFunctions.localisation(key:"ALERT_ACTIVITY")
        static let logOut = CommonFunctions.localisation(key:"LOG_OUT")
        static let sureLogOut = CommonFunctions.localisation(key:"ALERT_LOG_OUT")
        static let Cancel = CommonFunctions.localisation(key:"CANCEL")
        static let tooManyFailedAttemptPleaseReauthenticate = CommonFunctions.localisation(key:"TOO_MANY_FAILED_ATTEMPT_PLEASE_REAUTHENTICATE")
        
        static var enterPassword = CommonFunctions.localisation(key:"ALERT_PASSWORD")
        static var enterValidPassword = CommonFunctions.localisation(key:"ALERT_VALID_PASSWORD")
        static var enterDepartment = CommonFunctions.localisation(key:"ALERT_DEPARTMENT")
        static var enterValidZipcode = CommonFunctions.localisation(key:"ALERT_VALID_ZIPCODE")
        static var enterBirthPlace = CommonFunctions.localisation(key:"ALERT_BIRTH_PLACE")
        static var selectBirthCountry = CommonFunctions.localisation(key:"ALERT_BIRTH_COUNTRY")
        static var selectAreYouUSCitizen = CommonFunctions.localisation(key:"ALERT_US_CITIZEN")
        
        static var PleaseEnterYourAddressName = CommonFunctions.localisation(key:"ALERT_ADDRESS_NAME")
        static var PleaseSelectYourNetwork = CommonFunctions.localisation(key:"ALERT_NETWORK")
        static var PleaseEnterOrScanAnAddress = CommonFunctions.localisation(key:"ALERT_SCAN_ADDRESS")
        static var PleaseEnterValidAddress = CommonFunctions.localisation(key:"ALERT_VALID_ADDRESS")
        static var PleaseSelectYourExchange = CommonFunctions.localisation(key:"ALERT_EXCHANGE")
        static var PleaseEnableWhitelistingAddress = CommonFunctions.localisation(key:"ALERT_WHITELISTING")
		
		static var AllAssetsMustHaveAllocationsGreaterThan0 = CommonFunctions.localisation(key:"ASSETS_ALLOCATIONS_GREATER_0")
	}
    
    // MARK: - ALL API KEYS
    struct ApiKeys {
        // MARK:- Error Response
        static let error = "error"
        static let error_description = "error_description"
        static let message = "message"
        
        // MARK: - Login keys
        static let device_type = "device_type"
        static let device_id = "device_id"
        static let otp = "otp"
        static let withdrawalLock = "withdrawalLock"
        
        // MARK: - personal Data keys
        static let personal_info_step = "personal_info_step"
        static let name = "name"
		static let language = "language"
        static let state = "state"
        static let zip_code = "zip_code"
        static let address1 = "address1"
        static let investment_experience = "investment_experience"
        static let income_source = "income_source"

		//User
		static let action = "action"
		static let details = "details"
		static let destination = "destination"
        
        // MARK: - investment Strategy keys
        static let asset = "asset"
        static let asset_id = "asset_id"
        static let strategy_name = "strategyName"
        static let amount = "amount"
        static let asset_amount = "asset_amount"
        static let frequency = "frequency"
        static let fromAsset = "fromAsset"
        static let toAsset = "toAsset"
        static let fromAmount = "fromAmount"
        static let bundle = "bundle"
        static let strategyType = "strategyType"
        static let share = "share"
        static let owner_uuid = "ownerUuid"
        static let payment_intent_id = "paymentIntentId"
        static let user_uuid = "userUuid"
        static let orderId = "orderId"
        static let executionId = "executionId"
        
        //MARK: - assets keys
        static let order = "order"
        static let page = "page"
        static let limit = "limit"
        static let offset = "offset"
        static let daily = "daily"
        
        //Profile
        static let iban = "iban"
        static let bic = "bic"
        static let network = "network"
        static let address = "address"
        static let origin = "origin"
        static let exchange = "exchange"
        static let id = "id"
        static let include_networks = "include_networks"
        static let avatar = "avatar"
        
        // MARK: - New Login keys
        static let phoneNo = "phoneNo"
        static let countryCode = "countryCode"
        static let signature = "signature"
        static let timestamp = "timestamp"
        static let code = "code"
        static let method = "method"
        static let A = "A"
        static let M1 = "M1"
        static let refresh_token = "refresh_token"
        
        // MARK: - New personal Data keys
        static let phone = "phone"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let birthPlace = "birthPlace"
        static let birthDate = "birthDate"
        static let date = "date"
        static let birthCountry = "birthCountry"
        static let nationality = "nationality"
        static let isUSCitizen = "isUSCitizen"
        static let email = "email"
        static let emailVerifier = "emailVerifier"
        static let emailSalt = "emailSalt"
        static let phoneSalt = "phoneSalt"
        static let phoneVerifier = "phoneVerifier"
        static let streetNumber = "streetNumber"
        static let street = "street"
        static let city = "city"
        static let stateOrProvince = "stateOrProvince"
        static let zipCode = "zipCode"
        static let country = "country"
        static let investmentExperience = "investmentExperience"
        static let incomeSource = "incomeSource"
        static let occupation = "occupation"
        static let incomeRange = "incomeRange"
        static let mainUse = "mainUse"
        static let requestHash = "requestHash"
        static let keyId = "keyId"
        static let challenge = "challenge"
        static let attestation = "attestation"
        
        // MARK: - Profile keys
        static let type2FA = "type2FA"
        static let googleOtp = "googleOtp"
		
		// MARK: - User keys
        static let scope2FA = "scope2FA"
        
        //MARK: Others
        static let userName = "userName"
        static let bankCountry = "bankCountry"
		static let ribId = "ribId"
        
    }
    
    // MARK: - Requested URL Keys
    // Delete this
    struct ApiUrlKeys {
        static let userInvestEducation = "user/invest/education"
        static let userSellCrypto = "user/sell-crypto"
        static let userAssets = "user/assets"
        static let userBankInfo = "user/bank-info"
		
        //MARK: - New Routes
        
        //SignUp
        static let userSetPhone = "user-service/set-phone"
        static let userVerifyPhoneNo = "user-service/verify-phone"
        static let userSetUserInfo = "user-service/set-user-info"
        static let userSetUserAddress = "user-service/set-user-address"
        static let userInvestmentExperience = "user-service/set-user-investment-experience"
        static let setEmailAndPassword = "user-service/set-email-and-password"
        static let userVerifyEmail = "user-service/verify-email"
        static let finishRegistration = "user-service/finish-registration"
        static let kycServiceKyc = "kyc-service/kyc"
        static let kycServiceSignUrl = "kyc-service/sign-url"
		
        
        //Login
        static let userChallenge = "user-service/challenge"
        static let userLogin = "user-service/login"
        
        
        //Detail Page
        static let newsService = "news-service/news"
        static let assetServiceAsset = "asset-service/asset"
        
        //Price
        static let priceServiceResume = "price-service/resume"
        static let priceServicePrice = "price-service/price"
        static let priceServiceLastPrice = "price-service/lastPrice"
        
        //User
        static let userServiceUser = "user-service/user"
        static let assetServiceAssets = "asset-service/assets"
        static let userServiceGoogleOtp = "user-service/google-otp"
        static let userServiceVerify2FA = "user-service/verify-2FA"
		static let userServiceTwoFaOtp = "user-service/2fa-otp"
		static let userServiceTransactions = "user-service/transactions"
		static let userServiceForgot = "user-service/forgot"
		static let userServiceResetPasswordIdentifiers = "user-service/reset-password-identifiers"
		static let userServiceResetPassword = "user-service/reset-password"
		static let userServiceExport = "user-service/export"
        static let userCloseAccount = "user-service/close-account"
        static let userVerifyPasswordChange = "user-service/verify-password-change"
        static let userServiceIntegrity = "user-service/integrity"
        static let userServiceAttestation = "user-service/attestation"
        
        //Strategies
        static let investmentStrategies = "strategy-service/strategies"
        static let strategyServiceStrategy = "strategy-service/strategy"
        static let strategyServiceActiveStrategy = "strategy-service/active-strategy"
        static let strategyServiceStrategyExecution = "strategy-service/strategy-execution"
       
        //Notification
        static let registerDeviceToken = "notification-service/register"
		static let notificationServiceNotifications = "notification-service/notifications"
		
		//Orders
		static let orderServiceQuote = "order-service/quote"
		static let orderServiceAcceptQuote = "order-service/accept-quote"
        static let orderServiceOrder = "order-service/order"
		static let orderServiceCancelQuote = "order-service/cancel-quote"
		
		//Wallet
		static let walletServiceAddress = "wallet-service/address"
		static let walletServiceBalance = "wallet-service/balance"
		static let walletServiceWithdrawalAddress = "wallet-service/withdrawal-address"
        static let walletServiceWithdraw = "wallet-service/withdraw"
		static let walletServiceWithdrawEuro = "wallet-service/withdraw-euro"
		static let walletServiceHistory = "wallet-service/history"
        static let walletServicePerformance = "wallet-service/performance"
        static let walletServiceRib = "wallet-service/rib"
        static let walletServiceRibs = "wallet-service/ribs"
		static let walletServiceTransferToFriend = "wallet-service/transfer-to-friend"
		
		//Network
		static let networkServiceNetworks = "network-service/networks"
		static let networkServiceNetwork = "network-service/network"
		
		//ContactForm
		static let userServiceContactSupport = "user-service/contact-support"
		
		//Change password
		static let userServicePasswordChangeChallenge = "user-service/password-change-challenge"
        static let userServicePassword = "user-service/password"
        
        //Send Phone
        static let userServiceUserByPhone = "user-service/user-by-phone"
        
    }
	
	enum Icon: String, CaseIterable {
		case BADGER = "badger"
		case BAT = "bat"
		case BEAR_HEAD = "bear_head"
		case BOAR = "boar"
		case CAT = "cat"
		case CHEETAH = "cheetah"
		case CHICK_EGG = "chick_egg"
		case CHICK_HEAD = "chick_head"
		case CHICK = "chick"
		case CHICKEN = "chicken"
		case CHIMPANZEE = "chimpanzee"
		case COW_HEAD = "cow_head"
		case COW = "cow"
		case DOG = "dog"
		case ELEPHANT = "elephant"
		case FOX = "fox"
		case FROG = "frog"
		case GIRAFFE = "giraffe"
		case GORILLA = "gorilla"
		case HAMSTER = "hamster"
		case HEDGEHOG = "hedgehog"
		case KANGAROO = "kangaroo"
		case LEO = "leo"
		case MONKEY = "monkey"
		case MOUSE = "mouse"
		case ORANGUTAN = "orangutan"
		case OWL = "owl"
		case PANDA = "panda"
		case PIG = "pig"
		case PINGUIN = "pinguin"
		case POODLE = "poodle"
		case RABBIT_HEAD = "rabbit_head"
		case RABBIT = "rabbit"
		case RACCOON = "raccoon"
		case SHIBA = "shiba"
		case SLOTH = "sloth"
		case SQUIRREL = "squirrel"
		case TIGER_CAT = "tiger_cat"
		case UNICORN = "unicorn"
		case WOLF = "wolf"
	}
	
}
