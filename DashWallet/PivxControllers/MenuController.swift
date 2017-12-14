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
    
    override func setup(){
        cotainerViewHeightConstraint.constant = K.main.height - 130
    }

    @IBAction func tappedMyWalletButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        let nav = UINavigationController(rootViewController: homeController)
        slideMenuController()?.changeMainViewController(nav, close: true)
    }
    @IBAction func tappedAddressBookButton(_ sender: Any) {
//        let controller = AddressContactController()
//        let navigation = UINavigationController(rootViewController: controller)
//        slideMenuController()?.changeMainViewController(navigation, close: true)
    }
    @IBAction func tappedSettingButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "BRTxHistory")
        let nav = UINavigationController(rootViewController: homeController)
        slideMenuController()?.changeMainViewController(nav, close: true)
    }
    @IBAction func tappedDonationButton(_ sender: Any) {
        let controller = DonationController(nibName:"Donation", bundle:nil)
        let navigation = UINavigationController(rootViewController: controller)
        slideMenuController()?.changeMainViewController(navigation, close: true)
    }
}
