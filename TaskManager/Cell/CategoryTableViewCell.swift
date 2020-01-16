//
//  CategoryTableViewCell.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    private let label = UILabel()

    var viewModel: CategoryCellViewModel? {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func setup() {
        label.text = viewModel?.name ?? ""
    }
}
