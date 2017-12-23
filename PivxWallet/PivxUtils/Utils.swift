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
import MessageUI

class RootController: UIViewController {
    @objc static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootViewController")
}

class TxHistoryController: UIViewController {
    @objc static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BRTxHistory")
}

class SettingsController: UIViewController {
    @objc static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController")
}

class SendController: UIViewController {
    @objc static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SendViewController")
}

class ReceiveController: UIViewController {
    @objc static let shared = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiveViewController")
}

class Utils: NSObject {
    
    static var isTestnet:Bool = false;

    @objc static func configureNavigationBar(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for:.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = K.color.purple_r85g71b108
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = K.color.purple_r85g71b108
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    static func getTopController()->UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    @objc static func showMailController(messageBody:String, delegate:MFMailComposeViewControllerDelegate) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = delegate
            mail.setToRecipients(["matiasfurszyfer@gmail.com"])
            mail.setSubject("Logs IOS PIVX")
            mail.setMessageBody(messageBody, isHTML: false)
            let top = Utils.getTopController()
            top?.present(mail, animated: true, completion: nil)
            
        } else {
            Utils.showAlertController(title: nil, message: "Sorry, you don't have any configured email account. Please add it and try again.")
        }
    }
    
    @objc static func setIsTestnet()->Void{
        isTestnet = true;
     }
    
    @objc static func toHome()->SlideMenuController{
        let menuController = MenuController(nibName: "Menu", bundle: nil)
        let homeController = RootController.shared
        let nav = UINavigationController(rootViewController: homeController)
        let navigationController = SlideMenuController(mainViewController: nav, leftMenuViewController:menuController, rightMenuViewController: UIViewController())
        navigationController.removeRightGestures()
        return navigationController
    }
    
    @objc static func changeStatusBackgroundColor(color:UIColor = K.color.purple_r85g71b108){
        UIApplication.shared.statusBarView?.backgroundColor = color
    }
    
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
    
   @objc static func openLeftMenu(){
        if let root = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController {
            root.openLeft()
        }
    }
    
    @objc static func showScanController(){
        if let root = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController {
            guard let menu = root.leftViewController as? MenuController else { return }
            guard let controller = RootController.shared as? BRRootViewController else { return }
            menu.tappedMyWalletButton(UIButton())
            let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when, qos: .background) {
                controller.sendViewController.actionQrScan()
            }
        }
    }
    
    @objc static func showAmountController(){
        if let root = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController {
            guard let menu = root.leftViewController as? MenuController else { return }
            guard let controller = RootController.shared as? BRRootViewController else { return }
            menu.tappedMyWalletButton(UIButton())
            let when = DispatchTime.now() + 0.2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when, qos: .background) {
                controller.toSend()
                
            }
        }
    }
    
    @objc static func toRootController(){
        if let root = UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController {
            guard let menu = root.leftViewController as? MenuController else { return }
            menu.tappedMyWalletButton(UIButton())
        }
    }
    
    @objc static func deviceType()->String{
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return "iPhone5"
            case 1334:
                print("iPhone 6/6S/7/8")
                return "iphone6"
            case 2208:
                return "iphone6plus"
            case 2436:
                return "iphoneX"
            default:
                return ""
            }
        }
        return ""
    }
    
    
}
