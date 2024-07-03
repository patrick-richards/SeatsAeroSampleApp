//
//  Explore.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation
import SeatsAeroAPI

@Observable
class Explore {
    var source: Source
    var origin: Region? = .oceania
    var destination: Region? = .oceania
    var startDate: Date = Date() {
        didSet {
            if startDate < Date() {
                startDate = Date()
            }
            if startDate > endDate {
                self.endDate = startDate.addingTimeInterval(60 * 60 * 24 * 7)
            }
        }
    }
    
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7) {
        didSet {
            if endDate < startDate {
                endDate = startDate.addingTimeInterval(60 * 60 * 24)
            }
        }
    }

    var selectedCabin: Cabin? = nil
    
    init(source: Source) {
        self.source = source
    }
}
