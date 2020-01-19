//
//  EditCategoryViewController.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import Combine
import SnapKit

let sampleColors = ["#ff1433", "#bc145a", "#ffb732", "#38acff", "#d42069", "#003366"]

class EditCategoryViewController: UIViewController {

    private let textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.placeholder = "Name"
        return textField
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .red
        label.textAlignment = .center
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

    override var title: String? {
        get { viewModel.name == "" ? "New Category" : "Editing \(viewModel.name ?? "Category")" }
        set(newValue) { super.title = newValue }
    }

    var cancelables: [AnyCancellable] = []
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
        let spacing: CGFloat = 16.0
        view.backgroundColor = .white

        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        view.addSubview(colorCollectionView)
        view.addSubview(errorLabel)

        errorLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(16)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(spacing)
        }

        colorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(spacing)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(spacing)
        }
    }

    private func setButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveAction))
    }

    @objc private func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func saveAction() {
        viewModel.action.send(.save)
    }

    private func bindToViewModel() {
        cancelables = [
            viewModel.$name.assign(to: \.text, on: textField),
            viewModel.$color.sink(receiveValue: { colorString in
                self.colorCollectionView.reloadData()
            }),
            viewModel.$errorText.assign(to: \.text, on: errorLabel),
            viewModel.$errorTextHidden.assign(to: \.isHidden, on: errorLabel)
        ]

        viewModel.didFinishEditing = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
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

        if let index =  sampleColors.firstIndex(of: viewModel.color ?? "") {
            if index == indexPath.row {
                cell.isSelected = true
            }
        }

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
