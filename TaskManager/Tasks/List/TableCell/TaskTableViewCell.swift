//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {

    private var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private var deadlineLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()

    private var categoryColorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = colorView.bounds.height/2
        colorView.layer.borderColor = UIColor.black.cgColor
        return colorView
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
        let spacing: CGFloat = 8.0

        contentView.addSubview(nameLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryColorView)

        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(spacing)
        }

        deadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(spacing)
            make.bottom.leading.equalTo(contentView).inset(spacing)
            make.width.equalTo(contentView.bounds.width / 2)
        }

        categoryColorView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(spacing)
            make.top.equalTo(deadlineLabel.snp.top)
            make.height.equalTo(deadlineLabel.snp.height)
            make.width.equalTo(deadlineLabel.snp.height)
        }

        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryColorView.snp.top)
            make.trailing.equalTo(categoryColorView.snp.leading).inset(-spacing)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutSubviews()
        categoryColorView.layer.cornerRadius = categoryColorView.bounds.height/2
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.name
        deadlineLabel.text = viewModel.deadline.uiString()
        categoryLabel.text = viewModel.categoryName
        categoryColorView.backgroundColor = UIColor(hex: viewModel.categoryColor)
    }
}
