//
//  TaskService.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import CoreData
import UIKit

struct Task {
    var taskID: NSManagedObjectID?
    var name: String
    var deadline: Date
    var done: Bool
    var category: Category
}

protocol TaskServiceProtocol {
    func getAll(completion: @escaping (Result<[Task], Error>) -> Void)
    func updateExisting(task: Task, with newTask: Task) throws
    func createNew(task: Task) throws
    func delete(task: Task) throws
    func resolve(task: Task) throws
}

class TaskService: TaskServiceProtocol {

    func resolve(task: Task) throws {
        guard let taskID = task.taskID else {
            fatalError("Missing TaskID")
        }
        let context = CoreDataManager.shared.context

        if let object = try context.existingObject(with: taskID) as? DBTask {
            object.done = !object.done
        }

        try CoreDataManager.shared.context.save()
    }

    func delete(task: Task) throws {
        guard let taskID = task.taskID else {
            fatalError("Missing TaskID")
        }
        let context = CoreDataManager.shared.context

        if let object = try context.existingObject(with: taskID) as? DBTask {
            context.delete(object)
        }

        try CoreDataManager.shared.context.save()
    }

    func updateExisting(task: Task, with newTask: Task) throws {
        guard let taskID = task.taskID, let categoryID = newTask.category.categoryID else {
            fatalError("Missing TaskID or CategoryID")
        }

        let context = CoreDataManager.shared.context
        if let existingManagedObject = try context.existingObject(with: taskID) as? DBTask {
            existingManagedObject.name = newTask.name
            existingManagedObject.deadline = newTask.deadline
            existingManagedObject.done = newTask.done

            if let existingCategory = try context.existingObject(with: categoryID) as? DBCategory {
                existingManagedObject.category = existingCategory
            }
        }

        try CoreDataManager.shared.saveContext()
    }

    func createNew(task: Task) throws {
        guard let categoryID = task.category.categoryID else {
            fatalError("Missing Category ID")
        }

        let managedObject = DBTask(context: CoreDataManager.shared.context)
        managedObject.name = task.name
        managedObject.deadline = task.deadline
        managedObject.done = task.done
        managedObject.category = try CoreDataManager.shared.context.existingObject(with: categoryID) as? DBCategory

        try CoreDataManager.shared.saveContext()
    }

    func getAll(completion: @escaping (Result<[Task], Error>) -> Void) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<DBTask> = DBTask.fetchRequest()

        do {
            let dbTasks = try context.fetch(request)
            let tasks: [Task] = dbTasks.compactMap { $0.task() }
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
}
