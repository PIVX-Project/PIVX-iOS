//
//  Constants.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/22/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import Foundation
import UIKit

struct K {

    struct main {
        static let width: CGFloat = UIScreen.main.bounds.size.width
        static let height: CGFloat = UIScreen.main.bounds.size.height
        static let maxSize = CGSize(width: K.main.width, height: K.main.height)
    }

    struct color {
        static let black_r42g42b42 = UIColor.rgb(42, green: 42, blue: 42)
        static let black_r58g58b58 = UIColor.rgb(58, green: 58, blue: 58)
        static let purple_r85g71b108 = UIColor.rgb(85, green: 71, blue: 108)
        static let gray_r207g208b209 = UIColor.rgb(207, green: 208, blue: 209)
        static let gray_r155g155b155 = UIColor.rgb(155, green: 155, blue: 155)
        static let gree_r0g150b136 = UIColor.rgb(0, green: 150, blue: 136)
        
    }
    
    struct font {
        static func GillSansRegular(size:CGFloat = 17) -> UIFont {
            return UIFont(name: "GillSans", size: size)!
        }
        
        static func GillSansBold(size:CGFloat = 17) -> UIFont {
            return UIFont(name: "GillSans-Bold", size: size)!
        }
        
        static func GillSansSemiBold(size:CGFloat = 17) -> UIFont {
            return UIFont(name: "GillSans-SemiBold", size: size)!
        }
    }
    
    struct keys {
        static let BALANCE_KEY = "BALANCE"
        static let WALLET_NEEDS_BACKUP_KEY = "WALLET_NEEDS_BACKUP"
        static let BACKUP_DIALOG_TIME_KEY = "BACKUP_DIALOG_TIME"
    }
}
