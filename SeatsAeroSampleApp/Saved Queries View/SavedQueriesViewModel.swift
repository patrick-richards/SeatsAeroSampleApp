//
//  SavedQueriesViewModel.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation

extension SavedQueriesView {
    @Observable
    class ViewModel {
        private(set) var savedQueries: [Query] = [Query]()
        
        private var repository = SavedQueriesRepository()
        
        func loadQueries() {
            savedQueries = repository.loadSavedQueries()
        }
        
        func deleteSavedQueries(atOffsets offsets: IndexSet) {
            repository.delete(atOffsets: offsets)
            loadQueries()
        }
    }
}
