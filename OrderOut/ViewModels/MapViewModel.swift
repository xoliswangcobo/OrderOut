//
//  MapViewModel.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import CoreLocation
import Bond

class MapViewModel {
    
    private let locationManager: CLLocationManager!
    private let service: HTTPClientService!
    
    init(service: HTTPClientService, locationManager: CLLocationManager) {
        self.service = service
        self.locationManager = locationManager
    }
}
