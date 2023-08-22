import XCTest
import ComposableArchitecture
@testable import ViewA

@MainActor
final class ViewATest: XCTestCase {

    func testViewAReducer() async {
        let store: TestStore<ViewAReducer.State, ViewAReducer.Action> = TestStore(initialState: ViewAReducer.State()) {
            ViewAReducer()
        } withDependencies: {
            $0.uuid = .incrementing
            $0.calculator.sum = { inputs in
                return inputs.reduce(0, +)
            }
        }
        
        store.assert { state in
            state.numbers = []
        }
        
        await store.send(.addNew) { state in
            state.numbers.append(.init(id: UUID(0), number: 0))
        }
        
        await store.send(.addNew) { state in
            state.numbers = [
                .init(id: UUID(0), number: 0),
                .init(id: UUID(1), number: 0)
            ]
        }
        
        await store.send(.textInput(UUID(0), "100")) { state in
            state.numbers[0] = .init(id: UUID(0), number: 100)
            state.total = 100
        }
        
        await store.send(.textInput(UUID(1), "1")) { state in
            state.numbers[1] = .init(id: UUID(1), number: 1)
            state.total = 101
        }
        
        await store.send(.remove([0])) { state in
            state.numbers = [
                .init(id: UUID(1), number: 1)
            ]
            state.total = 1
        }
    }
}
