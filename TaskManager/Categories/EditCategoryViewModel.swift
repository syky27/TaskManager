//
//  EditCategoryViewModel.swift
//  TaskManager
//
//  Created by Tomas Sykora, jr. on 16/01/2020.
//  Copyright © 2020 AJTY. All rights reserved.
//

import Foundation
import Combine

class EditCategoryViewModel {

    enum Action {
        case save
    }

    enum State {
        case initial
        case error(message: String)
    }

    @Published var name: String?
    @Published var errorText: String?
    @Published var errorTextHidden: Bool = true

    var cancelables: [AnyCancellable] = []

    private let category: Category?

    private let service = CategoryService()

    let state = CurrentValueSubject<State, Never>(.initial)
    let action = PassthroughSubject<Action, Never>()

    var didFinishEditing: (() -> Void)?

    init(category: Category? = nil) {
        self.category = category

        cancelables = [
            state.sink(receiveValue: { [weak self] state in
                self?.processState(state)
            }),
            action.sink(receiveValue: { [weak self] action in
                self?.processAction(action)
            })
        ]
    }

    func processState(_ state: State) {
        switch state {
        case .initial:
            name = category?.name ?? ""

        case .error(let message):
            errorText = message
            errorTextHidden = false
        }
    }

    func processAction(_ action: Action) {
        switch action {
        case .save:
            do {
                let formCategory = Category(name: name ?? "")
                category != nil ? try service.updateExisting(category: category!, with: formCategory) :  try service.createNew(category: formCategory)
                self.didFinishEditing?()

            } catch {
                state.value = .error(message: error.localizedDescription)
            }
        }
    }
}
