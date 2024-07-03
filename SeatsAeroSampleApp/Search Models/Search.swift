//
//  Search.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation
import SeatsAeroAPI

@Observable
class Search: Codable {
    var origins: [Airport] = [Airport.withIdentifier("MEL")!]
    var destinations: [Airport] = [Airport.withIdentifier("SYD")!]
    var startDate: Date = Date() {
        didSet {
            if startDate > endDate {
                endDate = startDate.addingTimeInterval(60 * 60 * 24 * 7)
            }
        }
    }
    
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)
    var selectedCabin: Cabin? = nil
}

extension Search {
    func reverseOriginAndDestination() {
        let origins = origins
        let destinations = destinations
        
        self.destinations = origins
        self.origins = destinations
    }
}
