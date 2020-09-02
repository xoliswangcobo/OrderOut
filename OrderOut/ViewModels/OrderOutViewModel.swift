//
//  OrderOutViewModel.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/29.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation
import Bond

enum OrderOutOperation {
    case FoodSearch, None
}

enum OrderOutMessage {
    case Message(text:String), None
}

class OrderOutViewModel {
    
    private var locationService: LocationService!
    private let service: HTTPClientService!
    
    init(service: HTTPClientService, locationService: LocationService) {
        self.service = service
        self.locationService = locationService
        self.locationService.delegate = self
    }
    
    // MARK: - Bond Binding
    var currentLocation = Observable<(latitude:Double, longitude:Double)>((latitude:AppConstants.extremeLatitude, longitude:AppConstants.extremeLongitude))
    var businesses = Observable<[Business]>([])
    var locationAvailable = Observable<Bool>(false)
    
    var orderOutOperation = Observable<OrderOutOperation?>(.None)
    var orderOutMessage = Observable<OrderOutMessage>(.None)
    
    func findFood(name: String) {
        self.orderOutOperation.send(.FoodSearch)
        if let userLocation = self.locationService.userLocation {
            self.service.execute(client: OrderOutClientService.food(name: name, location: (lat: userLocation.lat, lon: userLocation.lon))) { (error:Error?, response:BaseResponse<[Business]>?) in
                self.orderOutOperation.send(.None)
                if error == nil, (response?.results) != nil {
                    let _ = self.businesses.send((response?.results)!)
                } else {
                    self.orderOutMessage.send(.Message(text: error?.localizedDescription ?? "An error occured"))
                }
            }
        } else {
            self.orderOutMessage.send(.Message(text: "User location cannot be determined."))
        }
    }
    
    func photo(reference: String, completion: @escaping ((Data) -> Void)) {
        self.service.execute(client: OrderOutClientService.photo(reference: reference)) { (error, data:Data?) in
            if let data = data {
                completion(data)
            }
        }
    }
}

extension OrderOutViewModel: LocationServiceDelegate {
    
    func locationDidUpdate(_ service: LocationService, _ location: (lat: Double, lon: Double)) {
        self.currentLocation.send((latitude:location.lat, longitude:location.lon))
        self.locationAvailable.send(true)
    }
    
    func authorisationStatusChanged(_ service: LocationService, _ locationStatus: LocationStatus) {
        switch locationStatus {
            case .Available:
                self.locationAvailable.send(true)
            default:
                self.locationAvailable.send(false)
        }
    }
    
    func locationErrorOccured(_ service: LocationService, _ error: Error) {
        guard self.currentLocation.value.latitude == AppConstants.extremeLatitude, self.currentLocation.value.latitude == AppConstants.extremeLongitude else {
            return
        }
        
        self.locationAvailable.send(false)
    }
}
