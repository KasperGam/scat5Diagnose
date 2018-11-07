//
//  AssessmentResultViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 11/5/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class ViewAssessmentResultViewController: UIViewController {

    var assessment: SCAT5Flyweight?

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    private func titleForRow(_ index: Int) -> String {
        var value: Int
        var key: String
        switch index {
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
            let symptom = assessment?.symptoms[index - 7]
            key = symptom?.name ?? ""
            value = symptom?.severity ?? 0
        }
        return "\(key): \(value)"
    }

}

extension ViewAssessmentResultViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (assessment?.symptoms.count ?? 0) + 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.textLabel?.text = titleForRow(indexPath.row)
        return cell
    }
}

extension ViewAssessmentResultViewController: UITableViewDelegate {

}
