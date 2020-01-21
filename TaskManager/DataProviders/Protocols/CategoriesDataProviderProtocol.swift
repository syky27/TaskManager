//
//  CategoriesDataProviderProtocol.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 21/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Combine

protocol CategoriesDataProviderProtocol {

    var categories: CurrentValueSubject<[Category], Error> { get }

    func updateExisting(category: Category, with newCategory: Category) throws
    func createNew(category: Category) throws
}
