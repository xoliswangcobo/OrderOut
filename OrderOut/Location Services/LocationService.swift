//
//  LocationService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

protocol LocationService {
    var userLocation:(lat: Double, lon: Double)? { get }
    var authorisationStatus:LocationStatus { get }
}

protocol LocationServiceDelegate {
    func locationDidUpdate(_ service: LocationService, _ location:(lat: Double, lon: Double))
    func authorisationStatusChanged(_ service: LocationService,_ locationStatus:LocationStatus)
    func locationErrorOccured(_ service: LocationService,_ error: Error)
}
