//
//  LocalStore.swift
//  dashwallet
//
//  Created by German Mendoza on 12/15/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class LocalStore: NSObject {
    
    static func getUserDirectoryWithName(_ nameFile:String)->String {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = documents + nameFile
        return path
    }
    
    static func retrieveObjectFromFile(name:String)->AnyObject?{
        let path = LocalStore.getUserDirectoryWithName("/\(name).json")
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            let json = try JSONSerialization.jsonObject(with: data)
            return json as AnyObject
        } catch let error {
            print(error.localizedDescription)
            
        }
        return nil
    }
    
    static func saveAsArrayJson(data:[AnyObject], name:String){
        do {
            let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            if let str = String(bytes: json, encoding: .utf8) {
                let path = LocalStore.getUserDirectoryWithName("/\(name).json")
                let url = URL(fileURLWithPath: path)
                do {
                    try str.write(to: url, atomically: true, encoding: .utf8)
                } catch let error {
                    print(error)
                }
            }
        } catch let  err { print(err) }
    }
    
    static func getContacts()->[ContactAddress] {
        if let data = LocalStore.retrieveObjectFromFile(name: "contacts") as? [AnyObject] {
            return data.map { return ContactAddress(dictionary: $0 as! [String:AnyObject]) }
        }
        return []
    }

}
