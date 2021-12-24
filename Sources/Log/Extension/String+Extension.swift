//
//  String+Extension.swift
//  Kun
//
//  Created by 杨柳 on 2018/9/25.
//  Copyright © 2018年 com.kun. All rights reserved.
//

import Foundation

extension String {

    /// 对参数进行反序列化.
    /// - Returns: #"-a 1 -b -c "2 3 4" -d 5 6 -f 7 -f"# -> ["a": ["1"], b: [""], c: ["2 3 4"], "d": ["5", "6"], f: ["7", ""]]
    var decodeOptions: [String: [String]] {
        var this: [String: [String]] = [:]
        var previous = Character(" ")
        var keyStack = ""
        var isKey = false
        var valueStack = ""
        var isValue = false
        var values: [String] = []
        var isContinuousValue = false

        func addValue() {
            if !valueStack.isEmpty || values.isEmpty {
                values.append(valueStack)
                valueStack = ""
            }
        }
        func setThis() {
            if keyStack.isEmpty { return }
            addValue()
            if let arr = this[keyStack] {
                values = arr + values
            }
            this[keyStack] = values
        }

        forEach { char in
            defer { previous = char }
            if previous == " " && char == "-" {
                setThis()
                values = []
                isValue = false
                keyStack = ""
                isKey = true

                return
            }
            if isKey {
                if char == " " {
                    isKey = false
                    isValue = true
                } else {
                    keyStack.append(char)
                }
                return
            }
            if isValue {
                if char == #"""# {
                    isContinuousValue.toggle()
                } else if !isContinuousValue && char == " " {
                    addValue()
                } else {
                    valueStack.append(char)
                }
            }
        }

        setThis()
        return this
    }

}

// MARK: - 字符截取
extension String {

    /// 字符串截取.
    subscript(_ index: Int) -> String {
        get { self[index...index] }
        set { self[index...index] = newValue }
    }
    /// 字符串截取 (开区间, [0...]).
    subscript(_ range: PartialRangeFrom<Int>) -> String {
        get {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            return String(self[lower..<endIndex])
        }
        set {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            replaceSubrange(lower..., with: newValue)
        }
    }
    /// 字符串截取 (开区间, [...2]).
    subscript(_ range: PartialRangeThrough<Int>) -> String {
        get {
            let upper = index(startIndex, offsetBy: range.upperBound)
            return String(self[startIndex...upper])
        }
        set {
            let upper = index(startIndex, offsetBy: range.upperBound)
            replaceSubrange(...upper, with: newValue)
        }
    }
    /// 字符串截取 (开区间, [..<2]).
    subscript(_ range: PartialRangeUpTo<Int>) -> String {
        get {
            let upper = index(startIndex, offsetBy: range.upperBound)
            return String(self[startIndex..<upper])
        }
        set {
            let upper = index(startIndex, offsetBy: range.upperBound)
            replaceSubrange(startIndex..<upper, with: newValue)
        }

    }
    /// 字符串截取 (闭区间, [0...2]).
    subscript(_ range: ClosedRange<Int>) -> String {
        get {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            let upper = index(startIndex, offsetBy: range.upperBound)

            return String(self[lower...upper])
        }
        set {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            let upper = index(startIndex, offsetBy: range.upperBound)

            replaceSubrange(lower...upper, with: newValue)
        }
    }
    /// 字符串截取 (闭区间, [0..<2]).
    subscript(_ range: Range<Int>) -> String {
        get {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            let upper = index(startIndex, offsetBy: range.upperBound)

            return String(self[lower..<upper])
        }
        set {
            let lower = index(startIndex, offsetBy: range.lowerBound)
            let upper = index(startIndex, offsetBy: range.upperBound)

            replaceSubrange(lower..<upper, with: newValue)
        }
    }

    /// 返回开始到从末尾减去指定数量的字符串.
    ///
    ///     let string = "123456"
    ///     print(numbers.prefix(lastTo: 3)
    ///     // Prints "123"
    ///
    /// - Parameter number: 指定数量.
    func prefix(lastTo number: Int) -> String {
        let upper = index(startIndex, offsetBy: count - number)

        return String(self[startIndex..<upper])
    }

}

// MARK: - 路径操作
extension String {
    
    var fileName: String {
        var firstIndex = 0
        var lastIndex = count
        for (index, char) in self.enumerated().reversed() {
            if char == "/" {
                firstIndex = index + 1
                break
            }
            if char == "." {
                lastIndex = index
            }
        }

        return self[firstIndex..<lastIndex]
    }

}
