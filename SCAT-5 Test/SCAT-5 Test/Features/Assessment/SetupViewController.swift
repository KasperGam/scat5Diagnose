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

    override func viewDidLoad() {
        super.viewDidLoad()
        athletePickerView.dataSource = self
        athletePickerView.delegate = self
        memoryListPickerView.dataSource = self
        memoryListPickerView.delegate = self
    }

    @IBAction func nextPressed(_ sender: Any) {
        goToNext()
    }

    private func goToNext() {
        let currentTest = SCAT5Freewheel()
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
        currentTest.playerID = DummyRosterModel().athleteString(for: IndexPath(row: selectedRow, section: 0))

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
            return DummyRosterModel().numberOfAthletes
        } else if pickerView == memoryListPickerView {
            return 4
        } else {
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == athletePickerView {
            return DummyRosterModel().athleteString(for: IndexPath(row: row, section: component))
        } else if pickerView == memoryListPickerView {
            return "Word List \(row + 1)"
        } else {
            return ""
        }
    }

}

class DummyRosterModel {

    var numberOfAthletes = 16

    func athleteString(for indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0:
            return "Taquon Marshall 09/20/1996"
        case 1:
            return "Aua Searcy 01/07/1996"
        case 2:
            return "Step Durham 06/10/1995"
        case 3:
            return "Lamont Simmons 10/07/1995"
        case 4:
            return "Devin Smith 09/23/1999"
        case 5:
            return "Bruce Jordan-Swilling 09/22/1997"
        case 6:
            return "Tre Swilling 03/26/1999"
        case 7:
            return "AJ Gray 07/03/1996"
        case 8:
            return "Victor Alexander 07/23/1996"
        case 9:
            return "Jay Jones 05/17/1998"
        case 10:
            return "Lucas Johnson 12/03/1997"
        case 11:
            return "Christian Campbell 11/05/1996"
        case 12:
            return "Avery Showell 08/12/1999"
        case 13:
            return "Chase Martenson 10/29/1995"
        case 14:
            return "Ricky Jeune 12/03/1993"
        case 15:
            return "Matthew Jordan 03/15/1996"
        default:
            return ""
        }
    }


}
