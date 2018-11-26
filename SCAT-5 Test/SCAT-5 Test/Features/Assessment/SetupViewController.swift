//
//  SetupViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    
    @IBOutlet weak var athleteImageView: UIImageView!
    @IBOutlet weak var athletePickerView: UIPickerView!

    var athletes: [SCAT5Athlete] = [] {
        didSet {
            athletePickerView.reloadAllComponents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        athletePickerView.dataSource = self
        athletePickerView.delegate = self

        if let manager = try? Container.resolve(DataManager.self) {
            manager.getAthletes{ [weak self] (allAthletes) in
                guard let strongSelf = self else { return }

                strongSelf.athletes = allAthletes
                if let image = strongSelf.athletes.first?.profileImage {
                    strongSelf.athleteImageView.image = image
                } else if let athlete = strongSelf.athletes.first as? SCAT5AthleteFlyweight {
                    manager.getAthletePicture(athlete) { (fetchedImage) in
                        if fetchedImage != nil {
                            strongSelf.athleteImageView.image = fetchedImage
                        }
                    }
                }
            }
        }
    }

    @IBAction func nextPressed(_ sender: Any) {
        goToNext()
    }

    private func goToNext() {
        let currentTest = SCAT5Flyweight()
        currentTest.memoryListUsed = WordLists.getRandomList()

        let selectedRow = athletePickerView.selectedRow(inComponent: 0)
        currentTest.playerID = (athletes[selectedRow] as? SCAT5AthleteFlyweight)?.hashedID()

        if let manager = try? Container.resolve(DataManager.self) {
            currentTest.trainerID = manager.currentUser?.firebaseUser?.uid
            manager.currentTest = currentTest
        }

        performSegue(withIdentifier: "segueToSymptoms", sender: self)
    }

}

extension SetupViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == athletePickerView {
            guard let athlete = athletes[row] as? SCAT5AthleteFlyweight else { return }
            if let image = athlete.profileImage {
                athleteImageView.image = image
            } else {
                athleteImageView.image = UIImage(named: "Default Profile")
                if let manager = try? Container.resolve(DataManager.self) {
                    manager.getAthletePicture(athlete) { [weak self] (image) in
                        if image != nil {
                           self?.athleteImageView.image = image
                        }
                    }
                }
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == athletePickerView {
            return athletes.count
        } else {
            return 0
        }
    }

    func stringFor(pickerView: UIPickerView, at row: Int) -> String {
        if pickerView == athletePickerView {
            let athlete = athletes[row]
            let name = athlete.name ?? ""
            return name
        } else {
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label: UILabel
        if pickerView == athletePickerView {
            label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 21))
            label.text = stringFor(pickerView: pickerView, at: row)
            label.textAlignment = .center
            return label
        }
        return UILabel()
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == athletePickerView {
            return 21
        }
        return 0
    }
}
