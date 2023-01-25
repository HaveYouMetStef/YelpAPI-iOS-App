//
//  AppDelegate.swift
//  Unit 4 Yelp API Project
//
//  Created by Stef Castillo on 1/13/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let network = NetworkManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        NetworkManager.shared.fetchBusiness(type: "pizza") {
            results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let yelpData):
                for i in yelpData.businesses {
                    print(i.name)
                }
            }
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

