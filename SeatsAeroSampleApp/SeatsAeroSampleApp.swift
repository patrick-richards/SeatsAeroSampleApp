//
//  SeatsAeroSampleApp.swift
//  SeatsAeroSampleApp
//
//  Created on 19/6/2024.
//

import SwiftUI

@main
struct SeatsAeroSampleApp: App {
    static func apiKey() -> String {
        #error("Insert your Seats.aero API key here - https://seats.aero/apikey")
        return ""
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "globe.americas")
                    }
                AvailabilitySearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                SavedQueriesView()
                    .tabItem {
                        Label("Saved", systemImage: "heart")
                    }
            }
        }
    }
}
