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
        SettingsService.settings.sink(receiveValue: { [weak self] settings in
            self?.sortTasksBy(settings: settings)
            if settings.notificationsEnabled {
                self?.dataProvider.scheduleAllNotifications()
            } else {
                self?.dataProvider.removeAllPendingNotifications()
            }
        }).store(in: &cancelables)
    }

    private func sortTasksBy(settings: Settings) {
        if settings.alphabeticalSort {
            dataProvider.changeSort(descriptor: NSSortDescriptor(key: #keyPath(DBTask.name),
                                                                 ascending: false,
                                                                 selector: #selector(NSString.caseInsensitiveCompare(_:))))
        }

        dataProvider.changeSort(descriptor: NSSortDescriptor(key: #keyPath(DBTask.deadline),
                                                             ascending: false,
                                                             selector: #selector(NSString.caseInsensitiveCompare(_:))))
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
