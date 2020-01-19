//
//  EditTaskViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine
import SnapKit

class EditTaskViewController: UIViewController {

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private let nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = "Name"
        return textField
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

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.minimumDate = Date()
        picker.datePickerMode = .dateAndTime
        picker.addTarget(self, action: #selector(pickerValueChanged), for: .valueChanged)
        return picker
    }()

    private let isDoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Active", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(isDoneAction), for: .touchUpInside)
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
        let spacing: CGFloat = 12

        view.backgroundColor = .white
        view.addSubview(nameField)
        view.addSubview(errorLabel)
        view.addSubview(categoryButton)
        view.addSubview(datePicker)
        view.addSubview(isDoneButton)

        nameField.snp.makeConstraints { make in
            make.left.top.right.equalTo(view.safeAreaLayoutGuide).inset(spacing)
        }

        categoryButton.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(spacing)
            make.left.right.equalTo(view).inset(spacing)
        }

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(spacing)
            make.left.right.equalTo(view).offset(spacing)
        }

        isDoneButton.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(spacing)
            make.left.right.equalTo(view).inset(spacing)
        }

    }

    private func bindToViewModel() {
        cancelables = [
            viewModel.$name.assign(to: \.text, on: nameField),
            viewModel.$deadline.sink(receiveValue: { [weak self] date in
                if let date = date {
                    self?.datePicker.setDate(date, animated: true)
                } else {
                    self?.datePicker.setDate(Date(), animated: true)
                }
            }),

            viewModel.$category.sink(receiveValue: { [weak self] category in
                if let category = category {
                    self?.categoryButton.setTitle("Category: \(category.name)", for: .normal)
                } else {
                    self?.categoryButton.setTitle("Choose Category", for: .normal)
                }
            }),

            viewModel.$isDone.sink(receiveValue: { [weak self] isDone in
                let status = isDone ?? false ? "resolved" : "active"
                self?.isDoneButton.setTitle("Status: \(status)", for: .normal)
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

    // MARK: - Form Life cycle

    @objc func textFieldDidChange(_ sender: UITextField) {
        viewModel.name = sender.text ?? ""
    }

    @objc func pickerValueChanged(picker: UIDatePicker) {
        viewModel.deadline = picker.date
    }

    @objc func isDoneAction() {
        viewModel.isDone = !(viewModel.isDone ?? false)
    }

    @objc func categoryAction() {
        let controller = CategoryViewController()
        controller.didSelectCategory = { [weak self] (category) in
            self?.viewModel.category = category
        }

        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - View Life cycle

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
}
