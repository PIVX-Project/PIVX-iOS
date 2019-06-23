//
//  NewAddressController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class NewAddressController: BaseController {

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        descriptionTextField.delegate = self
        addressTextField.delegate = self
        nameTextField.delegate = self
        navigationItem.title = NSLocalizedString("New Address Label", comment: "New Address Label")
        let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: "Save"), style: .done, target: self, action: #selector(tappedSaveButton))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func tappedSaveButton(){
        guard let name = nameTextField.text,
        let description = descriptionTextField.text,
        let address = addressTextField.text else { return }
        
        let unwrappedName = name.trimmingCharacters(in: .whitespaces)
        let unwrappedDescription = description.trimmingCharacters(in: .whitespaces)
        let unwrappedAddress = address.trimmingCharacters(in: .whitespaces)
        
        if unwrappedName == "" {
            Utils.showAlertController(title: "", message: NSLocalizedString("Invalid Name", comment: "Invalid Name"))
            return
        }
        
        if unwrappedDescription == "" {
            Utils.showAlertController(title: "", message: NSLocalizedString("Invalid Description", comment: "Invalid Description"))
            return
        }
        
        if unwrappedAddress == "" || !BRPivxUtils.isValidAdress(unwrappedAddress){
            Utils.showAlertController(title: "", message: NSLocalizedString("Invalid Address", comment: "Invalid Address"))
            return
        }
        
        var dictionary:[String:AnyObject] = [:]
        dictionary["name"] = unwrappedName as AnyObject
        dictionary["address"] = unwrappedAddress as AnyObject
        dictionary["descriptionContact"] = unwrappedDescription as AnyObject
        let contact = ContactAddress(dictionary:dictionary)
        var contacts = LocalStore.getContacts()
        
        if contacts.count == 200 {
            Utils.showAlertController(title: "", message: NSLocalizedString("Contact address limit", comment: "Contact address limit"))
            return
        }
        
        contacts.append(contact)
        LocalStore.saveAsArrayJson(data: contacts.map { return $0.toDictionary() as AnyObject }, name: "contacts")
        let _ = navigationController?.popViewController(animated: true)
    }

}

extension NewAddressController:UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            descriptionTextField.becomeFirstResponder()
        } else if textField == descriptionTextField {
            addressTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return false
    }
    
}
