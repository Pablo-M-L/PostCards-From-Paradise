//
//  AppDelegate.swift
//  PostCards From Paradise
//
//  Created by admin on 27/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         if let splitview = window?.rootViewController as? UISplitViewController { //viewcontroler principal.
            //mostrar siempre el splitview. incluso en portrait.
            splitview.preferredDisplayMode = .allVisible
            
            //añadir boton que permita mostra/ocultar splitview.
            //accede al navigationItem (barra de navegacion) del navcontroller que contiene el topviewcontroller, y modifica el boton de la izquierda.
            if let navcontroller = splitview.viewControllers.last as? UINavigationController { //obtiene un array de los viewcontroller y coge el ultimo.
                navcontroller.topViewController?.navigationItem.leftBarButtonItem = splitview.displayModeButtonItem //cambia el boton para que se muestre el simbolo de ampliar y no el de back que hay por defecto.
            }
            
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

