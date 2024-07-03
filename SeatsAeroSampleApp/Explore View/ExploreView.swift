//
//  ExploreView.swift
//  Sero
//
//  Created on 17/6/2024.
//

import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: SingleSourcePickerView(selectedSource: $viewModel.explore.source)) {
                        HStack {
                            Text("Program")
                            Spacer()
                            Text(viewModel.explore.source.name)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: RegionPickerView(mode: .origin, selectedRegion: $viewModel.explore.origin)) {
                        HStack {
                            Text("Origin")
                            Spacer()
                            Image(systemName: "airplane.departure")
                            Text(viewModel.explore.origin?.rawValue ?? "Anywhere")
                        }
                    }
                    NavigationLink(destination: RegionPickerView(mode: .destnation, selectedRegion: $viewModel.explore.destination)) {
                        HStack {
                            Text("Destination")
                            Spacer()
                            Image(systemName: "airplane.arrival")
                            Text(viewModel.explore.destination?.rawValue ?? "Anywhere")
                        }
                    }
                    if viewModel.explore.origin != viewModel.explore.destination {
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
                }
                
                Section {
                    HStack {
                        DatePicker("Start date", selection: $viewModel.explore.startDate, in: Date()..., displayedComponents: .date)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        DatePicker("End date", selection: $viewModel.explore.endDate, in: viewModel.explore.startDate..., displayedComponents: .date)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section {
                    NavigationLink(destination: CabinPickerView(selectedCabin: $viewModel.explore.selectedCabin)) {
                        HStack {
                            Text("Cabin")
                            Spacer()
                            Text(viewModel.explore.selectedCabin?.rawValue.capitalized ?? "All cabins")
                        }
                    }
                }
                
                Section {
                    switch viewModel.loadingState {
                    case .none, .loading:
                        PlaneLoadingView().id(UUID().uuidString)
                    case .loaded, .loadingMoreResults:
                        if viewModel.results.isEmpty {
                            ContentUnavailableView.init(label: {
                                Label("No results", systemImage: "airplane.circle")
                            }, description: {
                                Text("Try a different search.")
                            })
                        } else {
                            ForEach(viewModel.results, id: \.id) { item in
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
                    Text(resultsCountString())
                }
            }.task {
                if viewModel.loadingState != .none {
                    return
                }
                
                await viewModel.refreshData()
            }
            .navigationBarTitle("Explore")
        }
        .navigationViewStyle(.stack)
    }
    
    func resultsCountString() -> String {
        if viewModel.loadingState != .loaded {
            return ""
        }
        
        let count = viewModel.results.count
        return count == 1 ? "1 result" : "\(count) results"
    }
}

#Preview {
    ExploreView()
}
