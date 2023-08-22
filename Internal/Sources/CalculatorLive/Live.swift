@_exported import Calculator
import HeavyBuild
import Dependencies

extension Calculator: DependencyKey {
    public static var liveValue: Calculator {
        .init { inputs in
            return HeavyBuild.heavyCompile1(inputs).reduce(0, +)
        }
    }
}
