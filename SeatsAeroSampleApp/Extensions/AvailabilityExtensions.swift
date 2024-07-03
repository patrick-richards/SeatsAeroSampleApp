//
//  AvailabilityExtensions.swift
//  Sero
//
//  Created on 12/6/2024.
//

import Foundation
import SeatsAeroAPI

// https://thepointsguy.com/guide/airline-fare-classes/
// Y = economy
// W = premium economy
// J or C = business
// F = first

extension Availability {
    func hasAvailability(inCabin cabin: Cabin) -> Bool {
        switch cabin {
        case .economy: YAvailable
        case .premiumEconomy: WAvailable
        case .business: JAvailable
        case .first: FAvailable
        }
    }

    func hasDirectAvailability(inCabin cabin: Cabin?) -> Bool {
        guard let cabin = cabin else {
            return YDirect || WDirect || JDirect || FDirect
        }
        
        switch cabin {
        case .economy: return YDirect
        case .premiumEconomy: return WDirect
        case .business: return JDirect
        case .first: return FDirect
        }
    }
    
    func remainingSeats(inCabin cabin: Cabin?) -> Int {
        guard let cabin = cabin else {
            return max(YRemainingSeats, WRemainingSeats, JRemainingSeats, FRemainingSeats)
        }
        
        switch cabin {
        case .economy: return YRemainingSeats
        case .premiumEconomy: return WRemainingSeats
        case .business: return JRemainingSeats
        case .first: return FRemainingSeats
        }
    }
    
    func carriers(inCabin cabin: Cabin?) -> String {
        guard let cabin = cabin else {
            return [YAirlines, WAirlines, JAirlines, FAirlines].joined(separator: ", ")
        }
        
        switch cabin {
        case .economy: return YAirlines
        case .premiumEconomy: return WAirlines
        case .business: return JAirlines
        case .first: return FAirlines
        }
    }
    
    func availabilityFormatted(inCabin cabin: Cabin) -> String {
        let hasAvailability = hasAvailability(inCabin: cabin)
        let remainingSeats = remainingSeats(inCabin: cabin)
        let airlines = carriers(inCabin: cabin)
        if false == hasAvailability {
            return "-"
        }
        
        var seatsString = "Available"
        if remainingSeats != 0 {
            seatsString = remainingSeats == 1 ? "1 seat" : "\(remainingSeats) seats"
        }
        
        return "\(seatsString) (\(airlines))"
    }
    
    static func sampleAvailabilityResponse() -> AvailabilityResponse {
        do {
            let availabilityResponse = try Bundle.main.decode(AvailabilityResponse.self, from: "cached_search_sample.json")
            return availabilityResponse
        } catch {
            fatalError("couldn't load sample availability response")
        }
    }
}
