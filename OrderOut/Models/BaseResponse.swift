//
//  BaseResponse.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

class BaseResponse<Model: Decodable>: Decodable {
    let results: Model
    let status: String

    enum CodingKeys: String, CodingKey {
        case results, status
    }
}
