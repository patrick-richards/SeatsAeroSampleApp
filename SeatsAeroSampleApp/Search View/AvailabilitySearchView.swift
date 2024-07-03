//
//  AvailabilitySearchView.swift
//  Sero
//
//  Created on 12/6/2024.
//

import SwiftUI
import SeatsAeroAPI

struct AvailabilitySearchView: View {
    @State private var viewModel = ViewModel()
    @State private var filterViewModel = FilterViewModel()
    
    @State var savedQuery: Query?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: AirportPickerView(mode: .origin, allAirports: viewModel.allAirports, selectedAirports: $viewModel.search.origins)) {
                        HStack {
                            Text("Origin")
                            Spacer()
                            Image(systemName: "airplane.departure")
                            Text(formattedAirportList(viewModel.search.origins))
                        }
                    }
                    NavigationLink(destination: AirportPickerView(mode: .destination, allAirports: viewModel.allAirports, selectedAirports: $viewModel.search.destinations)) {
                        HStack {
                            Text("Destination")
                            Spacer()
                            Image(systemName: "airplane.arrival")
                            Text(formattedAirportList(viewModel.search.destinations))
                        }
                    }
                    Button(action: {
                        viewModel.reverseOriginAndDestination()
                    }) {
                        HStack {
                            Spacer()
                            Text("Reverse direction").fontWeight(.semibold)
                            Image(systemName: "arrow.uturn.forward.circle").fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.blue)
                }
                
                Section {
                    HStack {
                        DatePicker("Start date", selection: $viewModel.search.startDate, in: Date()..., displayedComponents: .date)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        DatePicker("End date", selection: $viewModel.search.endDate, in: viewModel.search.startDate..., displayedComponents: .date)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    NavigationLink(destination: CabinPickerView(selectedCabin: $viewModel.search.selectedCabin)) {
                        HStack {
                            Text("Cabin")
                            Spacer()
                            Text(viewModel.search.selectedCabin?.rawValue.capitalized ?? "All cabins")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AvailabilitySearchFilterView(viewModel: filterViewModel)) {
                        HStack {
                            Text("Filters")
                            Spacer()
                            Text(filterViewModel.summaryDescription)
                        }
                    }
                }
                
                Section {
                    switch viewModel.loadingState {
                    case .none, .loading:
                        PlaneLoadingView()
                            .id(UUID().uuidString)
                    case .loaded, .loadingMoreResults:
                        if filteredResults().isEmpty {
                            ContentUnavailableView.init(label: {
                                Label("No results", systemImage: "airplane.circle")
                            }, description: {
                                if haveFilteredResults() {
                                    Text(resultsHiddenByFilterString())
                                } else {
                                    Text("Try a different route or dates.")
                                }
                            })
                        } else {
                            ForEach(filteredResults(), id: \.id) { item in
                                NavigationLink(destination: AvailabilityDetailView(viewModel: AvailabilityDetailView.ViewModel(availability: item))) {
                                    AvailabilityRowView(viewModel: AvailabilityViewModel(availability: item))
                                }
                            }
                            
                            if viewModel.haveMoreResults {
                                PlaneLoadingView()
                                    .id(UUID().uuidString)
                                    .task {
                                        Task {
                                            await viewModel.loadNextPage()
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
                } footer: {
                    if viewModel.loadingState == .loaded {
                        if false == filteredResults().isEmpty {
                            if haveFilteredResults() {
                                Text(resultsHiddenByFilterString())
                            } else {
                                Text(resultsCountString())
                            }
                        }
                    }
                }
            }.task {
                setupSearchBar()

                if viewModel.loadingState != .none {
                    return
                }
                
                if let savedQuery = savedQuery {
                    viewModel.search = savedQuery.search
                    filterViewModel.filter = savedQuery.filter
                }
                
                await viewModel.refreshData()
            }
            .navigationBarTitle("Search")
            .toolbar {
                Menu("Share", systemImage: "heart") {
                    Button("Save Search") {
                        do {
                            try viewModel.saveSearch(withFilter: filterViewModel.filter)
                        } catch {
                            print("Error saving search")
                        }
                    }
                }
            }
            
        }
        .navigationViewStyle(.stack)
    }
    
    func setupSearchBar() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).title = "Done"
    }

    func filteredResults() -> [Availability] {
        return filterViewModel.filteredResults(viewModel.results, selectedCabin: viewModel.search.selectedCabin)
    }
    
    func numberOfFilteredResults() -> Int {
        if viewModel.results.count == 0 {
            return 0
        }
        
        return viewModel.results.count - filteredResults().count
    }
    
    func haveFilteredResults() -> Bool {
        return numberOfFilteredResults() != 0
    }
    
    func resultsHiddenByFilterString() -> String {
        let countString = numberOfFilteredResults() == 1 ? "1 result" : "\(numberOfFilteredResults()) results"
        
        return "\(countString) hidden by filters."
    }
    
    func resultsCountString() -> String {
        let count = viewModel.results.count
        return count == 1 ? "1 result" : "\(count) results"
    }
    
    func formattedAirportList(_ airports: [Airport]) -> String {
        return airports.map { $0.iata }.joined(separator: ", ")
    }
}

#Preview {
    AvailabilitySearchView()
}
