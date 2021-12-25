//
//  HTTPService.swift
//  
//
//  Created by 杨柳 on 2021/12/24.
//

import Foundation
import Mongoose

extension Net.HTTP {

    final class Service {

        private var server: OpaquePointer!

        deinit {
            mg_destroy_server(&server)
        }

        init(port: String) {
            server =  mg_create_server(nil)
            mg_set_option(server, "listening_port", port)
            mg_set_option(server, "document_root", Bundle.module.resourcePath)
            mg_start_thread({
                while true {
                    mg_poll_server(.init($0), 1000)
                }
            }, .init(server))
        }

    }

}
