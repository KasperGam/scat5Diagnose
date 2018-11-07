//
//  MyAthletesViewController.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 11/5/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class MyAthletesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var athletes: [SCAT5Athlete] = []
    var selectedAthlete: SCAT5Athlete?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load data
        guard let dataManager = try? Container.resolve(DataManager.self) else { return }
        dataManager.getAthletes{ [weak self] (athletes) in
            self?.athletes = athletes
            self?.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? AthleteDetailViewController {
            detail.athlete = selectedAthlete
        }
    }
}

extension MyAthletesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athletes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyAthletesCell") else {
            assertionFailure()
            return UITableViewCell()
        }
        cell.textLabel?.text = athletes[indexPath.row].name
        return cell
    }
}

extension MyAthletesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAthlete = athletes[indexPath.row]
        // Segue to detail with athlete
        performSegue(withIdentifier: "toAthleteDetail", sender: self)
    }
}
