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
    static let deviceToken = "df"
    
    struct AlertMessages{
        static var enterPhoneNumber = L10n.enterPhoneNumber.description
        static var enterValidPhoneNumber = L10n.enterValidPhoneNumber.description
        static var enterCorrectPin = L10n.enterCorrectPin.description
        static var enterFirstName = L10n.enterFirstName.description
        static var enterLastName = L10n.enterLastName.description
        static var selectBirthDate = L10n.selectBirthDate.description
        static var selectNationality = L10n.selectNationality.description
        static var enterEmail = L10n.enterEmail.description
        static var enterValidEmail = L10n.enterValidEmail.description
        static var enterStreetNumber = L10n.enterStreetNumber.description
        static var enterBuildingFloor = L10n.enterBuildingFloor.description
        static var enterCity = L10n.enterCityName.description
        static var enterZipcode = L10n.enterZipcode.description
        static var enterCountry = L10n.enterCountry.description
        static var chooseInvestmentExp = L10n.chooseInvestmentExp.description
        static var chooseSourceOfIncome = L10n.chooseSourceOfIncome.description
        static var chooseWorkIndustry = L10n.chooseWorkIndustry.description
        static var chooseAnnualIncome = L10n.chooseAnnualIncome.description
        static let logOut = L10n.LogOut.description
        static let sureLogOut = L10n.AreYouSureLogOut.description
        static let Cancel = L10n.Cancel.description
        
        static var enterPassword = "Please enter password"
        static var enterValidPassword = "Password should be of minimum 8 characters"
        static var enterState = "Please enter state name"
        static var enterValidZipcode = "Please enter valid zipcode"
        static var selectBirthPlace = "Please enter your birth Place"
        static var selectBirthCountry = "Please select your birth country"
        static var selectAreYouUSCitizen = "Please select are you US Citizen or not?"
        static var pleaseSelectPersonalAssets = "Please Select your personal Assets"
        
        static var PleaseEnterYourAddressName = "Please enter your address name"
        static var PleaseSelectYourNetwork = "Please select your network"
        static var PleaseEnterOrScanAnAddress = "Please enter or scan an address"
        static var PleaseSelectYourExchange = "Please select your exchange"
        static var PleaseEnableWhitelistingAddress = "Please enable whitelisting address to add address"
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
        static let extra_security = "extra_security"
        
        // MARK: - personal Data keys
        static let personal_info_step = "personal_info_step"
        static let name = "name"
        static let first_name = "first_name"
        static let last_name = "last_name"
//        static let email = "email"
        static let state = "state"
        static let countryName = "countryName"
        static let zip_code = "zip_code"
        static let dob = "dob"
//        static let nationality = "nationality"
//        static let incomeRange = "incomeRange"
        static let birth_place = "birth_place"
        static let birth_country = "birth_country"
        static let address1 = "address1"
//        static let occupation = "occupation"
//        static let personalAssets = "personalAssets"
        static let specifiedUSPerson = "specifiedUSPerson"
        static let investment_experience = "investment_experience"
        static let income_source = "income_source"
        static let status = "status"
        
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
        static let user_investment_strategy_id = "user_investment_strategy_id"
        static let wallet_address = "wallet_address"
        static let exchange_from = "exchange_from"
        static let exchange_to = "exchange_to"
        static let exchange_from_amount = "exchange_from_amount"
        static let exchange_to_amount = "exchange_to_amount"
        static let bundle = "bundle"
        static let share = "share"
        
        //MARK: - assets keys
        static let order = "order"
        static let page = "page"
        static let limit = "limit"
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
        static let address_id = "address_id"
        
        
        
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
        static let userInvestOnStrategy = "user/invest-on-strategy"
        static let userWithdrawCrypto = "user/withdraw-crypto"
        static let userSwapCrypto = "user/swap-crypto"
        
        //Coins
        static let userSellCrypto = "user/sell-crypto"
        static let coinTrendings = "coin/trendings"
        static let coingeckoCoins = "coingecko/coins"
        static let userAssets = "user/assets"
        static let userInvestments = "user/investments"
        static let userInvestment = "user/investment"
        static let coingeckoCoinAsset = "coingecko/coin"
        static let coingeckoPriceChart = "coingecko/price-chart"
        
        //Treezor
        static let kyc_status = "treezor/kyc-status"
        static let kyc_liveness = "treezor/kyc-liveness"
        static let treezorUser = "treezor/user"
        static let treezorWithdrawFiat = "treezor/withdraw-fiat"
        
        //Profile
        static let userTransactions = "user/transactions"
        static let userPinOtp = "user/pin/otp"
        static let userPinVerifyPhone = "user/pin/verify-phone"
        static let userPin = "user/pin"
        static let user = "user"
        static let userBankInfo = "user/bank-info"
        static let userEnableStrongAuth = "user/enable/strong-auth"
        static let userVerifyStrongAuth = "user/verify/strong-auth"
        static let userEnableWhitelisting = "user/enable/whitelisting"
        static let userNetworks = "user/networks"
        static let userWhitelistAddress = "user/whitelist-address"
        static let aploVenues = "aplo/venues"
        static let userWhitelistedAddresses = "user/whitelisted-addresses"
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
        
        //Profile page
        static let userServiceUser = "user-service/user"
        static let assetServiceAssets = "asset-service/assets"
        
        //Strategies
        static let investmentStrategies = "strategy-service/strategies"
        static let strategyServiceStrategy = "strategy-service/strategy"
    }

    struct Language {
        static let ENGLISH = "ENGLISH"
        static let ARABIC = "ARABIC"
    }
    
        
}
