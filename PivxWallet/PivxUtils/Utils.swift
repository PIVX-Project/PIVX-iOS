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
            Utils.showAlertController(title: nil, message: NSLocalizedString("Sorry, you don't have any configured email account. Please add it and try again.", comment: "no mail account"))
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
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
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
        let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
        if UIDevice().userInterfaceIdiom == .phone {
            switch SCREEN_MAX_LENGTH {
            case 568.0:
                print("iPhone 5 or 5S or 5C")
                return "iPhone5"
            case 667.0:
                print("iPhone 6/6S/7/8")
                return "iphone6"
            case 736.0:
                print("iPhone 6+/7+/8+")
                return "iphone6plus"
            case 812.0:
                print("iPhone X")
                return "iphoneX"
            case 896.0:
                print("iPhone XR/XS/Max")
                return "iphoneXRSMAX"
            default:
                NSLog("Screen Max Length: %f", SCREEN_MAX_LENGTH)
                return ""
            }
        }
        else if UIDevice().userInterfaceIdiom == .pad {
            switch SCREEN_MAX_LENGTH {
            case 1024.0:
                print("iPad")
                return "ipad"
            case 1112.0:
                print("iPad Pro 10")
                return "ipadpro10"
            case 1194.0:
                print("iPad Pro 11")
                return "ipadpro11"
            case 1366.0:
                if #available(iOS 11.0, *), let keyWindow = UIApplication.shared.keyWindow, keyWindow.safeAreaInsets.bottom > 0 {
                    print("iPad Pro 12 (3rd Generation)")
                    return "ipadpro12"
                } else {
                    print("iPad Pro 12 (1st or 2nd Generation)")
                    return "ipadpro12_old"
                }
            default:
                NSLog("Screen Max Length: %f", SCREEN_MAX_LENGTH)
                return ""
            }
        }
        return ""
    }
    
    
}
