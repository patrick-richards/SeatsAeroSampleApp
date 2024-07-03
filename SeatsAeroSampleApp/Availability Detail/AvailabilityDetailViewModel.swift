//
//  AvailabilityDetailViewModel.swift
//  Sero
//
//  Created on 13/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI

extension AvailabilityDetailView {
    @Observable
    class ViewModel {
        let availability: Availability

        private(set) var loadingState: LoadingState = .none
        private(set) var results = [Trip]()
        
        init(availability: Availability) {
            self.availability = availability
        }
        
        func refreshData() async {
            loadingState = .loading
            results = []
            
            let seatsAeroAPI = SeatsAeroAPI(apiKey: SeatsAeroSampleApp.apiKey())
            do {
                let tripResponse = try await seatsAeroAPI.getTrips(availability: availability)
                
                results = tripResponse.trips
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func results(forCabin cabin: Cabin) -> [Trip] {
            results.filter({ $0.cabin.lowercased() == cabin.rawValue.lowercased()})
        }
    }
}
