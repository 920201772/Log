//
//  Log.swift
//
//
//  Created by 杨柳 on 2021/4/27.
//

import Logging

public struct Log {
    
    public static let shared = Log()
    
    private let logger = Logger(label: "Log")
    
    init() {
        logger.trace("test")
    }
    
}

