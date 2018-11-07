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
    @IBOutlet weak var previousTrialButton: UIButton!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var wordRecallCountdownView: CountdownView!

    
    var assessment: SCAT5Test?

    var currentTrial: TrialViewModel = Trial1ViewModel()
    var currentWordList: [WordRecall]?

    var elapsedSeconds: Int = 0 {
        didSet {
            elapsedTimeLabel.text = elapsedSeconds.valueAsTime()
        }
    }

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        assessment = manager.currentTest
        wordListTableView.dataSource = self
        previousTrialButton.isEnabled = false

        // Configure buttons
        nextTrialButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextTrialButton.titleLabel?.minimumScaleFactor = 0.5
        previousTrialButton.titleLabel?.adjustsFontSizeToFitWidth = true
        previousTrialButton.titleLabel?.minimumScaleFactor = 0.5
        elapsedSeconds = 0
        timer?.invalidate()
        timer = nil
        setupForCurrentTrial()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        elapsedSeconds = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let resultsVC = segue.destination as? AssessmentResultsViewController {
            resultsVC.assessment = assessment
        }
    }

    @IBAction func previousTrialPressed(_ sender: Any) {
        if var test = assessment {
            currentTrial.updateAssessment(&test, wordList: currentWordList, calendarRecall: monthsOfYearRecallSwitch.isOn, balenceScore: legStanceTestView.errorCount)
            assessment = test
        }
        if let previousTrial = currentTrial.getPreviousTrial() {
            currentTrial = previousTrial
            previousTrialButton.isEnabled = previousTrial.getPreviousTrial() != nil
            setupForCurrentTrial()
        }

    }

    @IBAction func nextTrialPressed(_ sender: Any) {
        if var test = assessment {
            currentTrial.updateAssessment(&test, wordList: currentWordList, calendarRecall: monthsOfYearRecallSwitch.isOn, balenceScore: legStanceTestView.errorCount)
            assessment = test
        }
        if let nextTrial = currentTrial.getNextTrial() {
            currentTrial = nextTrial
            previousTrialButton.isEnabled = true
            setupForCurrentTrial()
        } else {

            guard let manager = try? Container.resolve(DataManager.self) else {
                return
            }
            assessment?.duration = elapsedSeconds
            timer?.invalidate()
            manager.currentTest = assessment
            manager.saveCurrentAssessment()
            performSegue(withIdentifier: "toCompletion", sender: self)
        }
    }

    private func setupForCurrentTrial() {
        if let test = assessment as? SCAT5Flyweight {
            currentWordList = test.trialWordRecall[currentTrial.trialNumber] ?? WordRecall.getNewRecallList(from: test.memoryListUsed ?? [])
        }
        instructionLabel.text = currentTrial.trialInstruction?.format(with: assessment?.memoryListUsed, elapsedTime: elapsedSeconds)
        wordRecallCountdownView.isHidden = !(currentTrial.showCountdown ?? false)
        wordRecallCountdownView.countDownStart = currentTrial.countDownValue ?? 0
        wordRecallCountdownView.reset()
        wordListTableView.isHidden = !currentTrial.shouldUseWordList
        monthsOfYearTestView.isHidden = !currentTrial.shouldUseCalendarTest
        monthsOfYearRecallSwitch.setOn(currentTrial.calendarScore(from: assessment) > 0 ? true : false, animated: false)
        legStanceTestView.isHidden = !currentTrial.shouldUseBalanceTest
        legStanceTestView.instructionLabel.text = currentTrial.balanceInstruction
        nextTrialButton.setTitle(currentTrial.nextTrialButtonString ?? "NEXT", for: UIControl.State())
        legStanceTestView.balanceTestLabel.text = currentTrial.balanceString
        let balenceErrors = currentTrial.balenceErrors(from: assessment)
        legStanceTestView.numberOfErrorsLabel.text = String(balenceErrors)
        legStanceTestView.errorCount = balenceErrors
        wordListTableView.reloadData()
        self.navigationItem.title = "Assessment \(currentTrial.trialNumber)"
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

fileprivate extension String {
    func format(with list: WordList? = nil, elapsedTime: Int = 0) -> String {

        guard let list = list else { return self }
        if let range = self.range(of: "\\{ *current_word_list *\\}", options: .regularExpression) {
            let newStr = self.replacingCharacters(in: range, with: WordLists.listString(for: list))
            return newStr
        }
        return self
    }
}
