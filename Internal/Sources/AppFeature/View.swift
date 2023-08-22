import SwiftUI
import ComposableArchitecture
import ViewA

public struct AppFeature: View {
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Group {
                NavigationLink("View1") {
                    ViewA(store: .init(
                        initialState: ViewAReducer.State(),
                        reducer: { ViewAReducer() }
                    ))
                }
                NavigationLink("View2") {
                    ViewA(store: .init(
                        initialState: ViewAReducer.State(),
                        reducer: { ViewAReducer() }
                    ))
                }
                NavigationLink("View3") {
                    ViewA(store: .init(
                        initialState: ViewAReducer.State(),
                        reducer: { ViewAReducer() }
                    ))
                }
            }
            .font(.largeTitle)
        }
    }
}

struct AppFeature_Previews: PreviewProvider {
    static var previews: some View {
        AppFeature()
    }
}
