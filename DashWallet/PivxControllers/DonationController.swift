//
//  DonationController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class DonationController: BaseController {

    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func setup(){
        donateButton.border(cornerRadius: 5, color: K.color.purple_r85g71b108)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Donations"
        addMenuButton()
    }

    @IBAction func tappedDonateButton(_ sender: Any) {
//        if let donationModel = UINib(nibName: "DonationModalView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? DonationModalView {
//            donationModel.show()
//        }
    }
}
