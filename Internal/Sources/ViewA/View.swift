import SwiftUI
import Calculator
import ComposableArchitecture

public struct ViewAReducer: Reducer {
    public init() {}
    
    public struct State: Equatable {
        public init(numbers: [ViewItem] = [], total: Int = 0) {
            self.numbers = numbers
            self.total = total
        }
        
        var numbers: [ViewItem] = []
        var total: Int = 0
    }
    
    public enum Action {
        case addNew
        case remove(IndexSet)
        case textInput(UUID, String)
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.calculator.sum) var sum
    
    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .addNew:
            state.numbers.append(.init(id: uuid(), number: 0))
            state.total = sum(state.numbers.map(\.number))
            return .none
            
        case .remove(let idx):
            state.numbers.remove(atOffsets: idx)
            state.total = sum(state.numbers.map(\.number))
            return .none
            
        case .textInput(let uuid, let newInput):
            guard
                let index = state.numbers.firstIndex(where: { $0.id == uuid }),
                let newNumber = Int(newInput)
            else { return .none }
            state.numbers[index].number = newNumber
            state.total = sum(state.numbers.map(\.number))
            return .none
        }
    }
}

public struct ViewItem: Identifiable, Equatable {
    init(id: UUID, number: Int) {
        self.id = id
        self.number = number
    }
    
    
    public let id: UUID
    public var number: Int
}

public struct ViewA: View {
    public init(store: StoreOf<ViewAReducer>) {
        self.store = store
    }
    
    public var store: StoreOf<ViewAReducer>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewstore in
            List {
                ForEach(viewstore.numbers) { item in
                    TextField("number input", text: textConverter(viewstore: viewstore, id: item.id))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                .onDelete { idx in
                    viewstore.send(.remove(idx))
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text(String(viewstore.total))
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    HStack {
                        EditButton()
                        Button {
                            viewstore.send(.addNew)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
    
    func textConverter(viewstore: ViewStoreOf<ViewAReducer>, id: UUID) -> Binding<String> {
        .init {
            return viewstore.numbers
                .first(where: { $0.id == id})
                .map(\.number)
                .map { number in String(number) }
            ?? "???"
        } set: { newValue in
            viewstore.send(.textInput(id, newValue))
        }
    }
}

struct ViewA_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ViewA(store: .init(
                initialState: ViewAReducer.State(),
                reducer: { ViewAReducer() }
            ))
        }
    }
}
