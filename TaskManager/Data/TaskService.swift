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
    var notify: Bool
    var category: Category
}

protocol TaskServiceProtocol {
    func getAll(completion: @escaping (Result<[Task], Error>) -> Void)
    func updateExisting(task: Task, with newTask: Task) throws
    func createNew(task: Task) throws
    func delete(task: Task) throws
    func resolve(task: Task) throws
    func removeAllPendingNotifications()
    func scheduleAllNotifications()
}

class TaskService: TaskServiceProtocol {

    func removeAllPendingNotifications() {
        getAll { result in
            switch result {
            case .success(let tasks):
                tasks.forEach(self.cancelNotificationFor)
            case .failure(let error):
                print(error)
            }
        }
    }

    /// Scheduling notification for all not resolved tasks in future
    func scheduleAllNotifications() {
        getAll { result in
            switch result {
            case .success(let tasks):
                tasks.filter({
                    $0.deadline.compare(Date()) == .orderedDescending
                }).filter({
                    !$0.done
                }).forEach(self.scheduleNotificationFor)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func scheduleNotificationFor(task: Task) {
        guard let taskIDString = task.taskID?.uriRepresentation().absoluteString else {
            fatalError()
        }

        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.name
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.deadline)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: taskIDString, content: content, trigger: trigger)
        center.add(request)
    }

    private func cancelNotificationFor(task: Task) {
        guard let taskIDString = task.taskID?.uriRepresentation().absoluteString else {
            fatalError()
        }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [taskIDString])
    }

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
        guard let taskID = task.taskID, newTask.category.categoryID != nil else {
            fatalError("Missing TaskID or CategoryID")
        }

        let context = CoreDataManager.shared.context
        if let existingManagedObject = try context.existingObject(with: taskID) as? DBTask {
            try existingManagedObject.replaceWith(task: newTask)
            try CoreDataManager.shared.saveContext()

            if existingManagedObject.notify {
                scheduleNotificationFor(task: existingManagedObject.task())
            }
        }
    }

    func createNew(task: Task) throws {
         guard task.category.categoryID != nil else {
                   fatalError("Missing TaskID or CategoryID")
               }

        let managedObject = DBTask(context: CoreDataManager.shared.context)
        try managedObject.replaceWith(task: task)
        try CoreDataManager.shared.saveContext()

        if managedObject.notify {
            scheduleNotificationFor(task: managedObject.task())
        }
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
