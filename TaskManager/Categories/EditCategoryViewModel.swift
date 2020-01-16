//
//  EditCategoryViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation

class EditCategoryViewModel {

    private let category: Category?

    var name: String {
        category?.name ?? ""
    }

    init(category: Category? = nil) {
        self.category = category
    }
}
