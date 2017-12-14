//
//  MenuController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class MenuController: BaseController {

    @IBOutlet weak var syncImageView: UIImageView!
    @IBOutlet weak var syncLabel: UILabel!
    @IBOutlet weak var cotainerViewHeightConstraint: NSLayoutConstraint!
    var optionSelected:Int = 1
    
    override func setup(){
        cotainerViewHeightConstraint.constant = K.main.height - 130
    }

    @IBAction func tappedMyWalletButton(_ sender: Any) {
        if optionSelected == 1 {
            slideMenuController()?.closeLeft()
            return
        }
        
        let homeController = RootController.shared
        let nav = UINavigationController(rootViewController: homeController)
        slideMenuController()?.changeMainViewController(nav, close: true)
        optionSelected = 1
    }
    @IBAction func tappedAddressBookButton(_ sender: Any) {
//        let controller = AddressContactController()
//        let navigation = UINavigationController(rootViewController: controller)
//        slideMenuController()?.changeMainViewController(navigation, close: true)
    }
    @IBAction func tappedSettingButton(_ sender: Any) {
        if optionSelected == 3 {
            slideMenuController()?.closeLeft()
            return
        }
        let controller = TxHistoryController.shared
        let nav = UINavigationController(rootViewController: controller)
        slideMenuController()?.changeMainViewController(nav, close: true)
        optionSelected = 3
    }
    @IBAction func tappedDonationButton(_ sender: Any) {
        if optionSelected == 4 {
            slideMenuController()?.closeLeft()
            return
        }
        let controller = DonationController(nibName:"Donation", bundle:nil)
        let navigation = UINavigationController(rootViewController: controller)
        slideMenuController()?.changeMainViewController(navigation, close: true)
        optionSelected = 4
    }
}
