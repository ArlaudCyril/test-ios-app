//
//  Storage.swift
//  Lyber
//
//  Created by JILI EARN on 09/02/2023.
//

import Foundation

struct Storage{
    static var currencies : [AssetBaseData?] = []
    static var networks : [NetworkData] = []
	static var balances : [Balance?] = []
    
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
	static var baseUrl : String = AppConfig.dictEnvVariables["API_URL"] as? String ?? "https://staging.lyber.com/"
	
}

struct AppConfig {
	static var dictEnvVariables: NSDictionary {
#if STAGING
        return NSDictionary(contentsOfFile: Bundle.main.path(forResource: "lyberStaging", ofType: "plist") ?? "") ?? NSDictionary()
#else
		return NSDictionary(contentsOfFile: Bundle.main.path(forResource: "lyberProd", ofType: "plist") ?? "") ?? NSDictionary()
#endif
	}
	
}
