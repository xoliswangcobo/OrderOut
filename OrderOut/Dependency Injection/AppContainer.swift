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
        
        container.register(HTTPClientService.self) { _ in
            return URLRequestClientService.init(host: AppConstants.baseURL)
        }
        
        container.register(MapViewModel.self) { resolver in
            return MapViewModel.init(service: resolver.resolve(HTTPClientService.self)!, locationManager: CLLocationManager.init())
        }
    }
}
