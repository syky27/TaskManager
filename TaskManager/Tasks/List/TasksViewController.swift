//
//  TasksViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    var viewModel = TasksViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.fetch()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = tableView
        viewModel.fetch()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        bind()
    }

    @objc func add() {
        // iOS 13 presentation work around, to get back to old behaviour
        // presentationControllerDidDismiss(_ presentationController: UIPresentationController)
        // does not get called when the VC gets dissmissed, only when it is dragged down...
        // see UIAdaptivePresentationControllerDelegate
        let editViewController = UINavigationController(rootViewController: EditTaskViewController(viewModel: EditTaskViewModel()))
        editViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(editViewController, animated: true, completion: nil)

    }

    func bind() {
        viewModel.tasksChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let editController = UINavigationController(rootViewController: EditCategoryViewController(viewModel: EditCategoryViewModel(category: categoryViewModel.categories[indexPath.row])))
//        editController.modalPresentationStyle = .fullScreen
//        navigationController?.present(editController, animated: true, completion: nil)
    }
}

extension TasksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? TaskTableViewCell ??
            TaskTableViewCell(style: .default, reuseIdentifier: TaskTableViewCell.reuseIdentifier)

        cell.viewModel = TaskCellViewModel(task: viewModel.tasks[indexPath.row])
        return cell
    }
}
