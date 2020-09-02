//
//  OrderOutClientService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

enum OrderOutClientService {
    case food(name:String, location:(lat:Double, lon:Double))
    case photo(reference:String)
}

extension OrderOutClientService: HTTPClientTask {
    
    var path: String {
        switch self {
            case .food:
                return "/maps/api/place/nearbysearch/json"
            case .photo:
                return "/maps/api/place/photo"
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .food(let name, let (lat, lon)):
            return [ "location": "\(lat),\(lon)", "type" : "restaurant", "radius" : AppConstants.searchRadius, "keyword" : name, "key" : AppConstants.apiKey ]
        case .photo(let reference):
            return [ "key" : AppConstants.apiKey, "photoreference" : reference, "maxwidth" : "400" ]
        }
    }
    
    var method: HTTPRequestMethod {
        .GET
    }
    
}
