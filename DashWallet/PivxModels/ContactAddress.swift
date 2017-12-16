//
//  ContactAddress.swift
//  pivxwallet
//
//  Created by German Mendoza on 12/15/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class ContactAddress: NSObject {
    var name:String = ""
    var descriptionContact:String = ""
    var address:String = ""
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "name" {
            if let unwrappedValue = value as? String {
                name = unwrappedValue
            }
        } else if key == "address" {
            if let unwrappedValue = value as? String {
                address = unwrappedValue
            }
        } else if key == "descriptionContact" {
            if let unwrappedValue = value as? String {
                descriptionContact = unwrappedValue
            }
        }
    }

    override init() {
        super.init()
    }
    
    init(dictionary:[String:AnyObject]){
        super.init()
        setValuesForKeys(dictionary)
    }
    
    func toDictionary()->[String:AnyObject] {
        var dictionary:[String:AnyObject] = [:]
        dictionary["name"] = name as AnyObject
        dictionary["address"] = address as AnyObject
        dictionary["descriptionContact"] = descriptionContact as AnyObject
        return dictionary
    }
}
