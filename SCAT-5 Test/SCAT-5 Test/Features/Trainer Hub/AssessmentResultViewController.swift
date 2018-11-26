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
        var value: String
        var key: String
        switch index {
        case 0: value = assessment?.testDate?.getMMddYYYYHHmma() ?? ""
            key = "Date of Assessment"
        case 1: value = String(assessment?.duration ?? 0)
            key = "Assessment duration (s)"
        case 2: value = String(assessment?.numberOfSymptoms() ?? 0) + " of 22"
            key = "Total # of symptoms"
        case 3: value = String(assessment?.sevScore() ?? 0) + " of 132"
            key = "Symptom Severity Score"
        case 4: value = String(assessment?.trial1DoubleLegErrors ?? 0)
            key = "Double Leg Errors"
        case 5: value = String(assessment?.trial2SingleLegErrors ?? 0)
            key = "Single Leg Errors"
        case 6: value = String(assessment?.trial3TandemLegErrors ?? 0)
            key = "Tandem Leg Errors"
        case 7: value = String(assessment?.trial2MemoryScore ?? 0) + " of 5"
            key = "Short Term Memory Score"
        case 8: value = String(assessment?.trial3MemoryScore ?? 0) + " of 1"
            key = "Month Memory Score"
        case 9: value = String(assessment?.trial4MemoryScore ?? 0) + " of 5"
            key = "Long Term Memory Score"
        default:
            let symptom = assessment?.symptoms[index - 10]
            key = symptom?.name ?? ""
            value = String(symptom?.severity ?? 0)
        }
        return "\(key): \(value)"
    }

}

extension ViewAssessmentResultViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (assessment?.numberOfSymptoms() ?? 0) + 10
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
