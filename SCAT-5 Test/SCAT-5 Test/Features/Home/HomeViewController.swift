//
//  HomeViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView!

    var user: SCAT5User?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let manager = try? Container.resolve(DataManager.self) else { return }
        user = manager.currentUser
        userNameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
        
    }

}
