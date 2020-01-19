//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewModel: TaskCellViewModel? {
        didSet {
            setup()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let margin: CGFloat = 4.0

        contentView.addSubview(nameLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(categoryLabel)

        [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            deadlineLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: margin),
            deadlineLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            deadlineLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: margin),
            categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ].forEach { $0.isActive = true}

    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        deadlineLabel.text = viewModel.deadline.description
        categoryLabel.text = viewModel.categoryName
        categoryLabel.backgroundColor = UIColor(hex: viewModel.categoryColor)

    }
}