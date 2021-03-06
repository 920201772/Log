//
//  HTTPSocket.swift
//  
//
//  Created by 杨柳 on 2021/12/24.
//

import Foundation
import Network

extension Net.HTTP {

    final class Socket {

        private var connections: ContiguousArray<NWConnection> = []

        private let listener: NWListener
        private let queue = DispatchQueue(label: "Log.Net.HTTP.Socket", qos: .default)
        private let context: NWConnection.ContentContext

        deinit {
            listener.cancel()
        }
        
        init(port: String) throws {
            if #available(iOS 13.0, *) {
                guard let port = NWEndpoint.Port(port) else { throw Net.Error.port }
                context = .init(identifier: queue.label, metadata: [NWProtocolWebSocket.Metadata(opcode: .text)])
                
                let parameters = NWParameters.tcp
                let options = NWProtocolWebSocket.Options()
                options.autoReplyPing = true
                parameters.defaultProtocolStack.applicationProtocols.append(options)
                listener = try NWListener(using: parameters, on: port)

                listener.newConnectionHandler = { [weak self] connection in
                    guard let self = self else { return }
                    self.connections.append(connection)
                    connection.stateUpdateHandler = {
                        switch $0 {
                        case .setup, .waiting, .preparing, .ready:
                            break

                        case .failed, .cancelled:
                            if let index = self.connections.firstIndex(where: { $0 === connection }) {
                                self.connections.remove(at: index)
                            }

                        @unknown default:
                            break
                        }
                    }
                    connection.start(queue: self.queue)
                }

                listener.start(queue: queue)
            } else {
                throw Net.Error.version
            }
        }

    }

}

// MARK: - Method
extension Net.HTTP.Socket {

    func send(text: String) {
        connections.forEach {
            $0.send(content: text.data(using: .utf8), contentContext: context, isComplete: true, completion: .contentProcessed({ _ in }))
        }
    }

}
