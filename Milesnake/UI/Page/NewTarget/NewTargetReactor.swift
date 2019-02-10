//
//  NewTargetReactor.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/01.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import ReactorKit
import RxSwift

final class NewTargetReactor: Reactor {
    var initialState: State = State()
    var service = MileService()

    enum Action {
        case updateText(String?)
        case nextPage
    }

    enum Mutation {
        case updateText(Editing, String?)
        case nextPage(Editing)
    }

    enum Editing {
        case what
        case why
        case done
    }

    enum Context {
        case new
        case edit(Mile)
    }

    struct State {
        var what: String?
        var why: String?
        var editing: Editing = .what
        var parent: Mile?
        var context: Context = .new
        var editingMile: Mile?

        var shouldShowButton: Bool {
            let what = (self.what ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            let why = (self.why ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
            if (editing == .what && !what.isEmpty)
                || (editing == .why && !why.isEmpty) {
                return true
            }
            else {
                return false
            }
        }
    }

    init(parentMile: Mile? = nil, context: Context = .new) {
        initialState = State()
        if let mile = parentMile {
            initialState.parent = mile
        }
        if case .edit(let mile) = context {
            initialState.editingMile = mile
        }
    }

    func mutate(action: NewTargetReactor.Action) -> Observable<NewTargetReactor.Mutation> {
        switch action {
        case .updateText(let text):
            return .just(.updateText(currentState.editing, text))
        case .nextPage:
            switch currentState.editing {
            case .what:
                return .just(.nextPage(.why))
            case .why:
                if let mile = currentState.editingMile {
                    update(mile: mile)
                } else {
                    save()
                }

                return .just(.nextPage(.done))
            case .done:
                return .empty()
            }
        }

    }

    private func save() {
        let mile = Mile()
        mile.createdAt = Date()
        mile.what = (currentState.what ?? "").trimmingCharacters(in: .newlines)
        mile.why = (currentState.why ?? "").trimmingCharacters(in: .newlines)
        if let parent = currentState.parent {
            mile.order = parent.children.count
            service.append(from: mile, to: parent)
        }
        else {
            mile.order = service.root().count
            service.save(mile)
        }
    }

    private func update(mile: Mile) {
        service.update { () -> (Mile) in
            mile.what = (currentState.what ?? "").trimmingCharacters(in: .newlines)
            mile.why = (currentState.why ?? "").trimmingCharacters(in: .newlines)
            return mile
        }
    }

    func reduce(state: NewTargetReactor.State, mutation: NewTargetReactor.Mutation) -> NewTargetReactor.State {
        var state = state
        switch mutation {
        case .updateText(let editing, let text):
            if editing == .what {
                state.what = text
            }
            else if editing == .why {
                state.why = text
            }
        case .nextPage(let editing):
            state.editing = editing
        }
        return state
    }
}
