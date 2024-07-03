//
//  AvailabilityCabinViewModel.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation
import SeatsAeroAPI

@Observable
class AvailabilityCabinViewModel {
    let availability: Availability
    let cabin: Cabin

    init(availability: Availability, cabin: Cabin) {
        self.availability = availability
        self.cabin = cabin
    }
    
    var cabinName: String {
        cabin.rawValue.capitalized
    }

    var availabilityFormatted: String {
        availability.availabilityFormatted(inCabin: cabin)
    }

    var hasDirectAvailability: Bool {
        availability.hasDirectAvailability(inCabin: cabin)
    }
}
