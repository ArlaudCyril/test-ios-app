//
//  Images.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit

enum Assets : String{
    case back
    case close
    case cancel_white
    case slider_one
    case slider_two
    case slider_three
    case right_arrow_grey
    case right_arrow_grey_dull
    case checkmark_color
    case invest_money_white
    case invest_money
    case intermediate_strategy
    case drop_down
    case drop_down_white
    case drop_down_grey
    case drop_up_grey
    case drop_up_white
    case drop_up
    case visibility
    case visibility_off
    
    //coins
    case bitcoin
    case dog
    case ether
    case ether1
    case sol
    case usdc
    case ada
    case luna
    case matic
    case xnd
    case euro
    
    //Strategy Investment
    case radio_unselect
    case radio_select
    case resources_one
    case resources_two
    case resources_three
    case flash
    case pencil
    case coins
    case pause
    case trash
    case recurrent
    
    //Invest Money
    case invest_single_assets
    case money_deposit
    case mastercard
    case apple_pay
    case bank_outline
    case credit_card
    case creditcardPurple
    case bank_fill
    case exchange
    case withdraw
    case paypal
    case buy
    case sell
    case calendar_black
    case calendar_white
    
    case done
    case right_arrow_black
    case logout
    case img_full
    case check
    case visibility_on
    case profile_placholder
    case cover_placholder
    
    
    
    
    //GIF Name
    case profile_image
    case collection_one
    
    func imageName() -> String{
        return self.rawValue
    }
    
    func image () -> UIImage{
        return UIImage(named: self.rawValue) ?? UIImage()
    }
}

extension UIImage {
    convenience init!(asset: Assets) {
        self.init(named: asset.rawValue)
    }
}
