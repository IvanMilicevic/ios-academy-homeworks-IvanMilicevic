//
//  AppDelegate.swift
//  TVShows
//
//  Created by Infinum Student Academy on 05/07/2018.
//  Copyright © 2018 Ivan Milicevic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor(red: CGFloat(255.0/255),
                                                         green: CGFloat(117.0/255),
                                                         blue: CGFloat(140.0/255),
                                                         alpha: CGFloat(1))
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //        if UserDefaults.standard.bool(forKey: TVShowsUserDefaultsKeys.loggedIn.rawValue) == true {
        //            let keychain = Keychain(service: TVShowsKeyChain.service.rawValue)
        //            guard
        //                let email = keychain[TVShowsKeyChain.email.rawValue],
        //                let password = keychain[TVShowsKeyChain.password.rawValue]
        //                else { return true }
        //
        //            let parameters: [String: String] = [
        //                "email": email,
        //                "password": password
        //            ]
        //
        //            Alamofire
        //                .request("https://api.infinum.academy/api/users/sessions",
        //                         method: .post,
        //                         parameters: parameters,
        //                         encoding: JSONEncoding.default)
        //                .validate()
        //                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
        //
        //                    guard let `self` = self else { return }
        //
        //                    SVProgressHUD.dismiss()
        //                    switch response.result {
        //                    case .success(let loginData):
        //                        SwiftyLog.info("Success: \(loginData)")
        //
        //                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        //                        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController_Home")
        //                            as! HomeViewController
        //                        viewController.loginData = loginData
        //                        let nc = UINavigationController(rootViewController: viewController)
        //                        self.window = UIWindow(frame: UIScreen.main.bounds)
        //                        self.window?.rootViewController=nc
        //                        self.window?.makeKeyAndVisible()
        //                    case .failure(let error):
        //                       SwiftyLog.error("\(error.localizedDescription)")
        //                    }
        //            }
        //
        //
        //
        //        }
        
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

