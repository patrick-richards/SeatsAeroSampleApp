//
//  SavedQueriesView.swift
//  Sero
//
//  Created on 14/6/2024.
//

import SwiftUI

struct SavedQueriesView: View {
    private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if viewModel.savedQueries.isEmpty {
                        ContentUnavailableView.init(label: {
                            Label("No saved searches", systemImage: "airplane.circle")
                        }, description: {
                            Text("Saved searches will appear here.")
                        })
                    } else {
                        ForEach(viewModel.savedQueries, id: \.id) { savedQuery in
                            NavigationLink(destination: AvailabilitySearchView(savedQuery: savedQuery)) {
                                let viewModel = SavedQueryViewModel(query: savedQuery)
                                SavedQueryRowView(viewModel: viewModel)
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }.task {
                viewModel.loadQueries()
            }
            .navigationBarTitle("Saved Searches")
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.deleteSavedQueries(atOffsets: offsets)
        }
    }
}

#Preview {
    SavedQueriesView()
}
