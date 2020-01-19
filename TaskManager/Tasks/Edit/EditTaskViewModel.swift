//
//  EditTaskViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 18/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import Combine

enum EditTaskError: Error {
    case invalidForm(field: String)
}

class EditTaskViewModel {

    enum Action {
        case save
    }

    enum State {
        case initial
        case error(message: String)
    }

    @Published var name: String?
    @Published var deadline: Date?
    @Published var category: Category?
    @Published var isDone: Bool?
    @Published var notify: Bool?

    @Published var errorText: String?
    @Published var errorTextHidden: Bool = true

    var cancelables: [AnyCancellable] = []

    private let task: Task?

    private let service: TaskServiceProtocol

    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()

    var didFinishEditing: (() -> Void)?

    init(task: Task? = nil, service: TaskServiceProtocol = TaskService()) {
        self.service = service
        self.task = task

        cancelables = [
            state.sink(receiveValue: { [weak self] state in
                self?.processState(state)
            }),
            action.sink(receiveValue: { [weak self] action in
                self?.processAction(action)
            })
        ]
    }

    func validate() throws -> Task {
        guard let name = name else {
            throw EditTaskError.invalidForm(field: "name")
        }

        guard let deadline = deadline else {
            throw EditTaskError.invalidForm(field: "deadline")
        }

        guard let isDone = isDone else {
            throw EditTaskError.invalidForm(field: "isDone")
        }

        guard let category = category else {
            throw EditTaskError.invalidForm(field: "category")
        }

        return Task(taskID: task?.taskID, name: name, deadline: deadline, done: isDone, notify: notify ?? false, category: category)
    }

    func processState(_ state: State) {
        switch state {
        case .initial:
            guard let task = task else {
                deadline = Date()
                isDone = false
                return
            }
            name = task.name
            deadline = task.deadline
            isDone = task.done
            category = task.category
            notify = task.notify

        case .error(let message):
            errorText = message
            errorTextHidden = false
        }
    }

    func processAction(_ action: Action) {
        switch action {
        case .save:
            do {
                let formTask = try validate()
                if task != nil {
                    try service.updateExisting(task: task!, with: formTask)
                } else {
                    try service.createNew(task: formTask)
                }

                self.didFinishEditing?()

            } catch let error as EditTaskError {
                switch error {
                case .invalidForm(let field):
                    state.value = .error(message: "Invalid field: \(field)")
                }
            } catch {
                state.value = .error(message: error.localizedDescription)
            }
        }
    }
}
