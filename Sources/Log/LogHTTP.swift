//
//  LogHTTP.swift
//  
//
//  Created by 杨柳 on 2021/12/25.
//

import Foundation

extension Log {

    final class HTTP {

        let descriptor: HTTPDescriptor
        let socket: Net.HTTP.Socket
        
        private let service: Net.HTTP.Service

        init(descriptor: HTTPDescriptor) throws {
            self.descriptor = descriptor
            service = try Net.HTTP.Service(port: descriptor.servicePort)
            socket = try Net.HTTP.Socket(port: descriptor.socketPort)
        }

    }

}

// MARK: - HTTPDescriptor
public extension Log {

    struct HTTPDescriptor {

        /// 服务端口.
        public let servicePort: String
        /// Socket 端口.
        public let socketPort: String

        public init(servicePort: String, socketPort: String) {
            self.servicePort = servicePort
            self.socketPort = socketPort
        }

    }

}
