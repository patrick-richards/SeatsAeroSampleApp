//
//  AvailabilityDetailView.swift
//  Sero
//
//  Created on 12/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct AvailabilityDetailView: View {
    @State var viewModel: ViewModel
    
    var body: some View {
        List {
            Section {
                
            } header: {
                let viewModel = AvailabilityMapView.ViewModel(availability: viewModel.availability)
                AvailabilityMapView(viewModel: viewModel)
                    .cornerRadius(4)
                    .shadow(radius: 1.5)
                    .aspectRatio(1, contentMode: .fill)
            }
            .listRowInsets(EdgeInsets())
            
            switch viewModel.loadingState {
            case .none, .loading:
                PlaneLoadingView()
                    .id(UUID().uuidString)
            case .loaded, .loadingMoreResults:
                if viewModel.results.isEmpty {
                    ContentUnavailableView.init(label: {
                        Label("No results", systemImage: "airplane.circle")
                    }, description: {
                        Text("Try a different route or dates.")
                    })
                } else {
                    ForEach(Cabin.allCases.reversed(), id: \.rawValue) { cabin in
                        let filteredResults = viewModel.results(forCabin: cabin)
                        if filteredResults.count != 0 {
                            Section(header: Text(cabin.rawValue.uppercased())) {
                                ForEach(filteredResults, id: \.id) { trip in
                                    TripRowView(trip: trip)
                                }
                            }
                        }
                    }
                    
                }
            case .failed:
                ContentUnavailableView.init(label: {
                    Label("Loading failed", systemImage: "exclamationmark.icloud")
                }, description: { }) {
                    Text("Tap to retry.").onTapGesture {
                        Task {
                            await viewModel.refreshData()
                        }
                    }
                }
                
            }
        }
        .listStyle(.insetGrouped)
        .task {
            await viewModel.refreshData()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("\(viewModel.availability.route.originAirport) ✈ \(viewModel.availability.route.destinationAirport)")
                        .font(.callout)
                    Text(viewModel.availability.parsedDate, style: Text.DateStyle.date)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    struct Preview: View {
        var body: some View {
            let sampleAvailabilityResponse = Availability.sampleAvailabilityResponse()
            let availability = sampleAvailabilityResponse.availabilities[0]
            let viewModel = AvailabilityDetailView.ViewModel(availability: availability)
            AvailabilityDetailView(viewModel: viewModel)
        }
    }
    
    return Preview()
}
