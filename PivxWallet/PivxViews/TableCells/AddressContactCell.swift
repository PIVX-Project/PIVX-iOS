//
//  AddressContactCell.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class AddressContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWith(contact:ContactAddress){
        nameLabel.text = NSLocalizedString("Name:", comment: "Name:") + " " + contact.name
        addressLabel.text = NSLocalizedString("Address:", comment: "Address:") + " " + contact.address
        descriptionLabel.text = NSLocalizedString("Description:", comment: "Description:") + " " + contact.descriptionContact
    }
    
}
