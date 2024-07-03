//
//  SavedQueryViewModel.swift
//  Sero
//
//  Created on 17/6/2024.
//

import Foundation

struct SavedQueryViewModel {
    private let query: Query
    
    init(query: Query) {
        self.query = query
    }
    
    var originsDescription: String {
        query.search.origins.map { $0.iata }.joined(separator: ", ")
    }
    
    var destinationsDescription: String {
        query.search.destinations.map { $0.iata }.joined(separator: ", ")
    }
    
    var startAndEndDateDescription: String {
        let startDate = query.search.startDate
        let endDate = query.search.endDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        return "\(dateFormatter.string(from: startDate))-\(dateFormatter.string(from: endDate))"
    }
    
    var filterHasNoParametersSet: Bool {
        query.filter.hasNoParametersSet
    }
    
    var filterSummaryDescription: String {
        query.filterSummaryDescription
    }
}
