//
//  AppDelegate.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 2/10/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3828876899715465~9741705036")
        configureAppWideAppearance()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func configureAppWideAppearance() {
        UINavigationBar.appearance().barTintColor = .mainAppColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.appFont(withSize: 30)]
    }
    
}

extension UIFont {
    
    static func appFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "Futura-Medium", size: size)!
    }
    
    static func memeFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: "LemonMilk", size: size)!
    }
    
}
