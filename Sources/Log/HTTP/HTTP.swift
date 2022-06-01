//
//  HTTP.swift
//  
//
//  Created by 杨柳 on 2021/12/24.
//

import Foundation

enum Net {

    enum HTTP {}

}

// MARK: - Error
extension Net {

    enum Error: LocalizedError {

        case version
        case port

        var errorDescription: String? {
            switch self {
            case .version: return "系统版本过低."
            case .port: return "端口错误."
            }
        }

    }

}

