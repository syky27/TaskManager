//
//  CategoryViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import CoreData
import Combine

class CategoryViewModel {
    var categories = [Category]()
    private let categoryService: CategoryServiceProtocol
    var categoriesChanged: (() -> Void)?

    init(categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
    }

    func fetchCategories() {
        categoryService.getAll { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.categoriesChanged?()
            case .failure(let error):
                // TODO: Handle in production
                print(error)
            }
        }
    }
}
