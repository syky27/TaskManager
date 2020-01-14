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
                // TODO: Handle
                print(error)
            }
        }
    }

    func saveCategory(category: Category) {
        categoryService.save(category: category) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                self?.fetchCategories()
            }

        }
    }
}
