//
//  CategoryCellViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import UIKit

class CategoryCellViewModel {

    private let category: Category

    var name: String {
        category.name
    }

    var color: String {
        category.color
    }

    init(category: Category) {
        self.category = category
    }
}
