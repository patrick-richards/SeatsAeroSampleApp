//
//  TripExtensions.swift
//  Sero
//
//  Created on 13/6/2024.
//

import Foundation
import SeatsAeroAPI

extension Trip {
    var origin: Airport {
        let firstSegment = availabilitySegments.first!
        return Airport.withIdentifier(firstSegment.originAirport)!
    }
    
    var destination: Airport {
        let lastSegment = availabilitySegments.last!
        return Airport.withIdentifier(lastSegment.destinationAirport)!
    }
    
    var tripAirports: [Airport] {
        var segmentAirports = availabilitySegments.map { $0.originAirport }
        segmentAirports.append(availabilitySegments.last!.destinationAirport)
        return segmentAirports.map { Airport.withIdentifier($0)! }
        
    }
    
    var tripAirpotsAsString: String {
        let tripAirportIATAs = tripAirports.map { $0.iata }
        return tripAirportIATAs.joined(separator: " ✈ ")
    }
    
    var durationAsString: String {
        let hours = totalDuration / 60
        let minutes = totalDuration % 60
        return "\(hours)h \(minutes)min"
    }
    
    var pointsAsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedPoints = numberFormatter.string(from: NSNumber(value: mileageCost))!
        return "\(formattedPoints) points"
    }
    
    var costAsString: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        let formattedTaxes = numberFormatter.string(from: NSNumber(value: Float(totalTaxes) / 100.0))!
        
        return "\(taxesCurrencySymbol)\(formattedTaxes) \(taxesCurrency)"        
    }
    
    var remainingSeatsAsString: String {
        
        if remainingSeats == 0 {
            "Seats available"
        } else {
            remainingSeats == 1 ? "1 seat available" : "\(remainingSeats) seats available"
        }
    }
    
    
    static func sampleTripResponse() -> TripResponse {
        do {
            let tripResponse = try Bundle.main.decode(TripResponse.self, from: "trip_sample.json")
            return tripResponse
        } catch {
            fatalError("couldn't load sample trip response")
        }
    }
}

extension TripAvailabilitySegment {
    var flightCarrier: String {
        return flightNumber.trimmingCharacters(in: .decimalDigits)
    }
    
    var flightCarrierIconURL: URL {
        URL(string: "https://www.gstatic.com/flights/airline_logos/70px/\(flightCarrier.uppercased()).png")!
    }
}
