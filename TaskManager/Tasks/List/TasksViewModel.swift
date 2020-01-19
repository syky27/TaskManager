//
//  TasksViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import CoreData
import Combine

class TasksViewModel {
    var tasks = [Task]()
    private let taskService: TaskServiceProtocol
    var tasksChanged: (() -> Void)?

    var cancelables: [AnyCancellable] = []

    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService

        cancelables = [
            SettingsService.didChange.sink(receiveValue: { [weak self] settings in
                self?.sortTasksBy(settings: settings)
                // TODO: Disable Enable notifications
            })
        ]
    }

    private func sortTasksBy(settings: Settings) {
        if settings.alphabeticalSort {
            self.tasks = tasks.sorted(by: { $0.name.compare($1.name) == .orderedAscending })
            self.tasksChanged?()
            return
        }

        self.tasks = tasks.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
        self.tasksChanged?()
    }

    func numberOfItemsFor(section: Int) -> Int {
        switch section {
        case 0:
            return tasks.filter({!$0.done}).count
        case 1:
            return tasks.filter({$0.done}).count
        default:
            fatalError("Too many sections")
        }
    }

    func getTaskFor(indexPath: IndexPath) -> Task {
        switch indexPath.section {
        case 0:
            return tasks.filter({!$0.done})[indexPath.row]
        case 1:
            return tasks.filter({$0.done})[indexPath.row]
        default:
            fatalError("Too many sections")
        }
    }

    func fetch() {
        taskService.getAll { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                self?.sortTasksBy(settings: SettingsService.settings())
            case .failure(let error):
                // TODO: Handle
                print(error)
            }
        }
    }

    func delete(task: Task) {

        // TODO: handle error
        // swiftlint:disable:next force_try
        try! taskService.delete(task: task)
        // TODO: Combine...?
        fetch()
    }

    func resolve(task: Task) {
        // swiftlint:disable:next force_try
        try! taskService.resolve(task: task)
        fetch()
    }
}
