//
//  AppDelegate.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/19/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController.init(rootViewController: ViewController.init() )
        navController.delegate = self;
        navController.isNavigationBarHidden = true;
        
        let window = UIWindow.init(frame: UIScreen.main.bounds);
        window.rootViewController = navController;
        window.makeKeyAndVisible();
        self.window = window;
        
        return true
    }
    
    // Make the navigation controller defer the check of supported orientation to its topmost view
    // controller. This allows |GVRCardboardViewController| to lock the orientation in VR mode.
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        
        return navigationController.topViewController!.supportedInterfaceOrientations
        
    }


}

