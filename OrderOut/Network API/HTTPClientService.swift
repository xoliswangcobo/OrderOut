//
//  HTTPClientService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

protocol HTTPClientService {
    
    var host: URL { get set }
    
    func execute(client: HTTPClientTask, responseHandler: @escaping (Error?, Data?) -> Void)
    func execute(client: HTTPClientTask, responseHandler: @escaping (Error?, Any?) -> Void)
    func execute<Model : Decodable>(client: HTTPClientTask, responseHandler: @escaping (Error?, Model?) -> Void)
}
