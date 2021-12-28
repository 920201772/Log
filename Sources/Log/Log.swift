//
//  Log.swift
//
//
//  Created by 杨柳 on 2021/4/27.
//

import Foundation

public final class Log {

    /// 默认从启动参数 (-Log.file <directory> <maxSize> <maxTotalSize>) 解析.
    ///
    /// ¥(HOME) 为沙盒目路, 示例 "¥(HOME)/Documents "
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
    /// 默认从启动参数 (-Log.http <servicePort> <socketPort>) 解析.
    public static var httpDescriptor: HTTPDescriptor? {
        get { shared.handler.http?.descriptor }
        set {
            if let descriptor = newValue {
                shared.handler.http = try! .init(descriptor: descriptor)
            } else {
                shared.handler.http = nil
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
            var directory = descriptor[0]
            if let index = directory.range(of: "¥(HOME)") {
                directory.replaceSubrange(index, with: NSHomeDirectory())
            }

            handler.file = try! .init(descriptor: .init(directory: directory, maxSize: .init(descriptor[1])!, maxTotalSize: .init(descriptor[2])!))
        }
        if let descriptor = arguments["Log.http"] {
            handler.http = try! .init(descriptor: .init(servicePort: descriptor[0], socketPort: descriptor[1]))
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

    static func object(_ object: NSObject, type: ObjectType, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let message: () -> Any = {
            object.perform(Selector((type.rawValue)))!.takeUnretainedValue()
        }
        Logging(level: level, message: message(), file: file, function: function, line: line)
    }
    
}

// MARK: - Memory
public extension Log {

    static func memory(_ memory: UnsafeMutableRawBufferPointer, count: Int, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let message: () -> String = {
            func showCharacter(ascii: UInt8) -> Character {
                if ascii.contains(to: 0x21...0x7E) {
                    return Character(Unicode.Scalar(ascii))
                } else {
                    return Character(Unicode.Scalar(0x2E))
                }
            }

            let address = "\(memory.baseAddress!)"
            let newCount = count.limited(...memory.count)
            var content = ""
            var ascii = ""
            for index in 0..<newCount {
                if index % 16 == 0 {
                    content += String(format: "  %@\n%02X", ascii, memory[index])
                    ascii = "\(showCharacter(ascii: memory[index]))"
                } else if index % 8 == 0 {
                    content += String(format: "  %02X", memory[index])
                    ascii += " \(showCharacter(ascii: memory[index]))"
                } else {
                    content += String(format: " %02X", memory[index])
                    ascii.append(showCharacter(ascii: memory[index]))
                }
            }

            let differ = 16 - newCount % 16
            var fill = ""
            if differ.contains(to: 1...7) {
                fill = String(repeating: " ", count: differ * 3)
            } else if differ.contains(to: 8...15) {
                fill = String(repeating: " ", count: differ * 3 + 1)
            }
            content += "\(fill)  \(ascii)"

            return address + content
        }

        Logging(level: level, message: message(), file: file, function: function, line: line)
    }

    static func memory(_ memory: UnsafeRawBufferPointer, count: Int, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let mrbp = UnsafeMutableRawBufferPointer(mutating: memory)
        self.memory(mrbp, count: count, level: level, file: file, function: function, line: line)
    }

    static func memory<T>(_ memory: UnsafeMutableBufferPointer<T>, count: Int, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let mrbp = UnsafeMutableRawBufferPointer(memory)
        self.memory(mrbp, count: count, level: level, file: file, function: function, line: line)
    }

    static func memory<T>(_ memory: UnsafeBufferPointer<T>, count: Int, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let mbp = UnsafeMutableBufferPointer(mutating: memory)
        let mrbp = UnsafeMutableRawBufferPointer(mbp)
        self.memory(mrbp, count: count, level: level, file: file, function: function, line: line)
    }

    static func memory(_ memory: UnsafeRawPointer, count: Int, level: Log.Level = .debug, file: String = #file, function: String = #function, line: UInt = #line) {
        let mrp = UnsafeMutableRawPointer(mutating: memory)
        let mrbp = UnsafeMutableRawBufferPointer(start: mrp, count: count)
        self.memory(mrbp, count: count, level: level, file: file, function: function, line: line)
    }

}

// MARK: - Nested
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

    enum ObjectType: String {

        /// 打印对象成员变量.
        case ivar = "_ivarDescription"
        /// 打印对象方法.
        case method = "_methodDescription"
        /// 打印对象方法 (不包含父类).
        case shortMethod = "_shortMethodDescription"
        /// 打印视图 (对象必须是 UIView).
        case view = "recursiveDescription"

    }

}
