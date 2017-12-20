//
//  BaseController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/22/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

class BaseController: UIViewController {
    
    let cellIdentifier = "cellIdentifier"
    let emptyIdentifier = "emptyIdentifier"
    var state:TableState = .success

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    
    func setup(){}

    func setupNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = K.color.purple_r85g71b108
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named:"icBack"), style: .plain, target: self, action: #selector(tappedBackButton))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func refresh(){}
    
    func addMenuButton(){
        let menuButton = UIBarButtonItem(image: UIImage(named:"icDrawer"), style: .plain, target: self, action: #selector(tappedMenuButton))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = menuButton
        
    }
    
    func addOptionButton(){
        let optionButton = UIBarButtonItem(image: UIImage(named:"icMenuOptions"), style: .plain, target: self, action: #selector(tappedOptionButton))
        navigationItem.rightBarButtonItem = optionButton
    }
    
    @objc func tappedOptionButton(){
    
    }
    
    @objc func tappedMenuButton(){
        self.slideMenuController()?.openLeft()
    }
    
    @objc func tappedBackButton(){
        let result = navigationController?.popViewController(animated: true)
        if result == nil {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
