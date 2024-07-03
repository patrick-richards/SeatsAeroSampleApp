//
//  Query.swift
//  Sero
//
//  Created on 14/6/2024.
//

import Foundation

struct Query: Codable {
    var id: String = UUID().uuidString
    var search: Search
    var filter: SearchFilter
    
    var filterSummaryDescription: String {
        filter.summaryDescription
    }
}
