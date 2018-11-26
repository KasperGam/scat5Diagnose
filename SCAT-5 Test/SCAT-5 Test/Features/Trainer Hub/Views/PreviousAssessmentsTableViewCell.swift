//
//  PreviousAssessmentTableViewCell.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 11/25/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class PreviousAssessmentsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var symptomsCountLabel: UILabel!
    @IBOutlet weak var severityScoreLabel: UILabel!
    @IBOutlet weak var errorCountLabel: UILabel!
    @IBOutlet weak var memoryScoreLabel: UILabel!


    func update(with assessment: SCAT5Test) {
        dateLabel.text = assessment.testDate?.getMMddYYYYHHmma()

        symptomsCountLabel.text = String(assessment.numberOfSymptoms())
        severityScoreLabel.text = String(assessment.sevScore()) + "/132"
        errorCountLabel.text = String(assessment.totalErrors())
        memoryScoreLabel.text = String(assessment.memoryScore()) + "/11"
    }
}
