//
//  EditTaskViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine

class EditTaskViewController: UIViewController {

    private let nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = "Name"
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Category", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(categoryAction), for: .touchUpInside)
        return button
    }()

    private let deadlineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose Deadline", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deadlineAction), for: .touchUpInside)
        return button
    }()

    var cancelables: [AnyCancellable] = []

    override var title: String? {
        get {
            viewModel.name == "" ? "New Task" : "Editing \(viewModel.name ?? "Task")"
        }
        set {
            super.title = newValue
        }
    }

    let viewModel: EditTaskViewModel

    init(viewModel: EditTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @objc func categoryAction() {
        navigationController?.pushViewController(CategoryViewController(), animated: true)
    }

    @objc func deadlineAction() {
        print("Picker")
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
        let margin: CGFloat = 8

        view.backgroundColor = .white
        view.addSubview(nameField)
        view.addSubview(errorLabel)
        view.addSubview(categoryButton)
        view.addSubview(deadlineButton)

        errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin).isActive = true
        nameField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        nameField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: margin).isActive = true

        categoryButton.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: margin).isActive = true
        categoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        categoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin).isActive = true

        deadlineButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: margin).isActive = true
        deadlineButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: margin).isActive = true
        deadlineButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -margin).isActive = true

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
            viewModel.$name.assign(to: \.text, on: nameField),
            viewModel.$deadline.sink(receiveValue: { [weak self] date in
                self?.deadlineButton.setTitle(date?.description, for: .normal)
            }),

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
