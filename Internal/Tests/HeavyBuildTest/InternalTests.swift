import XCTest
@testable import HeavyBuild

final class InternalTests: XCTestCase {
    func testHeavyBuild() throws {
        XCTAssertEqual([1,2,3], heavyCompile1([1,2,3]))
    }
}
