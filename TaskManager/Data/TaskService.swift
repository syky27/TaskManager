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
    var taskID: String
    var name: String
    var deadline: Date
    var done: Bool
    var category: Category
}

protocol TaskServiceProtocol {
    func getAll(completion: @escaping (Result<[Task], Error>) -> Void)
    func updateExisting(task: Task, with newTask: Task) throws
    func createNew(task: Task) throws
}

class TaskService: TaskServiceProtocol {

    func updateExisting(task: Task, with newTask: Task) throws {
        let context = CoreDataManager.shared.context
        let predicate = NSPredicate(format: "taskID == %@", task.taskID)

        let request: NSFetchRequest<DBTask> = DBTask.fetchRequest()
        request.predicate = predicate

        if let existingManagedObject = try context.fetch(request).first {
            existingManagedObject.name = newTask.name
            existingManagedObject.deadline = newTask.deadline
            existingManagedObject.done = newTask.done
            // TODO: Get CD Category
//            existingManagedObject.category = newTask.category
        }

        try CoreDataManager.shared.saveContext()
    }

    func createNew(task: Task) throws {
        let managedObject = DBTask(context: CoreDataManager.shared.context)
        managedObject.name = task.name
        managedObject.deadline = task.deadline
        managedObject.done = task.done

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
