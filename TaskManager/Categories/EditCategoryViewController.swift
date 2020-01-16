//
//  EditCategoryViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine

class EditCategoryViewController: UIViewController {

    private let textField: UITextField = {
        let textField = UITextField()
        // TODO: Move to localize strings
        textField.placeholder = "Name"
        return textField
    }()

    private var textFieldSubscriber: AnyCancellable?

    override var title: String? {
        get {
            viewModel.name.value == "" ? "New Category" : "Editing \(viewModel.name)"
        }
        set {
            super.title = newValue
        }
    }

    let viewModel: EditCategoryViewModel

    init(viewModel: EditCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setButtons()
        bindToViewModel()
    }

    private func layout() {

        view.backgroundColor = .white

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
    }

    private func setButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
    }

    @objc private func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func saveAction() {
        viewModel.action.send(.save)
    }

    private func bindToViewModel() {
        textFieldSubscriber = viewModel.name.assign(to: \.text, on: textField)

        viewModel.didFinishEditing = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
