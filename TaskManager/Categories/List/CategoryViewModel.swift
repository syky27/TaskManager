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

    var categories: [Category] {
        dataProvider.categories.value
    }

    var categoriesPublisher: CurrentValueSubject<[Category], Error> {
        dataProvider.categories
    }

    private let dataProvider: CategoriesDataProviderProtocol
    var categoriesChanged: (() -> Void)?

    init(dataProvider: CategoriesDataProviderProtocol = CDCategoriesDataProvider()) {
        self.dataProvider = dataProvider
    }
}
