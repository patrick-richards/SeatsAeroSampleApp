//
//  AirportExtensions.swift
//  Sero
//
//  Created on 18/6/2024.
//

import Foundation
import SeatsAeroAPI
import MapKit

extension Airport: Identifiable {
    public var id: String {
        iata
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        hash
    }
}
