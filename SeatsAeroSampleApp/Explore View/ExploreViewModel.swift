//
//  ExploreViewModel.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation
import SwiftUI
import SeatsAeroAPI

extension ExploreView {
    @Observable
    class ViewModel {
        var explore = Explore(source: Source.velocity)
        
        private(set) var loadingState: LoadingState = .none
        
        private var lastResponse: BulkAvailabilityResponse? = nil
        private(set) var results = [Availability]()
        
        private let seatsAeroAPI = SeatsAeroAPI(apiKey: SeatsAeroSampleApp.apiKey())
        
        // this is set artificially now to demonstrate paging.
        // ideally this would be set as high as possible to cut down
        // api calls, which are capped daily
        private let pageSize = 25
        
        func reverseOriginAndDestination() {
            let origin = explore.origin
            let destination = explore.destination
            
            explore.destination = origin
            explore.origin = destination
            
            Task {
                await refreshData()
            }
        }
        
        var haveMoreResults: Bool {
            guard let response = lastResponse else {
                return false
            }
            
            return response.hasMore
        }
        
        init() {
            startObservation()
        }
        
        func startObservation() {
            withObservationTracking {
                _ = explore
            } onChange: {
                Task {
                    await self.refreshData()
                    self.startObservation()
                }
            }
        }
        
        func refreshData() async {
            loadingState = .loading
            results = []
            
            do {
                let exploreResponse = try await seatsAeroAPI.bulkAvailability(
                    source: explore.source,
                    originRegion: explore.origin,
                    destinationRegion: explore.destination,
                    startDate: explore.startDate,
                    endDate: explore.endDate,
                    cabin: explore.selectedCabin,
                    take: pageSize)
                
                results = exploreResponse.availabilities
                lastResponse = exploreResponse
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
                let exploreResponse = try await seatsAeroAPI.bulkAvailability(
                    source: explore.source,
                    originRegion: explore.origin,
                    destinationRegion: explore.destination,
                    startDate: explore.startDate,
                    endDate: explore.endDate,
                    cabin: explore.selectedCabin,
                    take: pageSize,
                    skip: results.count,
                    cursor: currentCursor)

                results.append(contentsOf: exploreResponse.availabilities)
                self.lastResponse = exploreResponse
                loadingState = .loaded
            } catch {
                loadingState = .failed
            }
        }
    }
}
