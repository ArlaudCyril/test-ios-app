//
//  self_HandlingErros.swift
//  Lyber
//
//  Created by Elie Boyrivent on 06/09/2024.
//

import Foundation
import UIKit
extension CommonFunctions{
    static func handleErrors(caller: String, code: String, error: String, controller: UIViewController = UIViewController(), previousController: UIViewController = UIViewController(), arguments : [String:String] = [:]){
        switch code {
        case "-1":
            self.toster(self.localisation(key: "ERROR_CODE_MINUS_1"))
            break
        case "1":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    self.toster(self.localisation(key: "ERROR_CODE_1"))
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_1"))
            }
            break
        case "3":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_3"))
            }
            break
        case "5":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    self.toster(self.localisation(key: "ERROR_CODE_5"))
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_5"))
            }
            break
        case "6", "7":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_6_7"))
            }
            break
        case "8":
            self.errorRegistration()
            self.toster(self.localisation(key: "ERROR_CODE_8"))
            break
        case "9":
            self.errorRegistration()
            self.toster(self.localisation(key: "ERROR_CODE_9"))
            break
        case "10":
            self.toster(self.localisation(key: "ERROR_CODE_10"))
            break
        case "11":
            self.toster(self.localisation(key: "ERROR_CODE_11"))
            break
        case "12":
            self.toster(self.localisation(key: "ERROR_CODE_12"))
            break
        case "13":
            self.toster(self.localisation(key: "ERROR_CODE_13"))
            break
        case "14":
            self.toster(self.localisation(key: "ERROR_CODE_14"))
            break
        case "15":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    self.toster(self.localisation(key: "ERROR_CODE_15"))
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_15"))
            }
            break
        case "16":
            self.toster(self.localisation(key: "ERROR_CODE_16"))
            break
        case "18":
            self.toster(self.localisation(key: "ERROR_CODE_18"))
            break
        case "20":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_20"))
            }
            break
        case "24":
            self.toster(self.localisation(key: "ERROR_CODE_24"))
            break
        case "26":
            if(controller is CryptoDepositeVC){
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_26"))
            }else if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    self.toster(self.localisation(key: "ERROR_CODE_26"))
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_26"))
            }
        
        break
        case "27":
            self.errorRegistration()
            self.toster(self.localisation(key: "ERROR_CODE_27"))
            break
        case "28", "29", "30":
            self.toster(self.localisation(key: "ERROR_CODE_28_29_30"))
        break
        case "34":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_34"))
            }
        break
        case "35":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_35"))
            }
            break
        case "37":
            self.toster(self.localisation(key: "ERROR_CODE_37"))
            break
        case "38":
            self.toster(self.localisation(key: "ERROR_CODE_38"))
            break
        case "39":
            self.toster(self.localisation(key: "ERROR_CODE_39"))
            break
        case "40":
            self.toster(self.localisation(key: "ERROR_CODE_40"))
        break
        case "41":
            self.toster(self.localisation(key: "ERROR_CODE_41"))
        break
        case "42":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_42"))
            }
        break
        case "43":
            self.toster(self.localisation(key: "ERROR_CODE_43"))
        break
        case "44":
            self.toster(self.localisation(key: "ERROR_CODE_44"))
            break
        case "45":
            self.toster(self.localisation(key: "ERROR_CODE_45"))
        break
        case "48":
            let vc = ForgotPasswordVC.instantiateFromAppStoryboard(appStoryboard: .Main)
            self.goToViewController(vc: vc)
            self.toster(self.localisation(key: "ERROR_CODE_48"))
            break
        case "50":
        self.toster(self.localisation(key: "ERROR_CODE_50"))
        break
        case "52":
            self.errorRegistration()
            self.toster(self.localisation(key: "ERROR_CODE_52"))
            break
        case "53":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_53"))
            }
            break
        case "57":
            if(controller is EnableWhitelistingVC){
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_57"))
            }else if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_57"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_57"))
            }
            break
        
        
        case "1000":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_1000"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_1000"))
            }
            break
        
        
        case "3000":
            if(controller is CryptoDepositeVC){
                let transactionType = self.localisation(key: "DEPOSIT").lowercased()
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_3000", parameter: [transactionType]))
            }else if(controller is WithdrawVC){
                let transactionType = self.localisation(key: "WITHDRAW").lowercased()
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_3000", parameter: [transactionType]))
            }else{
                let transactionType = self.localisation(key: "WITHDRAW").lowercased()
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_3000", parameter: [transactionType]))
            }
            break
        case "3006":
            if(controller is CryptoDepositeVC){
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_3006"))
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_3006"))
            }
            break
        case "7000":
            let fromAsset = arguments["fromAssetId"] ?? ""
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7000", parameter: [fromAsset]))
            
            break
        case "7001":
            let toAsset = arguments["toAssetId"] ?? ""
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7001", parameter: [toAsset]))
            break
        case "7002":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7002"))
            break
        case "7003":
            self.toster(self.localisation(key: "ERROR_CODE_7003"))
            break
        case "7006":
            controller.navigationController?.popViewController(animated: true)
            self.toster(self.localisation(key: "ERROR_CODE_7006"))
            break
        case "7007":
            self.toster(self.localisation(key: "ERROR_CODE_7007"))
            break
        case "7008":
            self.toster(self.localisation(key: "ERROR_CODE_7008"))
            break
        case "7009":
            self.toster(self.localisation(key: "ERROR_CODE_7009"))
            break
        case "7010":
            controller.navigationController?.popViewController(animated: true)
            self.toster(self.localisation(key: "ERROR_CODE_7010"))
            break
        case "7014":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7014"))
            break
        case "7015":
            let fromAsset = arguments["fromAssetId"] ?? ""
            if fromAsset == "EUR"{
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_7015"))
            }else{
                if(controller.navigationController?.popToViewController(ofClass: AllAssetsVC.self) == true){
                    self.toster(self.localisation(key: "ERROR_CODE_7015"))
                }else{
                    self.goPortfolioHome()
                    self.toster(self.localisation(key: "ERROR_CODE_7015"))
                }
            }
            break
        case "7018":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7018"))
            break
        case "7019":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7019"))
            break
        case "7020":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7020"))
            break
        case "7021":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7021"))
            break
        case "7022":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_7022"))
            break
        case "7023"://USER_NOT_KYC
            let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.type = .kyc
            getTopMostViewController()?.present(vc, animated: false)
            break
        case "7024"://KYC_UNDER_VERIFICATION
            if(controller is ConfirmInvestmentVC){
                if(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) == true){
                    self.toster(self.localisation(key: "ERROR_CODE_7024"))
                }else{
                    self.goPortfolioHome()
                    self.toster(self.localisation(key: "ERROR_CODE_7024"))
                }
            }else{
                self.goPortfolioHome()
                self.toster(self.localisation(key: "ERROR_CODE_7024"))
            }
            break
        case "7025"://USER_NOT_SIGNED_CONTRACT
            let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.type = .signing
            getTopMostViewController()?.present(vc, animated: false)
            break
        case "7026":
            self.toster(self.localisation(key: "ERROR_CODE_7026"))
            break
        case "7027":
            self.toster(self.localisation(key: "ERROR_CODE_7027"))
            break
        
        
        case "10001":
            controller.navigationController?.popViewController(animated: true)
            self.toster(self.localisation(key: "ERROR_CODE_10001"))
            break
        case "10005":
            controller.navigationController?.popViewController(animated: true)
            self.toster(self.localisation(key: "ERROR_CODE_10005"))
            break
        case "10009":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10009"))
            break
        case "10012":
            let asset = arguments["asset"] ?? ""
            if(caller == "walletCreateWithdrawalRequest"){
                if(controller is VerificationVC){
                    controller.dismiss(animated: true) {
                        previousController.navigationController?.popViewController(animated: true)
                        self.toster(self.localisation(key: "ERROR_CODE_10012", parameter: [asset.uppercased()]))
                    }
                }else{
                    controller.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10012", parameter: [asset.uppercased()]))
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_10012", parameter: [asset.uppercased()]))
            }
            break
        case "10013":
            let asset = (arguments["asset"] ?? "").uppercased()
            let networkName = (arguments["network"] ?? "").uppercased()
            if(caller == "walletCreateWithdrawalRequest"){
                if(controller is VerificationVC){
                    controller.dismiss(animated: true) {
                        if(previousController.navigationController?.popToViewController(ofClass: WithdrawVC.self) == false){
                            self.goPortfolioHome()
                        }
                        let transactionType = "withdraw"
                        self.toster(self.localisation(key: "ERROR_CODE_10013", parameter: [transactionType, networkName, asset]))
                    }
                }else{
                    if(controller.navigationController?.popToViewController(ofClass: WithdrawVC.self) == false){
                        self.goPortfolioHome()
                    }
                    let transactionType = "withdraw"
                    self.toster(self.localisation(key: "ERROR_CODE_10013", parameter: [transactionType, networkName, asset]))
                }
            }else{
                let transactionType = "deposit"
                self.toster(self.localisation(key: "ERROR_CODE_10013", parameter: [transactionType, networkName, asset]))
            }
            break
        case "10018":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10018"))
            break
        case "10021":
            let minimumWithdraw = arguments["minimumWithdraw"] ?? ""
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10021", parameter: [minimumWithdraw]))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_10021", parameter: [minimumWithdraw]))
            }
            break
        case "10022":
            self.toster(self.localisation(key: "ERROR_CODE_10022"))
            break
        case "10023":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10023"))
            break
        case "10024":
            let network = (arguments["network"] ?? "").uppercased()
            if(caller == "editWithdrawalAddress"){
                if(!(controller.navigationController?.popToViewController(ofClass: CryptoAddressBookVC.self) ?? false) == true){
                    self.goPortfolioHome()
                }
            }
            self.toster(self.localisation(key: "ERROR_CODE_10024", parameter: [network]))
            break
        case "10025":
            controller.dismiss(animated: true) {
                self.toster(self.localisation(key: "ERROR_CODE_10025"))
            }
            break
        case "10028":
            let network = (arguments["network"] ?? "").uppercased()
            if(caller == "editWithdrawalAddress"){
                if(!(controller.navigationController?.popToViewController(ofClass: CryptoAddressBookVC.self) ?? false) == true){
                    self.goPortfolioHome()
                }
            }
            self.toster(self.localisation(key: "ERROR_CODE_10028", parameter: [network]))
            break
        case "10030":
            if(caller == "walletCreateWithdrawalRequest"){
                if(controller is VerificationVC){
                    controller.dismiss(animated: true) {
                        previousController.navigationController?.popViewController(animated: true)
                        self.toster(self.localisation(key: "ERROR_CODE_10030"))
                    }
                }else{
                    controller.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10030"))               
                }
            }else{
                self.toster(self.localisation(key: "ERROR_CODE_10030"))
            }
            break
        case "10032":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10032"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_10032"))
            }
            break
        case "10033":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10033"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_10033"))
            }
            break
        case "10034":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10034"))
            break
        case "10035":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10035"))
            break
        case "10036":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10036"))
            break
        case "10037":
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10037"))
            break
        case "10041"://USER_NOT_KYC
            let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.type = .kyc
            getTopMostViewController()?.present(vc, animated: false)
            break
        case "10042"://KYC_UNDER_VERIFICATION
            self.goPortfolioHome()
            self.toster(self.localisation(key: "ERROR_CODE_10042"))
            break
        case "10043"://USER_NOT_SIGNED_CONTRACT
            let vc = KycSigningPopupVC.instantiateFromAppStoryboard(appStoryboard: .Profile)
            vc.type = .signing
            getTopMostViewController()?.present(vc, animated: false)
            break
        case "10044":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10044"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_10044"))
            }
            break
        case "10045":
            if(controller is VerificationVC){
                controller.dismiss(animated: true) {
                    previousController.navigationController?.popViewController(animated: true)
                    self.toster(self.localisation(key: "ERROR_CODE_10045"))
                }
            }else{
                controller.navigationController?.popViewController(animated: true)
                self.toster(self.localisation(key: "ERROR_CODE_10045"))
            }
            break
        case "10048":
            self.toster(self.localisation(key: "ERROR_CODE_10048"))
            break
        case "10050":
            self.toster(self.localisation(key: "ERROR_CODE_10050"))
            break
        case "10051":
            self.toster(self.localisation(key: "ERROR_CODE_10051"))
            break
            
            
        case "13001":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13001"))
            break
        case "13003":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13003"))
            break
        case "13006":
            let minAmount = (arguments["minAmount"] ?? "")
            if(!(controller.navigationController?.popToViewController(ofClass: InvestInMyStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13006", parameter: [minAmount]))
            break
        case "13009":
            self.toster(self.localisation(key: "ERROR_CODE_13009"))
            break
        case "13010":
            self.toster(self.localisation(key: "ERROR_CODE_13010"))
            break
        case "13011":
            self.toster(self.localisation(key: "ERROR_CODE_13011"))
            break
        case "13012":
            self.toster(self.localisation(key: "ERROR_CODE_13012"))
            break
        case "13013":
            self.toster(self.localisation(key: "ERROR_CODE_13013"))
            break
        case "13015":
            self.toster(self.localisation(key: "ERROR_CODE_13015"))
            break
        case "13016":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13016"))
            break
        case "13017":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13017"))
            break
        case "13018":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13018"))
            break
        case "13019":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13019"))
            break
        case "13020":
            if(!(controller.navigationController?.popToViewController(ofClass: InvestmentStrategyVC.self) ?? false) == true){
                self.goPortfolioHome()
            }
            self.toster(self.localisation(key: "ERROR_CODE_13020"))
            break
        
        
        case "15002":
            self.toster(self.localisation(key: "ERROR_CODE_15002"))
            break
            
            
        case "18000":
            self.toster(self.localisation(key: "ERROR_CODE_18000"))
            break
            
            
        case "19002":// DEPRECATED_API_VERSION = 19002 (update of app necessary)
            self.goToUpdateNewVersionPage()
            break
        case "19003"://UNDER_MAINTENANCE = 19003
            self.goToMaintenancePage()
            break
        case "19006", "19007"://JWT Token expired
            self.logout()
            self.toster(error)
            break
        default:
            self.toster(error)
        }
    }
}
