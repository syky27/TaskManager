//
//  TaskDataProviderProtocol.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 21/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Combine

protocol TasksDataProviderProtocol {

    var tasks: CurrentValueSubject<[Task], Error> { get }

    func updateExisting(task: Task, with newTask: Task) throws
    func createNew(task: Task) throws
    func delete(task: Task) throws
    func resolve(task: Task) throws
    func removeAllPendingNotifications()
    func scheduleAllNotifications()
}
