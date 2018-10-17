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
    @IBOutlet weak var severitySlider: UISlider!

    var symptom: Symptom?
    weak var delegate: SymptomTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        symptom = nil
        severitySlider.setValue(0, animated: false)
        severityIndicatorLabel.text = "0"
        symptomNameLabel.text = ""
    }

    func configure(for symptom: Symptom) {
        severitySlider.setValue(Float(symptom.severity), animated: false)
        severityIndicatorLabel.text = String(symptom.severity)
        symptomNameLabel.text = symptom.name
        self.symptom = symptom
    }

    @IBAction func severityChanged(_ sender: Any) {
        let value = severitySlider.value.rounded(.toNearestOrEven)
        severityIndicatorLabel.text = String(Int(value))
        severitySlider.setValue(value, animated: false)
        symptom?.severity = Int(value)
        if let symptom = self.symptom {
            delegate?.updateSymptom(symptom)
        }
    }

}
