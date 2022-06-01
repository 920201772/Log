//
//  HTTPService.swift
//  
//
//  Created by 杨柳 on 2022/5/31.
//

import Foundation
import Network

extension Net.HTTP {

    final class Service {
        
        static let maxReceiveLength = Int(UInt16.max)
        
        private var connections: ContiguousArray<NWConnection> = []
        
        private let listener: NWListener
        private let queue = DispatchQueue(label: "Log.Net.HTTP.Service", qos: .default)
        
        deinit {
            listener.cancel()
        }
        
        init(port: String) throws {
            guard let port = NWEndpoint.Port(port) else { throw Net.Error.port }
            
            listener = try NWListener(using: .tcp, on: port)
            listener.newConnectionHandler = { [weak self] connection in
                guard let self = self else { return }
                
                connection.stateUpdateHandler = { [unowned connection] in
                    switch $0 {
                    case .setup, .waiting, .preparing:
                        break
                        
                    case .ready:
                        self.receive(connection: connection)

                    case .failed, .cancelled:
                        break

                    @unknown default:
                        break
                    }
                }
                
                connection.start(queue: self.queue)
            }

            listener.start(queue: queue)
        }
        
    }
    
}

// MARK: - Private
private extension Net.HTTP.Service {
    
    func receive(connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: Self.maxReceiveLength) { [weak self, unowned connection] data, _, isFinal, error in
            guard let self = self else { return }
            if error != nil {
                connection.cancel()
                return
            }
            
            if let data = data,
               let request = String(data: data, encoding: .utf8)?.split(separator: "\r\n", maxSplits: 1).first?.split(separator: " ") {
                if request.first != "GET" {
                    connection.cancel()
                    return
                }
                
                var path = String(request[safe: 1, default: "/index.html"])
                if path == "/" {
                    path = "/index.html"
                }
                
                path = (Bundle.module.resourcePath ?? "") + path
                if let body = FileManager.default.contents(atPath: path) {
                    var request = """
                                HTTP/1.1 200 OK\r
                                Server: Log.Net.HTTP.Service\r
                                Content-length: \(body.count)\r
                                Content-type: text-plain\r
                                Connection: close\r
                                \r\n
                                """.data(using: .utf8) ?? Data()
                    request.append(body)
                    
                    connection.send(content: request, completion: .contentProcessed({
                        if $0 != nil {
                            connection.cancel()
                        }
                    }))
                } else {
                    connection.cancel()
                    return
                }
            }
            
            if isFinal {
                connection.cancel()
            } else {
                self.receive(connection: connection)
            }
        }
    }
    
}
