//
//  ReactiveTasksViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 21/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import Combine

class TasksViewModel {

    var tasksPublisher: CurrentValueSubject<[Task], Error> {
        dataProvider.tasks
    }

    var tasks: [Task] {
        tasksPublisher.value
    }

    private let dataProvider: TasksDataProviderProtocol

    var cancelables: [AnyCancellable] = []

    init(data: TasksDataProviderProtocol = CDTasksDataProvider()) {
        dataProvider = data
        cancelables = [
            SettingsService.didChange.sink(receiveValue: { [weak self] settings in
                self?.sortTasksBy(settings: settings)
                if settings.notificationsEnabled {
                    self?.dataProvider.scheduleAllNotifications()
                } else {
                    self?.dataProvider.removeAllPendingNotifications()
                }
            })
        ]
    }

    private func sortTasksBy(settings: Settings) {
        // TODO: sorting
//        if settings.alphabeticalSort {
//            self.tasks = tasks.sorted(by: { $0.name.compare($1.name) == .orderedAscending })
//            self.tasksChanged?()
//            return
//        }
//
//        self.tasks = tasks.sorted(by: { $0.deadline.compare($1.deadline) == .orderedAscending })
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

    func delete(task: Task) {
        // swiftlint:disable:next force_try
        try! dataProvider.delete(task: task)
    }

    func resolve(task: Task) {
        // swiftlint:disable:next force_try
        try! dataProvider.resolve(task: task)
    }
}
