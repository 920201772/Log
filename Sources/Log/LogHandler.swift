//
//  LogHandler.swift
//  
//
//  Created by 杨柳 on 2021/4/27.
//

import Foundation

extension Log {

    final class Handler {

        var file: File?

    }

}

// MARK: - Method
extension Log.Handler {

    func log(level: Log.Level, message: @autoclosure () -> Any, file: String, function: String, line: UInt) throws {
        func getText() -> String {
            "# \(String(format: "yy/MM/dd HH:mm:ss.SSS", date: .init())) [\(level.rawValue)] \(file.fileName)(\(line)) \(function) #\n\(message())\n\n"
        }

        if let file = self.file {
            let text = getText()
            try file.writeFile(text)

            #if !RELEASE
            print(text, terminator: "")
            #endif

            return
        }

        #if !RELEASE
        let text = getText()
        print(text, terminator: "")
        #endif
    }

}
