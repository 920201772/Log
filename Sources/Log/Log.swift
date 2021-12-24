//
//  Log.swift
//
//
//  Created by 杨柳 on 2021/4/27.
//

import Foundation

public final class Log {

    /// 默认从启动参数 (-Log.file <directory> <maxSize> <maxTotalSize>) 解析.
    public static var fileDescriptor: FileDescriptor? {
        get { shared.handler.file?.descriptor }
        set {
            if let descriptor = newValue {
                shared.handler.file = try! .init(descriptor: descriptor)
            } else {
                shared.handler.file = nil
            }
        }
    }
    /// 默认从启动参数 (-Log.level <name>) 解析.
    public static var enableLevels: Set<Level> {
        get { shared.enableLevels }
        set { shared.enableLevels = newValue }
    }

    fileprivate static let shared = Log()

    fileprivate let handler = Handler()

    private var enableLevels: Set<Level> = []
    
    private init() {
        let arguments = CommandLine.arguments.joined(separator: " ").decodeOptions

        if let descriptor = arguments["Log.file"] {
            handler.file = try! .init(descriptor: .init(directory: descriptor[0], maxSize: .init(descriptor[1])!, maxTotalSize: .init(descriptor[2])!))
        }
        arguments["Log.level"]?.forEach {
            enableLevels.insert(.init(rawValue: $0))
        }
    }
    
}

// MARK: - Public
public func Logging(level: Log.Level, message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
    if !Log.enableLevels.contains(level) { return }
    try! Log.shared.handler.log(level: level, message: message(), file: file, function: function, line: line)
}

public extension Log {

    static func debug(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
        Logging(level: .debug, message: message(), file: file, function: function, line: line)
    }

    static func info(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
        Logging(level: .info, message: message(), file: file, function: function, line: line)
    }

    static func warning(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
        Logging(level: .warning, message: message(), file: file, function: function, line: line)
    }

    static func error(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
        Logging(level: .error, message: message(), file: file, function: function, line: line)
    }

    static func net(_ message: @autoclosure () -> Any, file: String = #file, function: String = #function, line: UInt = #line) {
        Logging(level: .net, message: message(), file: file, function: function, line: line)
    } 
    
}

// MARK: - Level
public extension Log {

    struct Level: Hashable {

        public static let debug = Self(rawValue: "Debug")
        public static let info = Self(rawValue: "Info")
        public static let warning = Self(rawValue: "Warning")
        public static let error = Self(rawValue: "Error")
        public static let net = Self(rawValue: "Net")

        var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

    }

}
