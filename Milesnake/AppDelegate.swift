//
//  AppDelegate.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit
import Navigation_stack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        let navigationController = NavigationStack(rootViewController: TargetListViewController()).then {
            $0.navigationBar.prefersLargeTitles = true
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.tintColor = Color.pink
            let textAttributes = [NSAttributedString.Key.foregroundColor: Color.textBlack]
            $0.navigationBar.largeTitleTextAttributes = textAttributes
        }
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        setup()

        return true
    }

    private func setup() {
        let userDefault = UserDefaults.standard
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)

        if userDefault.bool(forKey: "firstLaunch") {
            userDefault.set(false, forKey: "firstLaunch")
            let sanpo = Mile()
            sanpo.what = "毎日散歩をする"
            sanpo.why = "健康のために"
            sanpo.createdAt = Date()

            let hayaoki = Mile()
            hayaoki.what = "早起きをする"
            hayaoki.why = "朝に時間が必要だから"
            hayaoki.createdAt = Date()

            let asahuro = Mile()
            asahuro.what = "起きたらシャワーを浴びる"
            asahuro.why = "目を覚ますため"
            asahuro.createdAt = Date()

            let hayane = Mile()
            hayane.what = "早くに寝る"
            hayane.why = "睡眠時間を確保するため"
            hayane.createdAt = Date()

            let service = MileService()
            service.append(from: hayane, to: hayaoki)
            service.append(from: hayaoki, to: sanpo)
            service.append(from: asahuro, to: sanpo)
            service.save(sanpo)
        }
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

