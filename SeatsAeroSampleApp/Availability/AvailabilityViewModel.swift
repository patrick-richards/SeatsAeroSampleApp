//
//  AvailabilityViewModel.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation
import SeatsAeroAPI

@Observable
class AvailabilityViewModel {
    private(set) var availability: Availability
    
    init(availability: Availability) {
        self.availability = availability
    }

    func hasAvailability(inCabin cabin: Cabin) -> Bool {
        availability.hasAvailability(inCabin: cabin)
    }
    
    var origin: String {
        availability.route.originAirport
    }

    var destination: String {
        availability.route.destinationAirport
    }

    var date: Date {
        availability.parsedDate
    }

    var sourceCarrier: String {
        availability.source.relatedCarrier
    }
    
    var sourceName: String {
        availability.source.name
    }
}
