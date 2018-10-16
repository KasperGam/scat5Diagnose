//
//  SetupViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var athletePickerView: UIPickerView!
    @IBOutlet weak var memoryListPickerView: UIPickerView!

    var athletes: [SCAT5Athlete] = [] {
        didSet {
            athletePickerView.reloadAllComponents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        athletePickerView.dataSource = self
        athletePickerView.delegate = self
        memoryListPickerView.dataSource = self
        memoryListPickerView.delegate = self

        if let manager = try? Container.resolve(DataManager.self) {
            manager.getAthletes{ [weak self] (allAthletes) in
                self?.athletes = allAthletes
            }
        }
    }

    @IBAction func nextPressed(_ sender: Any) {
        goToNext()
    }

    private func goToNext() {
        let currentTest = SCAT5Flyweight()
        switch memoryListPickerView.selectedRow(inComponent: 0) {
        case 0:
            currentTest.memoryListUsed = wordList1
        case 1:
            currentTest.memoryListUsed = wordList2
        case 2:
            currentTest.memoryListUsed = wordList3
        case 3:
            currentTest.memoryListUsed = wordList4
        default:
            currentTest.memoryListUsed = wordList1
        }

        let selectedRow = athletePickerView.selectedRow(inComponent: 0)
        currentTest.playerID = athletes[selectedRow].name

        if let manager = try? Container.resolve(DataManager.self) {
            currentTest.trainerID = manager.currentUser?.firebaseUser?.uid
            manager.currentTest = currentTest
        }

        performSegue(withIdentifier: "segueToSymptoms", sender: self)
    }

}

extension SetupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == athletePickerView {
            return athletes.count
        } else if pickerView == memoryListPickerView {
            return 4
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == athletePickerView {
            let athlete = athletes[row]
            let name = athlete.name ?? ""
            let dob = athlete.dobString() ?? ""
            return "\(name) \(dob)"
        } else if pickerView == memoryListPickerView {
            return "Word List \(row + 1)"
        } else {
            return ""
        }
    }

}
