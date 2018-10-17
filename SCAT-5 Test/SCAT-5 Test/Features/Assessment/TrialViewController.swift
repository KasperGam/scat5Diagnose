//
//  TrialViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class TrialViewController: UIViewController {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var wordListTableView: UITableView!
    @IBOutlet weak var monthsOfYearTestView: UIView!
    @IBOutlet weak var legStanceTestView: BalanceTestingView!
    @IBOutlet weak var nextTrialButton: UIButton!
    @IBOutlet weak var monthsOfYearRecallSwitch: UISwitch!

    var assessment: SCAT5Test?

    var currentTrial: TrialViewModel = Trial1ViewModel()
    var currentWordList: [WordRecall]?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        assessment = manager.currentTest
        wordListTableView.dataSource = self
        setupForCurrentTrial()
    }

    @IBAction func nextTrialPressed(_ sender: Any) {
        if var test = assessment {
            currentTrial.updateAssessment(&test, wordList: currentWordList, calendarRecall: monthsOfYearRecallSwitch.isOn, balenceScore: 0)
        }
        if let nextTrial = currentTrial.getNextTrial() {
            currentTrial = nextTrial
            setupForCurrentTrial()
        } else {

            guard let manager = try? Container.resolve(DataManager.self) else {
                return
            }
            manager.currentTest = assessment
            manager.saveCurrentAssessment()
            performSegue(withIdentifier: "toHome", sender: self)
        }
    }

    private func setupForCurrentTrial() {
        if let test = assessment as? SCAT5Flyweight {
            currentWordList = test.trialWordRecall[currentTrial.trialNumber] ?? WordRecall.getNewRecallList(from: test.memoryListUsed ?? wordList1)
        }
        instructionLabel.text = currentTrial.trialInstruction
        wordListTableView.isHidden = !currentTrial.shouldUseWordList
        monthsOfYearTestView.isHidden = !currentTrial.shouldUseCalendarTest
        monthsOfYearRecallSwitch.setOn(false, animated: false)
        legStanceTestView.isHidden = !currentTrial.shouldUseBalanceTest
        nextTrialButton.setTitle(currentTrial.nextTrialButtonString ?? "NEXT", for: UIControl.State())
        legStanceTestView.balanceTestLabel.text = currentTrial.balanceString
        legStanceTestView.numberOfErrorsLabel.text = "0"
        legStanceTestView.errorCount = 0
        wordListTableView.reloadData()
        self.navigationItem.title = "Trial \(currentTrial.trialNumber)"
    }

}

extension TrialViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWordList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "wordListCell", for: indexPath) as? WordListTableViewCell else {
            return UITableViewCell()
        }

        guard let wordRecall = currentWordList?[indexPath.row] else {
            return cell
        }

        cell.configure(with: wordRecall)
        cell.delegate = self

        return cell
    }

}

extension TrialViewController: WordListTableViewCellDelegate {
    func updateWordRecall(_ wordRecall: WordRecall) {
        if let index = currentWordList?.firstIndex(where: {return $0.word == wordRecall.word}) {
            currentWordList?[index] = wordRecall
        }
    }

}
