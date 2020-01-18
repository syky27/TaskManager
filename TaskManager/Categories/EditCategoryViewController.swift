//
//  EditCategoryViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine

let sampleColors = ["#f7347a", "#660099", "#0070ff", "#ce8054", "#d42069", "#003366"]

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

    private let colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryColorCollectionViewCell.self, forCellWithReuseIdentifier: CategoryColorCollectionViewCell.reuseIdentifier)
        return collectionView
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

        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
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

        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorCollectionView)

        colorCollectionView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 8).isActive = true
        colorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        colorCollectionView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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

extension EditCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sampleColors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryColorCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as? CategoryColorCollectionViewCell ?? CategoryColorCollectionViewCell()

        cell.viewModel = CategoryColorCellViewModel(colorHex: sampleColors[indexPath.row])
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension EditCategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.color = sampleColors[indexPath.row]
    }
}
