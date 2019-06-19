//
//  AddressContactController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/26/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

enum TableState:String{
    case success
    case error
    case loading
    case empty
}

enum AddresContactControllerType:String {
    case normal
    case filter
}


class AddressContactController: BaseController {
    
    lazy var searchTextField:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = NSLocalizedString("Search a contact", comment: "Search a contact")
        bar.delegate = self
        return bar
    }()

    lazy var tableView:UITableView = {
        let table = UITableView()
        table.register(UINib(nibName:"AddressContactCell", bundle:nil), forCellReuseIdentifier: self.cellIdentifier)
        table.register(UINib(nibName:"EmptyCell", bundle:nil), forHeaderFooterViewReuseIdentifier: self.emptyIdentifier)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView(frame: CGRect.zero)
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 80
        return table
    }()
    
    var type:AddresContactControllerType = .normal
    var items:[ContactAddress] = []
    var filterItems:[ContactAddress] = []
    
    override func setup() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        searchTextField.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        tableView.anchor(searchTextField.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = NSLocalizedString("Address Book", comment: "Address Book")
        addMenuButton()
        let addButton = UIBarButtonItem(image: UIImage(named:"icAdd")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(tappedAddButton))
        navigationItem.rightBarButtonItem = addButton
        
        items = LocalStore.getContacts()
        if items.count == 0 {
            state = .empty
        } else {
            state = .success
        }
        tableView.reloadData()
    }
    
    func delete(index:Int){
        let alert = UIAlertController(title: NSLocalizedString("Are you sure?", comment: "Are you sure?"), message: NSLocalizedString("Do you want delete your contact?", comment: "Do you want to delete your contact?"), preferredStyle: .alert)
        let optionOne = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: { result in
            self.items.remove(at: index)
            LocalStore.saveAsArrayJson(data: self.items.map { return $0.toDictionary() as AnyObject }, name: "contacts")
            if self.items.count == 0 {
                self.state = .empty
            } else {
                self.state = .success
            }
            self.tableView.reloadData()
        })
        let optionTwo = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: { result in })
        alert.addAction(optionOne)
        alert.addAction(optionTwo)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func tappedAddButton(){
        let controller = NewAddressController(nibName: "NewAddress", bundle: nil)
        navigationController?.show(controller, sender: nil)
    }
}

extension AddressContactController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if state == .empty {
            return K.main.height - 164
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if state == .empty {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: emptyIdentifier) as! EmptyCell
            footer.cofigureWith(title: NSLocalizedString("You don't have any saved address yet", comment: "You don't have any saved address yet"), name: "imgAddressEmpty")
            return footer
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .filter {
            return filterItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item = ContactAddress()
        if type == .filter {
            item = filterItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddressContactCell
        cell.configureWith(contact: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if type == .filter { return [] }
        let button = UITableViewRowAction(style: .default, title: NSLocalizedString("DELETE", comment: "DELETE"), handler: { _,_ in
            self.delete(index: indexPath.row)
        })
        button.backgroundColor = UIColor.lightGray
        return [button]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item = ContactAddress()
        if type == .filter {
            item = filterItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        UIPasteboard.general.string = item.address
        print("Address to send \(item.address)")
        Utils.showAmountController()
    }
    
}

extension AddressContactController:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let unwrappedSearch = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        if unwrappedSearch == "" {
            type = .normal
        } else {
            type = .filter
            filterItems = items.filter { contact in
                if (contact.name.lowercased().range(of: unwrappedSearch) != nil) {
                    return true
                } else {
                    return false
                }
            }
        }
        tableView.reloadData()
    }
    
}
