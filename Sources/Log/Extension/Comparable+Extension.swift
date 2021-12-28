//
//  Comparable+Extension.swift
//  Kun
//
//  Created by 杨柳 on 2019/4/25.
//  Copyright © 2019 com.kun. All rights reserved.
//

import Foundation

extension Comparable {
    
    /// 是否在范围内 (开区间, [0...]).
    func contains(to range: PartialRangeFrom<Self>) -> Bool {
        range.contains(self)
    }
    /// 是否在范围内 (开区间, [...2]).
    func contains(to range: PartialRangeThrough<Self>) -> Bool {
        range.contains(self)
    }
    /// 是否在范围内 (开区间, [..<2])
    func contains(to range: PartialRangeUpTo<Self>) -> Bool {
        range.contains(self)
    }
    /// 是否在范围内 (闭区间, [0...2]).
    func contains(to range: ClosedRange<Self>) -> Bool {
        range.contains(self)
    }
    /// 是否在范围内 (闭区间, [0..<2]).
    func contains(to range: Range<Self>) -> Bool {
        range.contains(self)
    }
    
    /// 如果超出范围取下限 (开区间, [0...]).
    mutating func limit(_ range: PartialRangeFrom<Self>) {
        self = max(self, range.lowerBound)
    }
    /// 如果超出范围取上限 (开区间, [...2]).
    mutating func limit(_ range: PartialRangeThrough<Self>) {
        self = min(self, range.upperBound)
    }
    /// 如果超出范围取上下限 (闭区间, [0...2]).
    mutating func limit(_ range: ClosedRange<Self>) {
        self = min(max(range.lowerBound, self), range.upperBound)
    }
    
    /// 如果超出范围返回下限 (开区间, [0...]).
    func limited(_ range: PartialRangeFrom<Self>) -> Self {
        max(self, range.lowerBound)
    }
    /// 如果超出范围返回上限 (开区间, [...2]).
    func limited(_ range: PartialRangeThrough<Self>) -> Self {
        min(self, range.upperBound)
    }
    /// 如果超出范围返回上下限 (闭区间, [0...2]).
    func limited(_ range: ClosedRange<Self>) -> Self {
        min(max(range.lowerBound, self), range.upperBound)
    }
    
    /// 是否在范围内, 如果 lower > upper 返回 flase.
    func contains(to lower: Self, upper: Self) -> Bool {
        self >= lower && self <= upper
    }
    /// 如果超出范围取上下限, 如果 lower > upper 返回 upper.
    mutating func limit(lower: Self, upper: Self) {
        self = min(max(lower, self), upper)
    }
    /// 如果超出范围取上下限, 如果 lower > upper 返回 upper.
    func limited(lower: Self, upper: Self) -> Self {
        min(max(lower, self), upper)
    }
    
}
