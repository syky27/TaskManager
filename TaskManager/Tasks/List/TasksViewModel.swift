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

    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService
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
        taskService.getAll { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
                self.tasksChanged?()
            case .failure(let error):
                // TODO: Handle
                print(error)
            }
        }
    }
}
