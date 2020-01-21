//
//  TasksViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine

class TasksViewController: UIViewController {

    var viewModel = TasksViewModel()

    override var title: String? {
        get { "Tasks" }
        set(newValue) { super.title = newValue }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    var subscriptions = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = tableView
        configureBarButtons()
        bind()
    }

    func configureBarButtons() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsAction))
    }

    @objc func addAction() {
        navigationController?.present(UINavigationController(rootViewController: EditTaskViewController(viewModel: EditTaskViewModel())),
                                      animated: true,
                                      completion: nil)
    }

    @objc func settingsAction() {
        navigationController?.present(UINavigationController(rootViewController: SettingsTableViewController()),
                                      animated: true,
                                      completion: nil)
    }

    func bind() {
        subscriptions = [
            viewModel.tasksPublisher.sink(receiveCompletion: {_ in }, receiveValue: { _ in
                self.tableView.reloadData(with: .automatic)
            })
        ]
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UINavigationController(rootViewController:
            EditTaskViewController(viewModel:
                EditTaskViewModel(task: viewModel.getTaskFor(indexPath: indexPath))))

        navigationController?.present(controller, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension TasksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemsFor(section: section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Active"
        }

        return "Resolved"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? TaskTableViewCell ??
            TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.reuseIdentifier)
        cell.viewModel = TaskCellViewModel(task: self.viewModel.getTaskFor(indexPath: indexPath))

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(task: viewModel.getTaskFor(indexPath: indexPath))
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let resolveAction = UIContextualAction(style: .normal, title: "Close") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.viewModel.resolve(task: self.viewModel.getTaskFor(indexPath: indexPath) )
        }

            resolveAction.image = UIImage(systemName: "checkmark.rectangle")
            resolveAction.backgroundColor = UIColor(hex: "#00cc66")

            return UISwipeActionsConfiguration(actions: [resolveAction])
    }
}
