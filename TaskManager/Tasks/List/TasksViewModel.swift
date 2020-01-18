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

    init(taskService: TaskServiceProtocol = TaskService()) {
        self.taskService = taskService
    }

    func fetch() {
        taskService.getAll { result in
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                self.tasksChanged?()
            case .failure(let error):
                // TODO: Handle
                print(error)
            }
        }
    }
}
