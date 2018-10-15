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

    }

    private func setupHoratio() {

        Container.register(OperationQueue.self) { _ in return OperationQueue() }

        Container.register(DataManager.self) { _ in return DataManager() }
    }

    private func setupFirebase() {
        FirebaseApp.configure()
    }

}
