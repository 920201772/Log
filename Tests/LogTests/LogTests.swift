import XCTest
@testable import Log

final class LogTests: XCTestCase {
    
    func testExample() {
        Log.setArguments(CommandLine.arguments.joined(separator: " "))
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

func registerSignal() {
    // lldb: pro hand -p true -s false SIGABRT.
    let values = [SIGILL, SIGTRAP, SIGABRT, SIGFPE, SIGBUS, SIGSEGV]
    values.forEach { signal($0, crashHandler) }
//    DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
}

func crashHandler(_ value: Int32) {
    print("--- \(value)\n --- \(Thread.callStackSymbols)")
    signal(value, SIG_DFL)
    //    kill(getpid(), signal)
    //    exit(-signal)
}
