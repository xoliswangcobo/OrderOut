//
//  AppContainer.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Swinject
import CoreLocation

class AppContainer {
    
    static let shared = AppContainer()
    
    let container = Container()
    
    private init() {
        setupDefaultContainers()
    }
    
    private func setupDefaultContainers() {
        
        container.register(LocationService.self) { _ in
            let service = OrderOutLocationService()
            service.requestAuthorisation()
            service.startLocationService()
            
            return service
        }
        
        container.register(HTTPClientService.self) { _ in
            return URLRequestClientService.init(host: AppConstants.baseURL)
        }
        
        container.register(OrderOutViewModel.self) { resolver in
            return OrderOutViewModel.init(service: resolver.resolve(HTTPClientService.self)!, locationService: resolver.resolve(LocationService.self)!)
        }
    }
}
