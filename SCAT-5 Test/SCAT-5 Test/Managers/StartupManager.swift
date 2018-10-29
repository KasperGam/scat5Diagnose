//
//  StartupManager.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation
import FirebaseCore

class StartupManager {


    func setup() {

        setupHoratio()
        setupFirebase()
        configureNavBar()

    }

    private func setupHoratio() {

        Container.register(OperationQueue.self) { _ in return OperationQueue() }

        Container.register(DataManager.self) { _ in return DataManager() }

        Container.register(KeychainManager.self) { _ in return KeychainManager() }
    }

    private func setupFirebase() {
        FirebaseApp.configure()
        if let manager = try? Container.resolve(DataManager.self) {
            manager.refreshWordLists()
        }
    }

    private func configureNavBar() {

        

        let navBarAppearence = UINavigationBar.appearance()
        //navBarAppearence.barTintColor = UIColor(hex: "2F3BA2")
        navBarAppearence.isTranslucent = true
        navBarAppearence.barTintColor = UIColor.clear
        navBarAppearence.tintColor = UIColor.black
        //navBarAppearence.isTranslucent = false
        navBarAppearence.setBackgroundImage(UIImage(), for: .default)
        navBarAppearence.shadowImage = UIImage()
        navBarAppearence.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

//        let tabBarAppearence = UITabBar.appearance()
//        tabBarAppearence.barTintColor = UIColor(hex: "2F3BA2")
//        tabBarAppearence.tintColor = UIColor.white
//        tabBarAppearence.isTranslucent = false
//        tabBarAppearence.items?.forEach({$0.setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State())})
    }

}
