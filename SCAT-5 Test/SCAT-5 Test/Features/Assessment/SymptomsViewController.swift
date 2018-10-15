//
//  SymptomsViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!

    var assessment: SCAT5Test?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let manager = try? Container.resolve(DataManager.self) else { return }
        assessment = manager.currentTest
        tableView.dataSource = self
        assessment?.symptoms = Symptoms.getNewSymptomList()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let manager = try? Container.resolve(DataManager.self) {
            manager.currentTest = assessment
        }
    }

}

extension SymptomsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assessment?.symptoms.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "symptomCell", for: indexPath) as? SymptomTableViewCell else {
            assertionFailure()
            return UITableViewCell()
        }

        guard let symptom = assessment?.symptoms else {
            assertionFailure()
            return cell
        }

        cell.configure(for: symptom[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension SymptomsViewController: SymptomTableViewCellDelegate {
    func updateSymptom(_ symptom: Symptom) {
        if let index = assessment?.symptoms.firstIndex(where: {return $0.name == symptom.name}) {
            assessment?.symptoms[index] = symptom
        }

    }


}
