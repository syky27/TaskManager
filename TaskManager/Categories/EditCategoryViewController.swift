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
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = "Name"
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    var cancelables: [AnyCancellable] = []

    override var title: String? {
        get {
            viewModel.name == "" ? "New Category" : "Editing \(viewModel.name ?? "Category")"
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

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)

        errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
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
        cancelables = [
            viewModel.$name.assign(to: \.text, on: textField),
            viewModel.$errorText.assign(to: \.text, on: errorLabel),
            viewModel.$errorTextHidden.assign(to: \.isHidden, on: errorLabel)
        ]

        viewModel.didFinishEditing = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.name = sender.text ?? ""
    }
}
