//
//  CategoryService.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import CoreData
import UIKit

protocol CategoryServiceProtocol {
    func getAll(completion: @escaping (Result<[Category], Error>) -> Void)
    func updateExisting(category: Category, with newCategory: Category) throws
    func createNew(category: Category) throws
}

class CategoryCoreDataService: CategoryServiceProtocol {

    func updateExisting(category: Category, with newCategory: Category) throws {
        guard let categoryID = category.categoryID else {
            fatalError("Missing Category ID")
        }

        let context = CoreDataManager.shared.context

        if let existingManagedObject = try context.existingObject(with: categoryID) as? DBCategory {
            existingManagedObject.name = newCategory.name
            existingManagedObject.color = newCategory.color
        }

        try CoreDataManager.shared.saveContext()
    }

    func createNew(category: Category) throws {
        let managedObject = DBCategory(context: CoreDataManager.shared.context)
        managedObject.name = category.name
        managedObject.color = category.color

        try CoreDataManager.shared.saveContext()
    }

    func getAll(completion: @escaping (Result<[Category], Error>) -> Void) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<DBCategory> = DBCategory.fetchRequest()

        do {
            let dbCategories = try context.fetch(request)
            let categories: [Category] = dbCategories.compactMap { $0.category() }
            completion(.success(categories))
        } catch let error {
            completion(.failure(error))
        }
    }
}
