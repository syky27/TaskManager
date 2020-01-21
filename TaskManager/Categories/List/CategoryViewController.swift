//
//  CategoryTableViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine

class CategoryViewController: UIViewController {

    var viewModel = CategoryViewModel()

    var didSelectCategory: ((_ category: Category) -> Void)?

    var subscriptions = [AnyCancellable]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view = tableView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        bind()
    }

    @objc func add() {
        navigationController?.pushViewController(EditCategoryViewController(viewModel: EditCategoryViewModel()), animated: true)
    }

    func bind() {
        subscriptions = [
            viewModel.categoriesPublisher.sink(receiveCompletion: {_ in }, receiveValue: { _ in
                self.tableView.reloadData(with: .automatic)
            })
        ]
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let callback = didSelectCategory {
            callback(viewModel.categories[indexPath.row])
        } else {
            navigationController?.pushViewController(EditCategoryViewController(viewModel: EditCategoryViewModel(category: viewModel.categories[indexPath.row])), animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard didSelectCategory != nil else {
            return indexPath
        }

        if let oldIndex = tableView.indexPathForSelectedRow {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        return indexPath
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

}

extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? CategoryTableViewCell ??
            CategoryTableViewCell(style: .default, reuseIdentifier: CategoryTableViewCell.reuseIdentifier)

        cell.viewModel = CategoryCellViewModel(category: viewModel.categories[indexPath.row])
        return cell
    }
}
