//
//  SymptomTableViewCell.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

protocol SymptomTableViewCellDelegate: class {
    func updateSymptom(_ symptom: Symptom)
}

class SymptomTableViewCell: UITableViewCell {

    @IBOutlet weak var symptomNameLabel: UILabel!
    @IBOutlet weak var severityIndicatorLabel: UILabel!
    @IBOutlet weak var severityControl: UISegmentedControl!

    var symptom: Symptom?
    weak var delegate: SymptomTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        severityControl.selectedSegmentIndex = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        symptom = nil
        severityControl.selectedSegmentIndex = 0
        severityIndicatorLabel.text = "0"
        symptomNameLabel.text = ""
    }

    func configure(for symptom: Symptom) {
        severityControl.selectedSegmentIndex = symptom.severity
        severityIndicatorLabel.text = String(symptom.severity)
        symptomNameLabel.text = symptom.name
        self.symptom = symptom
    }
    @IBAction func severityChanged(_ sender: Any) {
        let value = severityControl.selectedSegmentIndex
        severityIndicatorLabel.text = String(value)
        symptom?.severity = value
        if let symptom = self.symptom {
            delegate?.updateSymptom(symptom)
        }
    }

}
