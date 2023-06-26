//
//  Constants.swift
//  Lyber
//
//  Created by sonam's Mac on 02/06/22.
//

import Foundation

struct Constants{
    
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
        static var enterStreetNumber = CommonFunctions.localisation(key:"ALERT_STREET_NUMBER")
        static var enterBuildingFloor = CommonFunctions.localisation(key:"ALERT_BUILDING_FLOOR")
        static var enterCity = CommonFunctions.localisation(key:"ALERT_CITY_NAME")
        static var enterZipcode = CommonFunctions.localisation(key:"ALERT_ZIP_CODE")
        static var enterCountry = CommonFunctions.localisation(key:"ALERT_COUNTRY")
        static var chooseInvestmentExp = CommonFunctions.localisation(key:"ALERT_INVESTMENT_EXP")
        static var chooseSourceOfIncome = CommonFunctions.localisation(key:"ALERT_SOURCE_INCOME")
        static var chooseWorkIndustry = CommonFunctions.localisation(key:"ALERT_WORK_INDUSTRY")
        static var chooseAnnualIncome = CommonFunctions.localisation(key:"ALERT_ANNUAL_INCOME")
        static let logOut = CommonFunctions.localisation(key:"LOG_OUT")
        static let sureLogOut = CommonFunctions.localisation(key:"ALERT_LOG_OUT")
        static let Cancel = CommonFunctions.localisation(key:"CANCEL")
        static let tooManyFailedAttemptPleaseReauthenticate = CommonFunctions.localisation(key:"TOO_MANY_FAILED_ATTEMPT_PLEASE_REAUTHENTICATE")
        
        static var enterPassword = CommonFunctions.localisation(key:"ALERT_PASSWORD")
        static var enterValidPassword = CommonFunctions.localisation(key:"ALERT_VALID_PASSWORD")
        static var enterState = CommonFunctions.localisation(key:"ALERT_STATE_NAME")
        static var enterValidZipcode = CommonFunctions.localisation(key:"ALERT_VALID_ZIPCODE")
        static var enterBirthPlace = CommonFunctions.localisation(key:"ALERT_BIRTH_PLACE")
        static var selectBirthCountry = CommonFunctions.localisation(key:"ALERT_BIRTH_COUNTRY")
        static var selectAreYouUSCitizen = CommonFunctions.localisation(key:"ALERT_US_CITIZEN")
        static var pleaseSelectPersonalAssets = CommonFunctions.localisation(key:"ALERT_PERSONAL_ASSETS")
        
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
        static let statusCode = "statusCode"
        
        // MARK: - Login keys
        static let phone_no = "phone_no"
        static let country_code = "country_code"
        static let device_type = "device_type"
        static let device_id = "device_id"
        static let device_token = "device_token"
        static let otp = "otp"
        static let login_pin = "login_pin"
        static let is_push_enabled = "is_push_enabled"
        static let newPin = "newPin"
        static let face_id = "face_id"
        static let enable_face_id = "enable_face_id"
        static let enable = "enable"
        static let withdrawalLock = "withdrawalLock"
        
        // MARK: - personal Data keys
        static let personal_info_step = "personal_info_step"
        static let name = "name"
        static let first_name = "first_name"
        static let last_name = "last_name"
		static let language = "language"
        static let state = "state"
        static let countryName = "countryName"
        static let zip_code = "zip_code"
        static let dob = "dob"
        static let birth_place = "birth_place"
        static let birth_country = "birth_country"
        static let address1 = "address1"
        static let specifiedUSPerson = "specifiedUSPerson"
        static let investment_experience = "investment_experience"
        static let income_source = "income_source"
        static let status = "status"
		
		//User
		static let action = "action"
		static let details = "details"
		static let destination = "destination"
		static let chain = "chain"
        
        // MARK: - investment Strategy keys
        static let is_own_strategy = "is_own_strategy"
        static let investment_strategy_id = "investment_strategy_id"
        static let assets = "assets"
        static let asset = "asset"
        static let asset_symbol = "asset_symbol"
        static let asset_id = "asset_id"
        static let asset_name = "asset_name"
        static let strategy_name = "strategyName"
        static let amount = "amount"
        static let asset_amount = "asset_amount"
        static let frequency = "frequency"
        static let wallet_address = "wallet_address"
        static let fromAsset = "fromAsset"
        static let toAsset = "toAsset"
        static let fromAmount = "fromAmount"
        static let bundle = "bundle"
        static let share = "share"
        static let owner_uuid = "ownerUuid"
        static let orderId = "orderId"
        
        //MARK: - assets keys
        static let order = "order"
        static let page = "page"
        static let limit = "limit"
        static let offset = "offset"
        static let keyword = "keyword"
        static let duration = "duration"
        
        //Profile
        static let profile_pic = "profile_pic"
        static let profile_pic_type = "profile_pic_type"
        static let iban = "iban"
        static let bic = "bic"
        static let network = "network"
        static let address = "address"
        static let origin = "origin"
        static let exchange = "exchange"
        static let logo = "logo"
        static let id = "id"
        static let include_networks = "include_networks"
        static let address_id = "address_id"
        
        //Main
        static let uuid = "uuid"
        
        
        
        // MARK: - New backend
        
        // MARK: - New Login keys
        static let phoneNo = "phoneNo"
        static let countryCode = "countryCode"
        static let code = "code"
        static let method = "method"
        static let A = "A"
        static let M1 = "M1"
        static let refresh_token = "refresh_token"
        
        // MARK: - New personal Data keys
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let birthPlace = "birthPlace"
        static let birthDate = "birthDate"
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
        static let personalAssets = "personalAssets"
        
        // MARK: - Profile keys
        static let type2FA = "type2FA"
        static let googleOtp = "googleOtp"
		
		// MARK: - User keys
		static let scope2FA = "scope2FA"
        
    }
    
    // MARK: - Requested URL Keys
    // Delete this
    struct ApiUrlKeys {
        static let userSignup = "user/signup"
        static let userVerifyPhone = "user/verify/phone"
        static let userSetLoginPin = "user/set_login_pin"
        static let userResendPhoneVerificationOtp = "user/resend/phone-verification-otp"
        static let userResetNotification = "user/reset/notification"
        static let userActivateFaceId = "user/activate/face-id"
        static let userPersonalInfo = "user/personal-info"
        static let userPersonal_info = "user/personal_info"
        static let userResendEmail = "user/resend/email"
        static let userCheckEmailVerification = "user/check_email_verification"
        static let userInvestEducation = "user/invest/education"
        static let userTreezorStatus = "user/treezor-status"
        
        //Strategies
        
        static let userInvestmentStrategy = "user/investment-strategy"
        static let investOnAsset = "user/invest-on-asset"
        static let userWithdrawCrypto = "user/withdraw-crypto"
        
        //Coins
        static let userSellCrypto = "user/sell-crypto"
        static let coinTrendings = "coin/trendings"
        static let coingeckoCoins = "coingecko/coins"
        static let userAssets = "user/assets"
        static let userInvestment = "user/investment"
        static let coingeckoCoinAsset = "coingecko/coin"
        static let coingeckoPriceChart = "coingecko/price-chart"
        
        //Treezor
        static let kyc_status = "treezor/kyc-status"
        static let kyc_liveness = "treezor/kyc-liveness"
        static let treezorUser = "treezor/user"
        static let treezorWithdrawFiat = "treezor/withdraw-fiat"
        
        //Profile
        static let userPinVerifyPhone = "user/pin/verify-phone"
        static let userPin = "user/pin"
        static let user = "user"
        static let userBankInfo = "user/bank-info"
        static let userEnableStrongAuth = "user/enable/strong-auth"
        static let userVerifyStrongAuth = "user/verify/strong-auth"
        static let userNetworks = "user/networks"
        static let aploVenues = "aplo/venues"
        static let upload = "upload"
        
        
        //Assets
        static let assets = "assets"
        
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
        
        //Login
        static let userChallenge = "user-service/challenge"
        static let userLogin = "user-service/login"
        
        
        //Detail Page
        static let newsService = "news-service/news"
        static let priceServiceResume = "price-service/resume"
        static let priceServicePrice = "price-service/price"
        static let assetServiceAsset = "asset-service/asset"
        
        //User
        static let userServiceUser = "user-service/user"
        static let assetServiceAssets = "asset-service/assets"
        static let userServiceGoogleOtp = "user-service/google-otp"
        static let userServiceVerify2FA = "user-service/verify-2FA"
        static let userServiceLanguage = "user-service/language"
		static let userServiceTwoFaOtp = "user-service/2fa-otp"
		static let userServiceTransactions = "user-service/transactions"
        
        //Strategies
        static let investmentStrategies = "strategy-service/strategies"
        static let strategyServiceStrategy = "strategy-service/strategy"
        static let strategyServiceActiveStrategy = "strategy-service/active-strategy"
       
        //Notification
        static let registerDeviceToken = "notification-service/register"
		static let notificationServiceNotifications = "notification-service/notifications"
		
		//Orders
		static let orderServiceQuote = "order-service/quote"
		static let orderServiceAcceptQuote = "order-service/accept-quote"
		static let orderServiceOrder = "order-service/order"
		
		//Wallet
		static let walletServiceAddress = "wallet-service/address"
		static let walletServiceBalance = "wallet-service/balance"
		static let walletServiceWithdrawalAddress = "wallet-service/withdrawal-address"
		static let walletServiceWithdraw = "wallet-service/withdraw"
		static let walletServiceHistory = "wallet-service/history"
		
		//Network
		static let networkServiceNetworks = "network-service/networks"
		static let networkServiceNetwork = "network-service/network"
		
    }
}
