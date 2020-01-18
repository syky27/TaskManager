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
    case outOfStock
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
    @Published var deadlineString: String?
    @Published var isDone: Bool?

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

        return Task(taskID: UUID().uuidString, name: name, deadline: deadline, done: false, category: Category(name: "Test", color: "ffffff"))
    }

    func processState(_ state: State) {
        switch state {
        case .initial:
            guard let task = task else { return }
            name = task.name
            deadline = task.deadline
            isDone = task.done

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

            } catch {
                state.value = .error(message: error.localizedDescription)
            }
        }
    }
}
