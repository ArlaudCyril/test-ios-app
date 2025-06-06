//
//  Images.swift
//  Lyber
//
//  Created by sonam's Mac on 26/05/22.
//

import Foundation
import UIKit

enum Assets : String{
    case appIcon
	case grey_coins
	case box
	case circle
	case triangle
    case back
    case close
	case close_color
	case copy
    case cancel_white
    case slider_one
    case slider_two
    case slider_three
    case right_arrow_grey
    case right_arrow_grey_dull
    case checkmark_color
	case white_checkmark
	case white_close
    case invest_money_white
    case invest_money
    case intermediate_strategy
    case intermediate_strategy_outline
    case drop_down
    case drop_down_white
    case drop_down_grey
    case drop_up_grey
    case drop_up_white
    case drop_up
    case visibility
    case visibility_off
	case sad_smiley
	case orange_alert
	case red_failure
	case red_failure_light
	case green_large_tick
	case locationIcon
	case mail
	case maintenance_icon
    
    //coins
    case bitcoin
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
    case send_money
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
    case right_arrow_purple
    case logout
    case img_full
    case check
    case visibility_on
    case profile_placholder
    case cover_placholder
    case cloud_download
    
    //Flags
	case uk_flag
	case fr_flag
	
	//IdentityVerification
	case purple_circle
	case purple_checkbox
    
    
	//icons
	case badger
	case bat
	case bear_head
	case boar
	case cat
	case cheetah
	case chick_egg
	case chick_head
	case chick
	case chicken
	case chimpanzee
	case cow_head
	case cow
	case dog
	case elephant
	case fox
	case frog
	case giraffe
	case gorilla
	case hamster
	case hedgehog
	case kangaroo
	case leo
	case monkey
	case mouse
	case orangutan
	case owl
	case panda
	case pig
	case pinguin
	case poodle
	case rabbit_head
	case rabbit
	case raccoon
	case shiba
	case sloth
	case squirrel
	case tiger_cat
	case unicorn
	case wolf
    
    //Indicators
    case not_performed_indicator
    case pending_indicator
    case rejected_indicator
    case accepted_indicator
    
    //Withdraw VC
    case send_phone
    case send_QRCode
    case send_NFC

    
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
