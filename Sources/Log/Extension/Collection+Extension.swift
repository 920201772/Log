//
//  Collection+Extension.swift
//  Kun
//
//  Created by 杨柳 on 2018/11/5.
//  Copyright © 2018年 com.kun. All rights reserved.
//

import Foundation

extension Collection {

    /// 安全索引.
    subscript(safe index: Index?) -> Element? {
        guard let index = index else { return nil }
        return index.contains(to: startIndex..<endIndex) ? self[index] : nil
    }

    /// 安全索引.
    subscript(safe index: Index?, default defaultValue: @autoclosure () -> Element) -> Element {
        self[safe: index] ?? defaultValue()
    }

    /// 安全索引, 自动解包.
    subscript(unwrap safeIndex: Index?) -> Element where Element: _CollectionElementOptional {
        self[safe: safeIndex] ?? .none
    }

}

// MARK: - Array
extension Array {

    /// 安全索引.
    ///
    /// get 如果 index 越界返回 nil.
    ///
    /// set 如果 index 越界并 Element 为 Optional, 自动补 nil, 否则什么也不做.
    subscript(safe index: Int?) -> Element? {
        get {
            guard let index = index else { return nil }
            return index.contains(to: startIndex..<endIndex) ? self[index] : nil
        }
        set {
            guard let index = index else { return }

            if let null = Optional<Any>.none as? Element {
                if index >= 0 {
                    if index < endIndex {
                        self[index] = newValue ?? null
                    } else {
                        append(contentsOf: (0..<index - endIndex).map { _ in null })
                        append(newValue ?? null)
                    }
                }
            } else {
                if let newValue = newValue, index.contains(to: startIndex..<endIndex) {
                    self[index] = newValue
                }
            }
        }
    }

    /// 末尾第几个元素.
    subscript(last index: Int?) -> Element? {
        guard let index = index else { return nil }
        return self[safe: count - 1 - index]
    }

    /// 从末尾 index 开始删除 numbar 个元素.
    ///
    /// - Parameters:
    ///   - index: 末尾索引.
    ///   - numbar: 删除个数, 默认为 1.
    mutating func remove(last index: Int, numbar: Int = 1) {
        let upper = count - index
        let lower = upper - numbar

        removeSubrange(lower..<upper)
    }

}

// MARK: - _CollectionElementOptional
protocol _CollectionElementOptional {

    static var none: Self { get }

}

extension Optional: _CollectionElementOptional {}
