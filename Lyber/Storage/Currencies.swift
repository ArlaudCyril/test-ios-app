//
//  Currencies.swift
//  Lyber
//
//  Created by JILI EARN on 09/02/2023.
//

import Foundation

struct Storage{
    static var currencies : [AssetDetailData?] = []
    
    /*init(currencies: [AssetDetailData?]) {
        self.currencies = currencies
    }*/
    static func getCurrency(asset : AllAssetsData?) -> AssetDetailData? {
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

