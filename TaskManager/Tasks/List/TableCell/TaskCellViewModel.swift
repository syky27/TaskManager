//
//  TaskCellViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation

class TaskCellViewModel {

    private let task: Task

    var name: String {
        task.name
    }

    var isDone: Bool {
        task.done
    }

    var deadline: Date {
        task.deadline
    }

    var categoryName: String {
        task.category.name
    }

    var categoryColor: String {
        task.category.color
    }

    init(task: Task) {
        self.task = task
    }
}
