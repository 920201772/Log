//
//  LogFile.swift
//  
//
//  Created by 杨柳 on 2021/12/23.
//

import Foundation

extension Log {

    final class File {

        let descriptor: FileDescriptor

        private var file: FileHandle
        private var size: Int
        private var infos: [(String, Int)]
        private var totalSize: Int

        deinit {
            file.closeFile()
        }

        init(descriptor: FileDescriptor) throws {
            self.descriptor = descriptor

            try FileManager.default.createDirectory(atPath: descriptor.directory, withIntermediateDirectories: true)
            let (file, size) = try Self.createFile(directory: descriptor.directory)
            self.file = file
            self.size = size

            let (infos, totalSize) = try Self.createInfos(directory: descriptor.directory)
            self.infos = infos
            self.totalSize = totalSize

            try clearFile()
        }

    }

}

// MARK: - Method
extension Log.File {

    func writeFile(_ text: String) throws {
        guard let data = text.data(using: .utf8) else { return }
        file.write(data)
        size += data.count

        if size >= descriptor.maxSize {
            try makeFile()
        }
    }

}

// MARK: - Private
private extension Log.File {

    static func createFile(directory: String) throws -> (FileHandle, Int) {
        let filePath = "\(directory)/\(String(format: "yyyy-MM-dd HH:mm:ss.SSS", date: .init())).log"
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil)
        }
        let file = try FileHandle(forWritingTo: .init(fileURLWithPath: filePath))
        let size = file.seekToEndOfFile()

        return (file, .init(size))
    }


    static func createInfos(directory: String) throws -> ([(String, Int)], Int) {
        var urls: [(String, Int, Date)] = try FileManager.default.contentsOfDirectory(at: .init(fileURLWithPath: directory), includingPropertiesForKeys: [.fileSizeKey, .creationDateKey]).map {
            let values = try $0.resourceValues(forKeys: [.fileSizeKey, .creationDateKey])
            return ($0.path, values.fileSize ?? 0, values.creationDate ?? .distantPast)
        }
        urls.sort { $0.2 < $1.2 }

        var totalSize = 0
        let infos: [(String, Int)] = urls.map {
            totalSize += $0.1
            return ($0.0, $0.1)
        }

        return (infos, totalSize)
    }

    func clearFile() throws {
        var index = 0
        while totalSize >= descriptor.maxTotalSize {
            let info = infos[index]
            try FileManager.default.removeItem(atPath: info.0)
            totalSize -= info.1
            index += 1
        }
    }

    func makeFile() throws {
        file.closeFile()
        totalSize += size

        try clearFile()

        let (file, size) = try Self.createFile(directory: descriptor.directory)
        self.file = file
        self.size = size
    }

}

// MARK: - FileDescriptor
public extension Log {

    struct FileDescriptor {

        /// 文件存放目录, 此目录不允许其它代码操作.
        public let directory: String
        /// 单个文件最大大小, 单位字节.
        public let maxSize: Int
        /// 所有文件最大大小, 单位字节.
        public let maxTotalSize: Int

        public init(directory: String, maxSize: Int, maxTotalSize: Int) {
            self.directory = directory
            self.maxSize = maxSize
            self.maxTotalSize = maxTotalSize
        }

    }

}
