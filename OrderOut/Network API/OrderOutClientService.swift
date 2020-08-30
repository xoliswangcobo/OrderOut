//
//  OrderOutClientService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

enum OrderOutClientService {
    case get(parameter:Any)
}

extension OrderOutClientService: HTTPClientTask {
    
    var path: String {
        ""
    }
    
    var method: HTTPRequestMethod {
        .GET
    }
    
}
