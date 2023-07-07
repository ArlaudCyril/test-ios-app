//
//  Storage.swift
//  Lyber
//
//  Created by JILI EARN on 09/02/2023.
//

import Foundation

struct Storage{
    static var currencies : [AssetBaseData?] = []
	static var balances : [Balance?] = []
	static var previousControllerPortfolioDetailObject : AnyClass = PortfolioHomeVC.self
    
    /*init(currencies: [AssetDetailData?]) {
        self.currencies = currencies
    }*/
    static func getCurrency(asset : PriceServiceResume?) -> AssetBaseData? {
        print(Storage.currencies)
        for currency in Storage.currencies {
            if(currency?.id == asset?.id)
            {
                return currency ?? nil
            }
        }
        return nil
    }
}

struct GlobalVariables {
	static var isRegistering = false
	static var isLogin = false
	static var language : Language = Language(id: "fr", name: "Français", image: Assets.fr_flag)
	static var languageArray : [Language] = [Language(id:"en", name: "English", image: Assets.uk_flag),Language(id: "fr", name: "Français", image: Assets.fr_flag)]
	static var bundle : Bundle = Bundle()
	static var baseUrl : String = ApiEnvironment.Staging.rawValue
	
}

