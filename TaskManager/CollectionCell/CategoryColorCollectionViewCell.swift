//
//  CategoryColorCollectionViewCell.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class CategoryColorCollectionViewCell: UICollectionViewCell {
    var viewModel: CategoryColorCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            indicatorView.backgroundColor = UIColor(hex: viewModel.hex)
        }
    }

    override var isSelected: Bool {
        didSet {
            indicatorView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
        }
      }

    fileprivate let indicatorView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 2.0
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(indicatorView)

        indicatorView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        indicatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
