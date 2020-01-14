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
    func save(category: Category, completion: @escaping (Result<Void, Error>) -> Void)
}

class CategoryService: CategoryServiceProtocol {
    func save(category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        let managedObject = DBCategory(context: CoreDataManager.shared.context)
        managedObject.name = category.name
        do {
            try CoreDataManager.shared.saveContext()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
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
