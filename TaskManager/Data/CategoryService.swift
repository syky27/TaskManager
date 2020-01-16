//
//  CategoryService.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 14/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import CoreData
import UIKit

struct Category {
    var name: String
}

protocol CategoryServiceProtocol {
    func getAll(completion: @escaping (Result<[Category], Error>) -> Void)
    func updateExisting(category: Category, with newCategory: Category) throws
    func createNew(category: Category) throws
}

class CategoryService: CategoryServiceProtocol {

    func updateExisting(category: Category, with newCategory: Category) throws {
        let context = CoreDataManager.shared.context
        let predicate = NSPredicate(format: "name == %@", category.name)

        let request: NSFetchRequest<DBCategory> = DBCategory.fetchRequest()
        request.predicate = predicate

        if let existingManagedObject = try context.fetch(request).first {
            existingManagedObject.name = newCategory.name
        }

        try CoreDataManager.shared.saveContext()
    }

    func createNew(category: Category) throws {
        let managedObject = DBCategory(context: CoreDataManager.shared.context)
        managedObject.name = category.name

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
