//
//  Utils.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/22/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import SlideMenuControllerSwift
import Foundation
import UIKit

class Utils: NSObject {

    static func configureNavigationBar(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = K.color.purple_r85g71b108
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = K.color.purple_r85g71b108
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
//    static func configureIQKeyboard() {
//        IQKeyboardManager.sharedManager().enable = true
//    }
//
    @objc static func toHome()->SlideMenuController{
        let menuController = MenuController(nibName: "Menu", bundle: nil)
        //let myWalletController = MyWalletController(nibName: "MyWallet", bundle: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        let nav = UINavigationController(rootViewController: homeController)
        let navigationController = SlideMenuController(mainViewController: nav, leftMenuViewController:menuController, rightMenuViewController: UIViewController())
        navigationController.removeRightGestures()
        return navigationController
//        if let keyWindow = UIApplication.shared.keyWindow {
//            keyWindow.rootViewController?.removeFromParentViewController()
//            keyWindow.rootViewController = navigationController
//            keyWindow.makeKeyAndVisible()
//        }
    }
    
//    static func toLogin()->UIViewController {
//        let controller = LoginController(nibName:"Login",bundle:nil)
//        let navigation = UINavigationController(rootViewController: controller)
//        return navigation
//    }
    
    static func showAlertController(title:String?, message:String?){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func openLeftMenu(){
        if let root = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController {
            root.openLeft()
        }
    }
    
    
}
