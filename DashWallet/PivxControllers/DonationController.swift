//
//  DonationController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class DonationController: BaseController,BRAmountViewControllerDelegate {

    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    
    let DONATE_ADDRESS:String = "DLwFC1qQbUzFZJg1vnvdAXBunRPh6anceK";
    
    var amount: String?;
    
    
    override func setup(){
        donateButton.border(cornerRadius: 5, color: K.color.purple_r85g71b108)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Donations"
        addMenuButton()
    }

    @IBAction func tappedDonateButton(_ sender: Any) {
        
        let controller:BRAmountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AmountViewController") as! BRAmountViewController;
        controller.usingShapeshift = false;
        controller.delegate = self;
        controller.to = DONATE_ADDRESS;
        
        // title view
        BRWalletManager.sharedInstance();
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 100));
        label.autoresizingMask = [.flexibleHeight,.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin];
        label.backgroundColor = UIColor.clear;
        label.textAlignment = .center
        label.text = "Donate"
        
        controller.navigationItem.titleView = label;
        present(controller, animated: true) {
            // here is if i want to receive the callback once the view is loaded.
        };
    }
    
    func amountViewController(_ amountViewController: BRAmountViewController!, selectedAmount amount: UInt64) {
        // callback from the BRAmountViewController.
    }


}
