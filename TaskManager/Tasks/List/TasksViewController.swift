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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.backgroundColor = .white
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
}

extension TasksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.tasks.filter({!$0.done}).count
        }

        return viewModel.tasks.filter({$0.done}).count
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

        switch indexPath.section {
        case 0:
            cell.viewModel = TaskCellViewModel(task: viewModel.tasks.filter({!$0.done})[indexPath.row])
        default:
            cell.viewModel = TaskCellViewModel(task: viewModel.tasks.filter({!$0.done})[indexPath.row])
        }

        return cell
    }
}
