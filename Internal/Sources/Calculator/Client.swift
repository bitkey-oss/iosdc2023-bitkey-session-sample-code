import Dependencies

public struct Calculator {
    public init(sum: @escaping @Sendable (Array<Int>) -> Int) {
        self.sum = sum
    }
    
    public var sum: @Sendable (Array<Int>) -> Int
}

extension Calculator: TestDependencyKey {
    public static var previewValue: Calculator {
        .init { inputs in
            return 42
        }
    }
    
    public static var testValue: Calculator {
        .init(sum: unimplemented("\(Self.self)\(#function)"))
    }
}

extension DependencyValues {
    public var calculator: Calculator {
        get { self[Calculator.self] }
        set { self[Calculator.self] = newValue }
    }
}
