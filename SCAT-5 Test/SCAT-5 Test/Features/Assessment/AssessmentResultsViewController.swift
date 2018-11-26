//
//  AssessmentResultsViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/17/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class AssessmentResultsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var assessment: SCAT5Test? {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    @IBAction func submitPressed(_ sender: Any) {
        guard let dataManager = try? Container.resolve(DataManager.self) else { return }

        dataManager.saveCurrentAssessment()
    }

    @IBAction func cancelPressed(_ sender: Any) {
        guard let dataManager = try? Container.resolve(DataManager.self) else { return }

        dataManager.currentTest = nil
    }

}

extension AssessmentResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessment != nil ? 7 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)

        var value: Int
        var key: String
        switch indexPath.row {
        case 0: value = assessment?.trial1DoubleLegErrors ?? 0
            key = "Trial 1 Double Leg Errors"
        case 1: value = assessment?.trial2MemoryScore ?? 0
            key = "Trial 2 Memory Score"
        case 2: value = assessment?.trial2SingleLegErrors ?? 0
            key = "Trial2 Single Leg Errors"
        case 3: value = assessment?.trial3MemoryScore ?? 0
            key = "Trial 3 Memory Score"
        case 4: value = assessment?.trial3TandemLegErrors ?? 0
            key = "Trial 3 Tandem Leg Errors"
        case 5: value = assessment?.trial4MemoryScore ?? 0
            key = "Trial 4 Memory Score"
        case 6: value = assessment?.duration ?? 0
            key = "Assessment duration (s)"
        default:
            value = 0
            key = "No Key Found"
        }

        cell.textLabel?.text = "\(key): \(value)"
        return cell
    }
}
