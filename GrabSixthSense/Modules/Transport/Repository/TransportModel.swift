//
//  TransportModel.swift
//  GrabSixthSense
//
//  Created by Muhammad Ziddan on 28/07/24.
//

import Foundation
import CoreLocation

struct DestinationSuggestionResponse: Decodable {
    var results: [DestinationSuggestionList]?
}

struct DestinationSuggestionList: Decodable {
    let formattedAddress: String?
    let geometry: GeometryLocation?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry = "geometry"
        case name = "name"
    }
}

struct GeometryLocation: Decodable {
    let location: Location?
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
}

struct Location: Decodable {
    let lat: Double?
    let lng: Double?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}

struct DistanceMatrixResponse: Decodable {
    let rows: [Row]
}

struct Row: Decodable {
    let elements: [Element]
}

struct Element: Decodable {
    let distance: Distance
}

struct Distance: Decodable {
    let value: Int
}
