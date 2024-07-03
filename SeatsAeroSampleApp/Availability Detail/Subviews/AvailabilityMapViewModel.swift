//
//  AvailabilityMapViewModel.swift
//  Sero
//
//  Created on 18/6/2024.
//

import Foundation
import SeatsAeroAPI
import MapKit

extension AvailabilityMapView {
    @Observable
    class ViewModel {
        private(set) var availability: Availability
        
        init(availability: Availability) {
            self.availability = availability
        }
        
        var origin: Airport {
            Airport.withIdentifier(availability.route.originAirport)!
        }
        
        var destination: Airport {
            Airport.withIdentifier(availability.route.destinationAirport)!
        }
    }
}
