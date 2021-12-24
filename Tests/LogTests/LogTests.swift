import XCTest
@testable import Log

final class LogTests: XCTestCase {
    
    func testExample() {
        print(Log.fileDescriptor)
        print(Log.enableLevels)
        Log.info("11111")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
    
}
