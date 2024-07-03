//
//  AvailabilitySearchViewModel.swift
//  Sero
//
//  Created on 12/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI

extension AvailabilitySearchView {
    @Observable
    class ViewModel {
        var search = Search()
        
        private(set) var loadingState: LoadingState = .none
        
        private var lastResponse: AvailabilityResponse? = nil
        private(set) var results = [Availability]()
        
        private let seatsAeroAPI = SeatsAeroAPI(apiKey: SeatsAeroSampleApp.apiKey())
        private let pageSize = 500
        
        private(set) var allAirports = Airport.allAirports()

        init() {
            startObservation()
        }
        
        func startObservation() {
            withObservationTracking {
                _ = search
            } onChange: {
                Task {
                    await self.refreshData()
                    self.startObservation()
                }
            }
        }
        
        func reverseOriginAndDestination() {
            search.reverseOriginAndDestination()
            
            Task {
                await self.refreshData()
            }
        }
        
        var haveMoreResults: Bool {
            guard let response = lastResponse else {
                return false
            }
            
            return response.hasMore
        }
        
        func refreshData() async {
            loadingState = .loading
            results = []
            
            let seatsAeroAPI = SeatsAeroAPI(apiKey: SeatsAeroSampleApp.apiKey())
            do {
                let availabilityResponse = try await seatsAeroAPI.cachedSearch(
                    origins: search.origins,
                    destinations: search.destinations,
                    startDate: search.startDate,
                    endDate: search.endDate,
                    cabin: search.selectedCabin,
                    take: pageSize)
                
                results = availabilityResponse.availabilities
                lastResponse = availabilityResponse
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func loadNextPage() async {
            if false == haveMoreResults {
                return
            }
            
            guard let response = lastResponse else {
                return
            }
            
            loadingState = .loadingMoreResults
            let currentCursor = response.cursor
            
            do {
                let availabilityResponse = try await seatsAeroAPI.cachedSearch(
                    origins: search.origins,
                    destinations: search.destinations,
                    startDate: search.startDate,
                    endDate: search.endDate,
                    cabin: search.selectedCabin,
                    take: pageSize,
                    skip: results.count,
                    cursor: currentCursor)
                
                results.append(contentsOf: availabilityResponse.availabilities)
                self.lastResponse = availabilityResponse
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
        
        func saveSearch(withFilter filter: SearchFilter) throws {
            let repository = SavedQueriesRepository()
            try repository.saveQuery(withSearch: search, filter: filter)
        }
    }
    
    @Observable
    class FilterViewModel {
        var filter = SearchFilter()
        
        func resetFilter() {
            filter = SearchFilter()
        }
        
        var sourcesSummaryDescription: String {
            filter.sourcesSummaryDescription
        }
        
        var summaryDescription: String {
            filter.summaryDescription
        }
        
        func filteredResults(_ allResults: [Availability], selectedCabin: Cabin?) -> [Availability] {
            return filter.filteredResults(allResults, selectedCabin: selectedCabin)
        }
    }
}
