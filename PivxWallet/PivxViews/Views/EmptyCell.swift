//
//  EmptyCell.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/27/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class EmptyCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func cofigureWith(title:String, name:String) {
    
        titleLabel.text = title
        thumbImageView.image = UIImage(named: name)
        
    }

}
