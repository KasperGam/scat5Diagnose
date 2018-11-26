//
//  AthleteDetailViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 11/5/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class AthleteDetailViewController: UIViewController {

    var athlete: SCAT5Athlete?
    var assessments: [SCAT5Test] = [] {
        didSet {
            previousAssessmentsTableView.reloadData()
        }
    }

    var selectedAssessment: SCAT5Test?

    @IBOutlet weak var athleteProfileImageView: UIImageView!

    @IBOutlet weak var athleteNameLabel: UILabel!

    @IBOutlet weak var previousAssessmentsTableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        previousAssessmentsTableView.register(UINib(nibName: "PreviousAssessmentsTableViewCell", bundle: nil), forCellReuseIdentifier: "PreviousAssessmentsTableViewCell")
        setupForAthlete()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selected = previousAssessmentsTableView.indexPathForSelectedRow {
            previousAssessmentsTableView.deselectRow(at: selected, animated: false)
        }
    }

    private func setupForAthlete() {
        // Setup data
        athleteNameLabel.text = athlete?.name

        guard let athlete = athlete as? SCAT5AthleteFlyweight else { return }
        guard let dataManager = try? Container.resolve(DataManager.self) else { return }

        dataManager.getAthletePicture(athlete, completion: { [weak self] (image) in
            if image != nil {
                self?.athleteProfileImageView.image = image
            }
        })

        guard let trainerID = dataManager.currentUser?.firebaseUser?.uid else { return }

        dataManager.getAssessments(for: athlete, andTrainer: trainerID, completion: {[weak self] (tests) in
            self?.assessments = tests
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? ViewAssessmentResultViewController {
            detailVC.assessment = selectedAssessment as? SCAT5Flyweight
        }
    }

}

extension AthleteDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = assessments.count
        if count > 0 {
            return count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if assessments.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousAssessmentsTableViewCell", for: indexPath) as? PreviousAssessmentsTableViewCell else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.update(with: assessments[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviousAssessmentsCell") else {
                assertionFailure()
                return UITableViewCell()
            }
            cell.textLabel?.text = "No previous assessments"
            return cell
        }
    }
}

extension AthleteDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAssessment = assessments[indexPath.row]
        performSegue(withIdentifier: "toResults", sender: self)
    }
}
