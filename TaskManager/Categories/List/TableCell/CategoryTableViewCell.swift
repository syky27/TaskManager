//
//  CategoryTableViewCell.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit
import SnapKit

class CategoryTableViewCell: UITableViewCell {

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    private let colorView = UIView()

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
        let spacing: CGFloat = 12

        contentView.addSubview(label)
        contentView.addSubview(colorView)

        label.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(contentView).inset(spacing)
        }

        colorView.snp.makeConstraints { make in
            make.trailing.equalTo(contentView).inset(spacing)
            make.height.width.equalTo(label.snp.height)
            make.top.equalTo(label.snp.top)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSubviews()
        colorView.layer.cornerRadius = colorView.bounds.height/2
    }

    private func setup() {
        guard let viewModel = viewModel else { return }
        label.text = viewModel.name
        colorView.backgroundColor = UIColor(hex: viewModel.color)
    }
}
