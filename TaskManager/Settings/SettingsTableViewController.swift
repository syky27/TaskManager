//
//  SettingsTableViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override var title: String? {
        get { "Settings" }
        set(newValue) { super.title = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigationController?.pushViewController(CategoryViewController(), animated: true)
        case 1:
            SettingsService.toggle(key: .alphabeticalOrder)
            tableView.reloadData()
        default:
            SettingsService.toggle(key: .notifications)
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Categories"
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = "Sorting"
            cell.detailTextLabel?.text = SettingsService.get().alphabeticalSort ? "Alphabetical" : "By Date"
            return cell
        default:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = "Notifications"
            cell.detailTextLabel?.text = SettingsService.get().notificationsEnabled ? "Enabled" : "Disabled"
            return cell
        }
    }
}
