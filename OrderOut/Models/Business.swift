//
//  Business.swift
//  OrderOut
//
//  Created by Xoliswa on 2020/08/30.
//  Copyright © 2020 Xoliswa. All rights reserved.
//

import Foundation

// MARK: - Business
class Business: Decodable {
    let businessStatus: String
    let geometry: Geometry
    let icon: String
    let name: String
    let photos: [Photo]?
    let placeID: String
    let rating: Double
    let reference, scope: String
    let types: [String]
    let userRatingsTotal: Int
    let vicinity: String

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon, name
        case photos
        case placeID = "place_id"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

// MARK: - Geometry
class Geometry: Decodable {
    let location: Location
    let viewport: Viewport

    init(location: Location, viewport: Viewport) {
        self.location = location
        self.viewport = viewport
    }
}

// MARK: - Location
class Location: Decodable {
    let lat, lng: Double

    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

// MARK: - Viewport
class Viewport: Decodable {
    let northeast, southwest: Location

    init(northeast: Location, southwest: Location) {
        self.northeast = northeast
        self.southwest = southwest
    }
}

// MARK: - OpeningHours
class OpeningHours: Decodable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }

    init(openNow: Bool) {
        self.openNow = openNow
    }
}

// MARK: - Photo
class Photo: Decodable {
    let photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
