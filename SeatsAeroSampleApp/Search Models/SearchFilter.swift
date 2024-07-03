//
//  SearchFilter.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation
import SeatsAeroAPI

struct SearchFilter: Codable {
    var sources: [Source] = [Source]()
    var directOnly: Bool = false
    var operatingCarriers: String = ""
    var minimumSeats: Int = 1
}

extension SearchFilter {
    var hasNoParametersSet: Bool {
        sources.count == 0 && directOnly == false && operatingCarriers == "" && minimumSeats == 1
    }
    
    var summaryDescription: String {
        var filterDescriptors: [String] = []
        if sources.count > 0 {
            filterDescriptors.append(sources.count == 1 ? "1 program" : "\(sources.count) programs")
        }
        
        if directOnly {
            filterDescriptors.append("direct only")
        }
        
        if operatingCarriers != "" {
            filterDescriptors.append("\(operatingCarriers)")
        }
        
        if minimumSeats != 1 {
            filterDescriptors.append("\(minimumSeats) seats")
        }
        
        let finalString = filterDescriptors.count == 0 ? "none" : filterDescriptors.joined(separator: ", ")
        return finalString.prefix(1).uppercased() + finalString.dropFirst()
    }
    
    var sourcesSummaryDescription: String {
        if sources.count == 0 {
            "All programs"
        } else if sources.count < 3 {
            sources.map { $0.name }.joined(separator: ", ")
        } else {
            "\(sources.first!.name) & \(sources.count) others"
        }
    }
    
    func filteredResults(_ allResults: [Availability], selectedCabin: Cabin?) -> [Availability] {
        return allResults.filter { availability in
            var sourcesOk = true
            if sources.count != 0 {
                sourcesOk = sources.contains(where: { $0 == availability.source })
            }
            
            var directOk = true
            if directOnly {
                directOk = availability.hasDirectAvailability(inCabin: selectedCabin)
            }
            
            var seatsOk = true
            if minimumSeats != 1 {
                seatsOk = availability.remainingSeats(inCabin: selectedCabin) > minimumSeats
            }
            
            var operatingCarriersOk = true
            if operatingCarriers != "" {
                let operatingCarriersString = String(operatingCarriers.filter{ !$0.isWhitespace })
                let desiredOperatingCarriers = Array(operatingCarriersString.components(separatedBy: ","))
                let flightCarriersString = availability.carriers(inCabin: selectedCabin)
                desiredOperatingCarriers.forEach { desiredOperatingCarrier in
                    if false == flightCarriersString.contains(desiredOperatingCarrier) {
                        operatingCarriersOk = false
                    }
                }
            }
            
            let result = sourcesOk && directOk && seatsOk && operatingCarriersOk
            return result
        }
    }
}
