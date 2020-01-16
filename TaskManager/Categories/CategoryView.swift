//
//  CategoryTableViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class CategoryView: UIViewController {
    let reuseID = "CategoryTableViewCell"

    var categoryViewModel = CategoryViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        categoryViewModel.fetchCategories()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = tableView
        categoryViewModel.fetchCategories()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        bind()
    }

    @objc func add() {
        // iOS 13 presentation work around, to get back to old behaviour
        // presentationControllerDidDismiss(_ presentationController: UIPresentationController)
        // does not get called when the VC gets dissmissed, only when it is dragged down...
        // see UIAdaptivePresentationControllerDelegate
        let editViewController = UINavigationController(rootViewController: EditCategoryViewController(viewModel: EditCategoryViewModel()))
        editViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(editViewController, animated: true, completion: nil)

    }

    func bind() {
        categoryViewModel.categoriesChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension CategoryView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as? CategoryTableViewCell ?? CategoryTableViewCell(style: .default, reuseIdentifier: reuseID)

        cell.viewModel = CategoryCellViewModel(category: categoryViewModel.categories[indexPath.row])
        return cell
    }
}
