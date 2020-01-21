//
//  ReactiveTaskDataSourceProtocol.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 21/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation

import CoreData
import UIKit
import Combine

class CDTasksDataProvider: TasksDataProviderProtocol {

    var tasks = CurrentValueSubject<[Task], Error>([Task]())

    private var fetch: FetchedResultsPublisher<DBTask> = {
        let request: NSFetchRequest<DBTask> = DBTask.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(DBCategory.name),
                                    ascending: true,
                                    selector: #selector(NSString.caseInsensitiveCompare(_:)))
        request.sortDescriptors = [sort]

        return FetchedResultsPublisher(request: request, context: CoreDataManager.shared.context)
    }()

    var cancelables: [AnyCancellable] = []

    init() {
        subscribe()
    }

    func subscribe() {
        fetch.sink(receiveCompletion: { error in
            print(error)
            // TODO: Fixup
        }, receiveValue: { tasks in
            print("Change: FetchedResultsPublisher")
            self.tasks.send(tasks.map { $0.task() })
        }).store(in: &cancelables)
    }

    func changeSort(descriptor: NSSortDescriptor) {
        fetch.request.sortDescriptors = [descriptor]
        let request: NSFetchRequest<DBTask> = DBTask.fetchRequest()

        request.sortDescriptors = [descriptor]

        self.fetch = FetchedResultsPublisher(request: request, context: CoreDataManager.shared.context)
        subscribe()
    }

    func removeAllPendingNotifications() {
        tasks.value.forEach(self.cancelNotificationFor)
    }

    func scheduleAllNotifications() {
        tasks.value.filter({
            $0.deadline.compare(Date()) == .orderedDescending
        }).filter({
            !$0.done
        }).forEach(self.scheduleNotificationFor)
    }

    private func scheduleNotificationFor(task: Task) {
        guard let taskIDString = task.taskID else {
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
        guard let taskID = task.taskID else { return }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [taskID])
    }

    func resolve(task: Task) throws {
        let context = CoreDataManager.shared.context
        let managedObject = try getManagedObjectWith(task: task, in: context)

        managedObject.done = !managedObject.done
        try context.save()
    }

    func delete(task: Task) throws {
        let context = CoreDataManager.shared.context
        let managedObject = try getManagedObjectWith(task: task, in: context)

        context.delete(managedObject)
        try context.save()
    }

    private func getManagedObjectWith(task: Task, in context: NSManagedObjectContext) throws -> DBTask {
        guard let taskID = task.taskID else {
            fatalError("Missing TaskID")
        }

        let fetchRequest = NSFetchRequest<DBTask>(entityName: "DBTask")
        fetchRequest.predicate = NSPredicate(format: "taskID == %@", taskID)

        guard let managedObject = try context.fetch(fetchRequest).first else {
            throw NSError()
        }

        return managedObject
    }

    func updateExisting(task: Task, with newTask: Task) throws {
        guard newTask.category.categoryID != nil else {
            fatalError("Missing TaskID or CategoryID")
        }

        let context = CoreDataManager.shared.context
        let managedObject = try getManagedObjectWith(task: task, in: context)
        try managedObject.replaceWith(task: newTask)
        try context.save()
        if managedObject.notify {
            scheduleNotificationFor(task: managedObject.task())
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
}
