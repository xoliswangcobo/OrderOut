//
//  OrderOutLocationService.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import CoreLocation

class OrderOutLocationService: NSObject, LocationService {
    
    var userLocation: (lat: Double, lon: Double)? {
        (lat: self.locationManager.location?.coordinate.latitude, lon: self.locationManager.location?.coordinate.longitude) as? (lat: Double, lon: Double)
    }
    
    var authorisationStatus: LocationStatus {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined:
                    return .Unknown
                case .restricted, .denied:
                    return .NotAvailable
            case .authorizedAlways, .authorizedWhenInUse:
                    return .Available
                @unknown default:
                    return .Unknown
            }
        }
        
        return .NotAvailable
    }
    
    var delegate: LocationServiceDelegate?
    
    private let locationManager = CLLocationManager()
    
    func requestAuthorisation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationService() {
        self.locationManager.delegate = self
        self.locationManager.activityType = .other
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.startUpdatingLocation()
    }
}

extension OrderOutLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.authorisationStatusChanged(self, self.authorisationStatus)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.locationErrorOccured(self, error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard locations.count > 0, let location = locations.first else { return }
        
        self.delegate?.locationDidUpdate(self, (lat: location.coordinate.latitude, lon: location.coordinate.longitude))
    }
}
