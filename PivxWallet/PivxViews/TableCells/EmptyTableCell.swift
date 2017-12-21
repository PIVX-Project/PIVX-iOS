//
//  EmptyTableCell.swift
//  pivxwallet
//
//  Created by German Mendoza on 12/20/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class EmptyTableCell: UITableViewCell {

    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @objc func configureWith(title:String, image:String){
        titleLabel.text = title
        emptyImageView.image = UIImage(named: image)
    }
}
