//
//  String+Format.swift
//  Kun
//
//  Created by 杨柳 on 2020/11/2.
//  Copyright © 2020 com.kun. All rights reserved.
//

import Foundation

extension String {

    /// 格式化时间.
    /// - Parameters:
    ///   - format:
    ///     - zzz：3 个字母表示的时区 (如 GMT).
    ///     - yyyy：4 个数字表示的年.
    ///     - MMMM：月份的全写 (如 October).
    ///     - EEEE：表示星期几 (如 Monday).
    ///     - dd：表示一个月里面日期的数字.
    ///     - hh：2 个数字表示的小时 (大写为 24 小时制).
    ///     - mm：2 个数字表示的分钟.
    ///     - ss：2 个数字表示的秒.
    ///     - SSS 显示秒的小数部分.
    ///     - a 显示上下午.
    ///   - date: 需要格式化的名称.
    init(format: String, date: Date) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format

        self = dateFormat.string(from: date)
    }

}
