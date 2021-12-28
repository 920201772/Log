import XCTest
@testable import Log

final class LogTests: XCTestCase {
    
    func testExample() {
        if let descriptor = Log.fileDescriptor {
            print(descriptor)
        }
        if let descriptor = Log.httpDescriptor {
            print(descriptor)
        }
        print(Log.enableLevels)

        while true {
            Thread.sleep(forTimeInterval: 1)
            Log.info("11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111")
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
    
}
