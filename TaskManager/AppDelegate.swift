//
//  AppDelegate.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 22/12/2019.
//  Copyright © 2019 AJTY. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createDefaultCategories()
        return true
    }

    private func createDefaultCategories() {
        let categoryService = CDCategoriesDataProvider()

        categoryService.getAll(completion: { result in
            switch result {
            case .success(let categories):
                if categories.count < 4 {
                    do {
                        try categoryService.createNew(category: Category(categoryID: nil, name: "Blocker", color: "#ff1433"))
                        try categoryService.createNew(category: Category(categoryID: nil, name: "Major", color: "#bc145a"))
                        try categoryService.createNew(category: Category(categoryID: nil, name: "Minor", color: "#ffb732"))
                        try categoryService.createNew(category: Category(categoryID: nil, name: "Trivial", color: "#38acff"))
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print("Could not create default categories with \(error.localizedDescription)")
            }
        })
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
