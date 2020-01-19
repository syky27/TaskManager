//
//  UITableView+TaskManager.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 19/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}
